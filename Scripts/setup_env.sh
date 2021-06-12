#!/usr/bin/env bash
# Source this file to set up the environment.
# pcl_viewer() is not supported

set -eu

echo "#########################################################################"

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
BIN_DIR=`realpath ${SCRIPT_DIR}/../build/bin`
PCL_BIN_DIR=`realpath ${SCRIPT_DIR}/../../StanfordPCL/build/bin`
echo "BIN_DIR: ${BIN_DIR}"
echo "PCL_BIN_DIR: ${PCL_BIN_DIR}"

export pcl_kinfu_largeScale=${PCL_BIN_DIR}/pcl_kinfu_largeScale
export GlobalRegistration=${BIN_DIR}/GlobalRegistration
export GraphOptimizer=${BIN_DIR}/GraphOptimizer
export BuildCorrespondence=${BIN_DIR}/BuildCorrespondence
export FragmentOptimizer=${BIN_DIR}/FragmentOptimizer
export Integrate=${BIN_DIR}/Integrate
export pcl_kinfu_largeScale_mesh_output=${PCL_BIN_DIR}/pcl_kinfu_largeScale_mesh_output

echo "# pcl_kinfu_largeScale:"             && ls -alh ${pcl_kinfu_largeScale}
echo "# GlobalRegistration:"               && ls -alh ${GlobalRegistration}
echo "# GraphOptimizer:"                   && ls -alh ${GraphOptimizer}
echo "# BuildCorrespondence:"              && ls -alh ${BuildCorrespondence}
echo "# FragmentOptimizer:"                && ls -alh ${FragmentOptimizer}
echo "# Integrate:"                        && ls -alh ${Integrate}
echo "# pcl_kinfu_largeScale_mesh_output:" && ls -alh ${pcl_kinfu_largeScale_mesh_output}

echo "#########################################################################"
