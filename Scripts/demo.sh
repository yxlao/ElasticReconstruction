#!/usr/bin/env bash
set -eu

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source ${SCRIPT_DIR}/setup_env.sh

# Customizable Sandbox directory
SANDBOX_DIR=${SCRIPT_DIR}/../Sandbox # Default
# SANDBOX_DIR=${SCRIPT_DIR}/../SandboxFullRes
# SANDBOX_DIR=${SCRIPT_DIR}/../SandboxDownsample

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
${pcl_kinfu_largeScale} -r -ic -sd 10 -oni ${SANDBOX_DIR}/input.oni -vs 4 \
    --fragment 25 --rgbd_odometry --record_log ${SANDBOX_DIR}/100-0.log \
    --camera longrange.param
mkdir -p ${SANDBOX_DIR}/pcds/
mv cloud_bin* ${SANDBOX_DIR}/pcds/

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
${GlobalRegistration} ${SANDBOX_DIR}/pcds/ ${SANDBOX_DIR}/100-0.log 50
mv init.log ${SANDBOX_DIR}/
mv pose.log ${SANDBOX_DIR}/
mv odometry.* ${SANDBOX_DIR}/
mv result.* ${SANDBOX_DIR}/

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
${GraphOptimizer} -w 100 \
    --odometry ${SANDBOX_DIR}/odometry.log \
    --odometryinfo ${SANDBOX_DIR}/odometry.info \
    --loop ${SANDBOX_DIR}/result.txt \
    --loopinfo ${SANDBOX_DIR}/result.info \
    --pose ${SANDBOX_DIR}/pose.log \
    --keep ${SANDBOX_DIR}/keep.log \
    --refine ${SANDBOX_DIR}/pcds/reg_refine_all.log

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
    --reg_traj ${SANDBOX_DIR}/pcds/reg_refine_all.log \
    --registration \
    --reg_dist 0.05 \
    --reg_ratio 0.25 \
    --reg_num 0 \
    --save_xyzn
mv reg_output.* ${SANDBOX_DIR}/

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
NUM_PCDS=$(ls ${SANDBOX_DIR}/pcds/cloud_bin_*.pcd -l | wc -l | tr -d ' ')
# ${FragmentOptimizer} --rigid \
#     --rgbdslam ${SANDBOX_DIR}/init.log \
#     --registration ${SANDBOX_DIR}/reg_output.log \
#     --dir ${SANDBOX_DIR}/pcds/ \
#     --num $NUM_PCDS \
#     --resolution 12 \
#     --iteration 10 \
#     --length 4.0 \
#     --write_xyzn_sample 10
${FragmentOptimizer} --slac \
    --rgbdslam ${SANDBOX_DIR}/init.log \
    --registration ${SANDBOX_DIR}/reg_output.log \
    --dir ${SANDBOX_DIR}/pcds/ \
    --num $NUM_PCDS \
    --resolution 12 \
    --iteration 10 \
    --length 4.0 \
    --write_xyzn_sample 10
mv pose.log ${SANDBOX_DIR}/pose_slac.log
mv output.ctr ${SANDBOX_DIR}/
mv sample.pcd ${SANDBOX_DIR}/

# Part VI: Integration
# Inputs:
#     Sandbox/pose_slac.log
#     Sandbox/100-0.log
#     Sandbox/output.ctr
#     Sandbox/input.oni
#     Scripts/longrange.param
# Outputs:
#     Scripts/world.pcd
${Integrate} --pose_traj ${SANDBOX_DIR}/pose_slac.log \
    --seg_traj ${SANDBOX_DIR}/100-0.log \
    --ctr ${SANDBOX_DIR}/output.ctr \
    --num ${NUM_PCDS} \
    --resolution 12 \
    --camera longrange.param \
    -oni ${SANDBOX_DIR}/input.oni \
    --length 4.0 \
    --interval 50

# Part VII: Extract mesh
# Inputs:
#     Scripts/world.pcd
# Outputs:
#     Sandbox/ply/mesh_xx.ply * 7
${pcl_kinfu_largeScale_mesh_output} world.pcd -vs 4
mkdir ${SANDBOX_DIR}/ply/
mv *.ply ${SANDBOX_DIR}/ply/
mv world.pcd ${SANDBOX_DIR}/

# Part VIII: Visualization
# MeshLab
#     -> import all ply files
#     -> merge visible layers
#     -> make sure "remove duplicated vertices/faces" are checked
#     -> export final model
python view_results.py
