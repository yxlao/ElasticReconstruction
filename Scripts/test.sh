#!/usr/bin/env bash
# Run this file to call all executables (without parameters).

set -eu

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source ${SCRIPT_DIR}/setup_env.sh

echo "# Testing pcl_kinfu_largeScale:"             && ${pcl_kinfu_largeScale} || true
echo "# Testing GlobalRegistration:"               && ${GlobalRegistration} || true
echo "# Testing GraphOptimizer:"                   && ${GraphOptimizer} || true
echo "# Testing BuildCorrespondence:"              && ${BuildCorrespondence} || true
echo "# Testing FragmentOptimizer:"                && ${FragmentOptimizer} || true
echo "# Testing Integrate:"                        && ${Integrate} || true
echo "# Testing pcl_kinfu_largeScale_mesh_output:" && ${pcl_kinfu_largeScale_mesh_output} || true
