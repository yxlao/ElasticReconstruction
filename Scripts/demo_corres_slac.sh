#!/usr/bin/env bash
set -eu

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source ${SCRIPT_DIR}/setup_env.sh

# Customizable Sandbox directory
# SANDBOX_DIR=${SCRIPT_DIR}/../Sandbox # Default
# SANDBOX_DIR=${SCRIPT_DIR}/../SandboxFullRes
SANDBOX_DIR=${SCRIPT_DIR}/../SandboxNoisyDownsample

# Number of CPU cores, not counting hyper-threading:
# https://stackoverflow.com/a/6481016/1255535
#
# Typically, set max # of threads to the # of physical cores, not logical:
# https://www.thunderheadeng.com/2014/08/openmp-benchmarks/
# https://stackoverflow.com/a/36959375/1255535
NUM_CORES=$(grep ^cpu\\scores /proc/cpuinfo | uniq |  awk '{print $4}')
export OMP_NUM_THREADS=${NUM_CORES}
echo "OMP_NUM_THREADS: ${OMP_NUM_THREADS}"

# Part IV: Build correspondence
# Inputs:
#     Sandbox/pcds/cloud_bin_xxx.pcd
#     Sandbox/pcds/reg_refine_all.log
# Outputs:
#     Sandbox/pcds/cloud_bin_xyzn_xx.xyzn * 57  # 01∶09∶56 AM PDT
#     Sandbox/pcds/corres_xx_xx.txt       * 221 # 01∶46∶40 AM PDT (the last one)
#     Sandbox/reg_output.log                    # 01∶46∶35 AM PDT
#     Sandbox/reg_output.info (optional)
echo "Downsampling point cloud, saving to SandboxDownsample/pcds."
python downsample.py \
    --voxel_size 0.05 \
    --src_dir ${SCRIPT_DIR}/../SandboxNoisyFullRes/pcds \
    --dst_dir ${SANDBOX_DIR}/pcds

# reg_dist=SLACOptimizerParams.distance_threshold_
# reg_ratio=SLACOptimizerParams.fitness_threshold_
${BuildCorrespondence} \
    --reg_traj ${SANDBOX_DIR}/pcds/reg_refine_all.log \
    --registration \
    --reg_dist 0.07 \
    --reg_ratio 0.3 \
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
    --resolution 8 \
    --iteration 10 \
    --length 4.0 \
    --write_xyzn_sample 10 \
    --blacklistpair 1000  # If too large, all correspondence will be ingored
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
echo "To run: Integrate"
${Integrate} --pose_traj ${SANDBOX_DIR}/pose_slac.log \
    --seg_traj ${SANDBOX_DIR}/100-0.log \
    --ctr ${SANDBOX_DIR}/output.ctr \
    --num ${NUM_PCDS} \
    --resolution 8 \
    --camera longrange.param \
    -oni ${SANDBOX_DIR}/input.oni \
    --length 4.0 \
    --interval 50
echo "Done: Integrate"
