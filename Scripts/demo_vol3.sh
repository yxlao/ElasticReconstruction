#!/bin/bash

pcl_kinfu_largeScale_release.exe -r -ic -sd 10 -oni ../sandbox/input.oni -vs 3 --fragment 25 --rgbd_odometry --record_log ../sandbox/100-0.log --camera longrange.param
mkdir ../sandbox/pcds/
mv cloud_bin* ../sandbox/pcds/

GlobalRegistration.exe ../sandbox/pcds/ ../sandbox/100-0.log 50
mv init.log ../sandbox/
mv pose.log ../sandbox/
mv odometry.* ../sandbox/
mv result.* ../sandbox/

GraphOptimizer.exe -w 100 --odometry ../sandbox/odometry.log --odometryinfo ../sandbox/odometry.info --loop ../sandbox/result.txt --loopinfo ../sandbox/result.info --pose ../sandbox/pose.log --keep ../sandbox/keep.log --refine ../sandbox/pcds/reg_refine_all.log

BuildCorrespondence.exe --reg_traj ../sandbox/pcds/reg_refine_all.log --registration --reg_dist 0.05 --reg_ratio 0.25 --reg_num 0 --save_xyzn
mv reg_output.* ../sandbox/

numpcds=$(ls ../sandbox/pcds/cloud_bin_*.pcd -l | wc -l | tr -d ' ')
#FragmentOptimizer.exe --rigid --rgbdslam ../sandbox/init.log --registration ../sandbox/reg_output.log --dir ../sandbox/pcds/ --num $numpcds --resolution 12 --iteration 10 --length 3.0 --write_xyzn_sample 10
FragmentOptimizer.exe --slac --rgbdslam ../sandbox/init.log --registration ../sandbox/reg_output.log --dir ../sandbox/pcds/ --num $numpcds --resolution 12 --iteration 10 --length 3.0 --write_xyzn_sample 10
#pcl_viewer_release.exe sample.pcd
mv pose.log ../sandbox/pose_slac.log
mv output.ctr ../sandbox/
rm sample.pcd

Integrate.exe --pose_traj ../sandbox/pose_slac.log --seg_traj ../sandbox/100-0.log --ctr ../sandbox/output.ctr --num ${numpcds} --resolution 12 --camera longrange.param -oni ../sandbox/input.oni --length 3.0 --interval 50

pcl_kinfu_largeScale_mesh_output_release.exe world.pcd
mkdir ../sandbox/ply/
mv *.ply ../sandbox/ply/
rm world.pcd

# MeshLab -> import all ply files -> merge visible layers -> make sure "remove duplicated vertices/faces" are checked -> export final model