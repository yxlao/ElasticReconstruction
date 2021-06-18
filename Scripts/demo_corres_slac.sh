#!/usr/bin/env bash
set -eu

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source ${SCRIPT_DIR}/setup_env.sh

# Customizable Sandbox directory
# SANDBOX_DIR=${SCRIPT_DIR}/../Sandbox # Default
# SANDBOX_DIR=${SCRIPT_DIR}/../SandboxFullRes
SANDBOX_DIR=${SCRIPT_DIR}/../SandboxDownsample

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
