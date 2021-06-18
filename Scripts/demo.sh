#!/usr/bin/env bash
set -eu

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source ${SCRIPT_DIR}/setup_env.sh

# Number of CPU cores, not counting hyper-threading:
# https://stackoverflow.com/a/6481016/1255535
#
# Typically, set max # of threads to the # of physical cores, not logical:
# https://www.thunderheadeng.com/2014/08/openmp-benchmarks/
# https://stackoverflow.com/a/36959375/1255535
NUM_CORES=$(grep ^cpu\\scores /proc/cpuinfo | uniq |  awk '{print $4}')
export OMP_NUM_THREADS=${NUM_CORES}
echo "OMP_NUM_THREADS: ${OMP_NUM_THREADS}"

# Part I: Create fragments
# Inputs:
#     Sandbox/input.oni
#     Scripts/longrange.param
# Outputs:
#     Sandbox/pcds/cloud_bin_xxx.pcd * 57
#     Sandbox/100-0.log                             # 08∶39∶11 PM PDT
${pcl_kinfu_largeScale} -r -ic -sd 10 -oni ../Sandbox/input.oni -vs 4 \
    --fragment 25 --rgbd_odometry --record_log ../Sandbox/100-0.log \
    --camera longrange.param
mkdir -p ../Sandbox/pcds/
mv cloud_bin* ../Sandbox/pcds/

# Part II: Global registration
# Inputs:
#     Sandbox/pcds/cloud_bin_xxx.pcd * 57
#     Sandbox/100-0.log
# Outputs:
#     Sandbox/init.log      # create_init_traj()    # 08∶39∶11 PM PDT
#     Sandbox/odometry.info # create_odometry()     # 08∶39∶22 PM PDT
#     Sandbox/odometry.log  # create_odometry()     # 08∶39∶22 PM PDT
#     Sandbox/result.txt    # do_all()              # 01∶09∶55 AM PDT
#     Sandbox/result.info   # do_all()              # 01∶09∶55 AM PDT
#     Sandbox/pose.log      # create_pose_traj()    # 01∶09∶55 AM PDT
${GlobalRegistration} ../Sandbox/pcds/ ../Sandbox/100-0.log 50
mv init.log ../Sandbox/
mv pose.log ../Sandbox/
mv odometry.* ../Sandbox/
mv result.* ../Sandbox/

# Part III: Graph optimization
# Inputs:
#     Sandbox/init.log
#     Sandbox/odometry.info
#     Sandbox/odometry.log
#     Sandbox/result.txt
#     Sandbox/result.info
#     Sandbox/pose.log
#     (no need to use Sandbox/pcds/cloud_bin_xxx.pcd, no `loadPCDFile`)
# Outputs:
#     Sandbox/keep.log                          # 01∶09∶55 AM PDT
#     Sandbox/pcds/reg_refine_all.log           # 01∶09∶55 AM PDT
loop_remain_log_file_
${GraphOptimizer} -w 100 \
    --odometry ../Sandbox/odometry.log \
    --odometryinfo ../Sandbox/odometry.info \
    --loop ../Sandbox/result.txt \
    --loopinfo ../Sandbox/result.info \
    --pose ../Sandbox/pose.log \
    --keep ../Sandbox/keep.log \
    --refine ../Sandbox/pcds/reg_refine_all.log

# Part IV: Build correspondence
# Inputs:
#     Sandbox/pcds/cloud_bin_xxx.pcd
#     Sandbox/pcds/reg_refine_all.log
# Outputs:
#     Sandbox/pcds/cloud_bin_xyzn_xx.xyzn * 57  # 01∶09∶56 AM PDT
#     Sandbox/pcds/corres_xx_xx.txt       * 221 # 01∶46∶40 AM PDT (the last one)
#     Sandbox/reg_output.log                    # 01∶46∶35 AM PDT
#     Sandbox/reg_output.info (optional)
${BuildCorrespondence} \
    --reg_traj ../Sandbox/pcds/reg_refine_all.log \
    --registration \
    --reg_dist 0.05 \
    --reg_ratio 0.25 \
    --reg_num 0 \
    --save_xyzn
mv reg_output.* ../Sandbox/

# Part V: SLAC (or rigid) optimization
# Inputs:
#     Sandbox/pcds/cloud_bin_xxx.pcd * 57
#     Sandbox/pcds/corres_xx_xx.txt  * 221
#     Sandbox/init.log
#     Sandbox/reg_output.log
# Outputs:
#     Sandbox/pose_slac.log                     # 01∶52∶21 AM PDT
#     Sandbox/output.ctr                        # 01∶52∶21 AM PDT
#     Sandbox/sample.pcd                        # 01∶52∶22 AM PDT
NUM_PCDS=$(ls ../Sandbox/pcds/cloud_bin_*.pcd -l | wc -l | tr -d ' ')
# ${FragmentOptimizer} --rigid \
#     --rgbdslam ../Sandbox/init.log \
#     --registration ../Sandbox/reg_output.log \
#     --dir ../Sandbox/pcds/ \
#     --num $NUM_PCDS \
#     --resolution 12 \
#     --iteration 10 \
#     --length 4.0 \
#     --write_xyzn_sample 10
${FragmentOptimizer} --slac \
    --rgbdslam ../Sandbox/init.log \
    --registration ../Sandbox/reg_output.log \
    --dir ../Sandbox/pcds/ \
    --num $NUM_PCDS \
    --resolution 12 \
    --iteration 10 \
    --length 4.0 \
    --write_xyzn_sample 10
mv pose.log ../Sandbox/pose_slac.log
mv output.ctr ../Sandbox/
mv sample.pcd ../Sandbox/

# Part VI: Integration
# Inputs:
#     Sandbox/pose_slac.log
#     Sandbox/100-0.log
#     Sandbox/output.ctr
#     Sandbox/input.oni
#     Scripts/longrange.param
# Outputs:
#     Scripts/world.pcd
${Integrate} --pose_traj ../Sandbox/pose_slac.log \
    --seg_traj ../Sandbox/100-0.log \
    --ctr ../Sandbox/output.ctr \
    --num ${NUM_PCDS} \
    --resolution 12 \
    --camera longrange.param \
    -oni ../Sandbox/input.oni \
    --length 4.0 \
    --interval 50

# Part VII: Extract mesh
# Inputs:
#     Scripts/world.pcd
# Outputs:
#     Sandbox/ply/mesh_xx.ply * 7
${pcl_kinfu_largeScale_mesh_output} world.pcd -vs 4
mkdir ../Sandbox/ply/
mv *.ply ../Sandbox/ply/
mv world.pcd ../Sandbox/

# Part VIII: Visualization
# MeshLab
#     -> import all ply files
#     -> merge visible layers
#     -> make sure "remove duplicated vertices/faces" are checked
#     -> export final model
python view_results.py
