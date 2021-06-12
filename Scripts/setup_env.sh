#!/usr/bin/env bash
# Source this file to set up the environment.

set -eu

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
BIN_DIR=`realpath ${SCRIPT_DIR}/../build/bin`
PCL_BIN_DIR=`realpath ${SCRIPT_DIR}/../../StanfordPCL/build/bin`
echo "BIN_DIR: ${BIN_DIR}"
echo "PCL_BIN_DIR: ${PCL_BIN_DIR}"

export pcl_kinfu_largeScale_release=${PCL_BIN_DIR}/pcl_kinfu_largeScale
echo "pcl_kinfu_largeScale_release:"
ls -alh ${pcl_kinfu_largeScale_release}

# GlobalRegistration.exe
# GraphOptimizer.exe
# BuildCorrespondence.exe
# FragmentOptimizer.exe
# Integrate.exe
# pcl_kinfu_largeScale_mesh_output_release.exe
# pcl_viewer_release.exe
