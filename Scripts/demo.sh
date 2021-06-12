#!/usr/bin/env bash
set -eu

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source ${SCRIPT_DIR}/setup_env.sh

${pcl_kinfu_largeScale} -r -ic -sd 10 -oni ../Sandbox/input.oni -vs 4 \
    --fragment 25 --rgbd_odometry --record_log ../Sandbox/100-0.log \
    --camera longrange.param
mkdir -p ../Sandbox/pcds/
mv cloud_bin* ../Sandbox/pcds/

# GlobalRegistration.exe ../Sandbox/pcds/ ../Sandbox/100-0.log 50
# mv init.log ../Sandbox/
# mv pose.log ../Sandbox/
# mv odometry.* ../Sandbox/
# mv result.* ../Sandbox/

# GraphOptimizer.exe -w 100 --odometry ../Sandbox/odometry.log --odometryinfo ../Sandbox/odometry.info --loop ../Sandbox/result.txt --loopinfo ../Sandbox/result.info --pose ../Sandbox/pose.log --keep ../Sandbox/keep.log --refine ../Sandbox/pcds/reg_refine_all.log

# BuildCorrespondence.exe --reg_traj ../Sandbox/pcds/reg_refine_all.log --registration --reg_dist 0.05 --reg_ratio 0.25 --reg_num 0 --save_xyzn
# mv reg_output.* ../Sandbox/

# numpcds=$(ls ../Sandbox/pcds/cloud_bin_*.pcd -l | wc -l | tr -d ' ')
# #FragmentOptimizer.exe --rigid --rgbdslam ../Sandbox/init.log --registration ../Sandbox/reg_output.log --dir ../Sandbox/pcds/ --num $numpcds --resolution 12 --iteration 10 --length 4.0 --write_xyzn_sample 10
# FragmentOptimizer.exe --slac --rgbdslam ../Sandbox/init.log --registration ../Sandbox/reg_output.log --dir ../Sandbox/pcds/ --num $numpcds --resolution 12 --iteration 10 --length 4.0 --write_xyzn_sample 10
# #pcl_viewer_release.exe sample.pcd
# mv pose.log ../Sandbox/pose_slac.log
# mv output.ctr ../Sandbox/
# rm sample.pcd

# Integrate.exe --pose_traj ../Sandbox/pose_slac.log --seg_traj ../Sandbox/100-0.log --ctr ../Sandbox/output.ctr --num ${numpcds} --resolution 12 --camera longrange.param -oni ../Sandbox/input.oni --length 4.0 --interval 50

# pcl_kinfu_largeScale_mesh_output_release.exe world.pcd
# mkdir ../Sandbox/ply/
# mv *.ply ../Sandbox/ply/
# rm world.pcd

# # MeshLab -> import all ply files -> merge visible layers -> make sure "remove duplicated vertices/faces" are checked -> export final model
