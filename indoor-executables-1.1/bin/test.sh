#!/bin/bash

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
echo $script_dir
export PATH=$PATH:$script_dir

echo "######## Running: pcl_kinfu_largeScale_release.exe"
pcl_kinfu_largeScale_release.exe

echo "######## Running: GlobalRegistration.exe"
GlobalRegistration.exe

echo "######## Running: GraphOptimizer.exe"
GraphOptimizer.exe

echo "######## Running: BuildCorrespondence.exe"
BuildCorrespondence.exe

echo "######## Running: FragmentOptimizer.exe"
FragmentOptimizer.exe

echo "######## Running: Integrate.exe"
Integrate.exe

echo "######## Running: pcl_kinfu_largeScale_mesh_output_release.exe"
pcl_kinfu_largeScale_mesh_output_release.exe

echo "######## Running: pcl_viewer_release.exe"
pcl_viewer_release.exe

