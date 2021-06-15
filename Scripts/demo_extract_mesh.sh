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

# Part V: SLAC (or rigid) optimization
NUM_PCDS=$(ls ../Sandbox/pcds/cloud_bin_*.pcd -l | wc -l | tr -d ' ')

# Part VII: Extract mesh
${pcl_kinfu_largeScale_mesh_output} world.pcd -vs 4
mkdir ../Sandbox/ply/
mv *.ply ../Sandbox/ply/
