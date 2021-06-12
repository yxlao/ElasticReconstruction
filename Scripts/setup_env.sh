#!/bin/bash
# Source this file to set up the environment.

set -eu

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PCL_BUILD_DIR=${SCRIPT_DIR}/../../StanfordPCL/build

export pcl_kinfu_largeScale_release=${PCL_BUILD_DIR}/bin/pcl_kinfu_largeScale
echo "pcl_kinfu_largeScale_release:"
ls -alh ${pcl_kinfu_largeScale_release}

# GlobalRegistration.exe
# GraphOptimizer.exe
# BuildCorrespondence.exe
# FragmentOptimizer.exe
# Integrate.exe
# pcl_kinfu_largeScale_mesh_output_release.exe
# pcl_viewer_release.exe


echo "pcl_kinfu_largeScale_release:"
ls -alh ${pcl_kinfu_largeScale_release}
