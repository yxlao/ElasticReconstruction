# Robust Scene Reconstruction

Fork of Qiayi's `ElasticReconstruction` repo to support building with
CMake + Ubuntu + CUDA.

## Additional notes: formatting

This repo has been formatted with the following commands prior to other changes.
This is done to show the modifications.

```bash
# CRLF to LF
find . -not \( -name .git -prune \) -type f -exec dos2unix {} \;

# Remove trailing space
find . -not \( -name .git -prune \) -type f -print0 | xargs -0 perl -pi -e 's/ +$//'

# clang-format
echo "BasedOnStyle: LLVM\nIndentWidth: 4\nSortIncludes: false" > .clang-format
find BuildCorrespondence FragmentOptimizer GlobalRegistration GraphOptimizer Integrate \
    -iname *.h -o -iname *.cpp -o -iname *.cc -o -iname *.cu -o -iname *.hpp -o -iname *.cuh | xargs clang-format-10 -i
```

## Original notes

```txt
===============================================================================
=                       Robust Scene Reconstruction                           =
===============================================================================

LATEST NEWS (7/22/2015):

1. We have published my fork of PCL. It is a development version, for reference
only. We don't provide any support. https://github.com/qianyizh/StanfordPCL

2. Executable system available at http://redwood-data.org/indoor/tutorial.html

3. Lots of useful things - software, data, evaluation tools, beautiful videos
and pictures - are on:
Project page: http://qianyi.info/scene.html
New project page: http://redwood-data.org/indoor/

===============================================================================

Introduction

This is an open source C++ implementation based on the technique presented in
the following papers:

Robust Reconstruction of Indoor Scenes, CVPR 2015
Sungjoon Choi, Qian-Yi Zhou, and Vladlen Koltun

Simultaneous Localization and Calibration: Self-Calibration of Consumer Depth
Cameras, CVPR 2014
Qian-Yi Zhou and Vladlen Koltun

Elastic Fragments for Dense Scene Reconstruction, ICCV 2013
Qian-Yi Zhou, Stephen Miller and Vladlen Koltun

Dense Scene Reconstruction with Points of Interest, SIGGRAPH 2013
Qian-Yi Zhou and Vladlen Koltun

Project pages:
http://qianyi.info/scene.html
http://redwood-data.org/indoor/

Executable system:
http://redwood-data.org/indoor/tutorial.html

Data:
http://qianyi.info/scenedata.html
http://redwood-data.org/indoor/dataset.html

Citation instructions:
http://redwood-data.org/indoor/pipeline.html

This github repository is maintained by Qian-Yi Zhou (Qianyi.Zhou@gmail.com)
Contact me or Vladlen Koltun (vkoltun@gmail.com) if you have any questions.

===============================================================================

License

The source code is released under MIT license.

In general, you can do anything with the code for any purposes, with proper
attribution. If you do something interesting with the code, we'll be happy to
know about it. Feel free to contact us.

We include code and libraries for some software not written by us, to ensure
easy compilation of the system. You should be aware that they can be released
under different licenses:

g2o <GraphOptimizer/external/g2o> - BSD license
vertigo <GraphOptimizer/vertigo> - GPLv3 license
SuiteSparse <FragmentOptimizer/external/SuiteSparse> - LGPL3+ license
Eigen <FragmentOptimizer/external/Eigen> - MPL2 license

===============================================================================

Modules

+ GlobalRegistration
A state-of-the-art global registration algorithm that aligns point clouds
together.

+ GraphOptimizer
Pose graph optimization that prunes false global registration results. See CVPR
2015 paper for details.

+ FragmentOptimizer
The core function that simultaneously optimizes point cloud poses and a
nonrigid correction pattern. See CVPR 2014 and ICCV 2013 papers for details.

+ BuildCorrespondence
ICP refinement for point cloud pairs registered by GlobalRegistration module.

+ Integrate
A CPU-based algorithm that integrates depth images into a voxel, based on
camera pose trajectory and nonrigid correction produced by previous steps.

+ MatlabToolbox
A Matlab toobox for evaluation of camera pose trajectory and global
registration.

+ In the executable package
    * pcl_kinfu_largeScale_release.exe
    * pcl_kinfu_largeScale_mesh_output_release
Executable files for creating intermediate point clouds and final mesh.

===============================================================================

Quick Start

See tutorial on this page:
http://redwood-data.org/indoor/tutorial.html

===============================================================================

Build Dependencies

We strongly recommend you *compile* Point Cloud Library (PCL) x64 with
Visual Studio. http://pointclouds.org/

SuiteSparse is required for solving large sparse matrices.
https://github.com/PetterS/CXSparse

ACML is required for SuiteSparse.
http://developer.amd.com/tools-and-sdks/cpu-development/amd-core-math-library-acml/

The compilation requires Visual Studio 2010 on a Windows 7/8.1 64bit system.

We are not happy with the current compatibility issues. We are working on a new
code release that will not depend on external libraries as much and will be
much easier to compile. Stay tuned.
```
