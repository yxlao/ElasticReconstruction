cmake_minimum_required(VERSION 3.16)

project(ElasticReconstruction LANGUAGES C CXX)

# CCache.
find_program(CCACHE "ccache")
if (CCACHE)
    message(STATUS "ccache found at ${CCACHE}")
    set(CMAKE_C_COMPILER_LAUNCHER ${CCACHE})
    set(CMAKE_CXX_COMPILER_LAUNCHER ${CCACHE})
    if(BUILD_CUDA_MODULE)
        set(CMAKE_CUDA_COMPILER_LAUNCHER ${CCACHE})
    endif()
endif()

# Set default build type.
if(NOT CMAKE_CONFIGURATION_TYPES)
    if(NOT CMAKE_BUILD_TYPE)
        message(STATUS "Setting build type to RelWithDebInfo as none was specified.")
        set(CMAKE_BUILD_TYPE RelWithDebInfo CACHE STRING "Choose the type of build." FORCE)
        set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS
                     "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
    endif()
    message(STATUS "CMAKE_BUILD_TYPE is set to ${CMAKE_BUILD_TYPE}.")
endif()

# CMake modules
list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/CMake")

# Dependencies shall be installed here.
set(ELASTIC_RECONSTRUCTION_DEPS_INSTALL_PREFIX ${PROJECT_SOURCE_DIR}/Deps/build/install)

# Depencency: PCL
find_package(PCL 1.7 PATHS /home/yixing/pcl_install NO_DEFAULT_PATH)
if(PCL_FOUND)
    message(STATUS "PCL found")
    message(STATUS "PCL_INCLUDE_DIRS: ${PCL_INCLUDE_DIRS}")
    message(STATUS "PCL_DEFINITIONS: ${PCL_DEFINITIONS}")
    message(STATUS "PCL_LIBRARY_DIRS: ${PCL_LIBRARY_DIRS}")
    message(STATUS "PCL_LIBRARIES: ${PCL_LIBRARIES}")
else()
    message(FATAL_ERROR "PCL_FOUND: ${PCL_FOUND}")
endif()

# Depencency: Boost
set(BOOST_ROOT ${ELASTIC_RECONSTRUCTION_DEPS_INSTALL_PREFIX})
set(BOOSTROOT ${ELASTIC_RECONSTRUCTION_DEPS_INSTALL_PREFIX})
set(Boost_NO_SYSTEM_PATHS ON)
find_package(Boost)
if(BOOST_FOUND)
    message(STATUS "Boost found")
    message(STATUS "Boost_INCLUDE_DIRS: ${Boost_INCLUDE_DIRS}")
    message(STATUS "BOOST_LIBRARIES: ${BOOST_LIBRARIES}") # Upper case
    message(STATUS "Boost_LIBRARY_DIRS: ${Boost_LIBRARY_DIRS}")
else()
    message(FATAL_ERROR "BOOST_FOUND: ${BOOST_FOUND}")
endif()

# Depencency: Eigen
set(EIGEN_ROOT ${ELASTIC_RECONSTRUCTION_DEPS_INSTALL_PREFIX})
find_package(Eigen)
if(EIGEN_FOUND)
    message(STATUS "Eigen found")
    message(STATUS "EIGEN_INCLUDE_DIRS: ${EIGEN_INCLUDE_DIRS}")
else()
    message(FATAL_ERROR "EIGEN_FOUND: ${EIGEN_FOUND}")
endif()

# CMake helper functions.
function(elastic_reconstruction_set_global_properties target)
    # Libraries need to be compiled with position independent code
    get_target_property(target_type ${target} TYPE)
    if (NOT target_type STREQUAL "EXECUTABLE")
        set_target_properties(${target} PROPERTIES POSITION_INDEPENDENT_CODE ON)
    endif()

    # Tell CMake we want a compiler that supports C++14 features
    target_compile_features(${target} PUBLIC cxx_std_14)

    # Colorize GCC/Clang terminal outputs
    if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
        target_compile_options(${target} PRIVATE $<$<COMPILE_LANGUAGE:CXX>:-fdiagnostics-color=always>)
    elseif (CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
        target_compile_options(${target} PRIVATE $<$<COMPILE_LANGUAGE:CXX>:-fcolor-diagnostics>)
    endif()

    target_include_directories(${target} PUBLIC
        $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/cpp>
        $<INSTALL_INTERFACE:${Open3D_INSTALL_INCLUDE_DIR}>
    )

    # Propagate build configuration into source code
    target_compile_definitions(${target} PRIVATE __GLIBC_HAVE_LONG_LONG)
    target_compile_definitions(${target} PRIVATE _GLIBCXX_USE_CXX11_ABI=0)
    target_compile_definitions(${target} PRIVATE BOOST_NO_CXX11_VARIADIC_TEMPLATES)

    # Third-party dependencies
    target_include_directories(${target} PRIVATE
        ${PCL_INCLUDE_DIRS}
        ${Boost_INCLUDE_DIRS}
        ${EIGEN_INCLUDE_DIRS}
    )
    target_link_directories(${target} PRIVATE
        ${PCL_LIBRARY_DIRS}
        ${Boost_LIBRARY_DIRS}
    )
    target_link_libraries(${target} PRIVATE
        ${PCL_LIBRARIES}
        ${BOOST_LIBRARIES}
    )
    target_compile_definitions(${target} PRIVATE
        EIGEN_USE_NEW_STDVECTOR
        EIGEN_YES_I_KNOW_SPARSE_MODULE_IS_NOT_STABLE_YET
    )
endfunction()

# Subdirectories.
add_subdirectory(BuildCorrespondence)
add_subdirectory(FragmentOptimizer)
add_subdirectory(GlobalRegistration)
add_subdirectory(GraphOptimizer)
add_subdirectory(Integrate)
