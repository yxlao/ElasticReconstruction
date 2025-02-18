cmake_minimum_required(VERSION 3.13)

project(ElasticReconstructionDeps LANGUAGES C CXX)

# All external projects shall be installed to here
# Equivalent directories as the one specified in the top-level CMakeLists.txt
set(ELASTIC_RECONSTRUCTION_DEPS_INSTALL_PREFIX ${CMAKE_BINARY_DIR}/install)

# Boost
include(${PROJECT_SOURCE_DIR}/boost/boost.cmake)

# Eigen
include(${PROJECT_SOURCE_DIR}/eigen/eigen.cmake)

# Suitesparse
include(${PROJECT_SOURCE_DIR}/suitesparse/suitesparse.cmake)

# G2O
include(${PROJECT_SOURCE_DIR}/g2o/g2o.cmake)
add_dependencies(ext_g2o ext_eigen)
add_dependencies(ext_g2o ext_suitesparse)

# OpenCV
include(${PROJECT_SOURCE_DIR}/opencv/opencv.cmake)
