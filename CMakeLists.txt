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

# Put build results in some predictable places
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/bin)

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
    message(STATUS "Boost_LIBRARIES: ${Boost_LIBRARIES}") # Upper case
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

# Depencency: SuiteSparse
set(CSPARSE_ROOT ${ELASTIC_RECONSTRUCTION_DEPS_INSTALL_PREFIX})
find_package(SuiteSparse)
if(CSPARSE_FOUND)
    message(STATUS "SuiteSparse found")
    message(STATUS "CHOLMOD_LIBRARIES: ${CHOLMOD_LIBRARIES}")
    message(STATUS "CSPARSE_LIBRARY: ${CSPARSE_LIBRARY}")
else()
    message(FATAL_ERROR "CSPARSE_FOUND: ${CSPARSE_FOUND}")
endif()

# Depencency: G2O
set(G2O_ROOT ${ELASTIC_RECONSTRUCTION_DEPS_INSTALL_PREFIX})
find_package(G2O)
if(G2O_FOUND)
    message(STATUS "G2O_INCLUDE_DIR              : ${G2O_INCLUDE_DIR}")
    message(STATUS "G2O_CORE_LIBRARY             : ${G2O_CORE_LIBRARY}")
    message(STATUS "G2O_STUFF_LIBRARY            : ${G2O_STUFF_LIBRARY}")
    message(STATUS "G2O_CLI_LIBRARY              : ${G2O_CLI_LIBRARY}")
    message(STATUS "G2O_SOLVER_CHOLMOD           : ${G2O_SOLVER_CHOLMOD}")
    message(STATUS "G2O_SOLVER_CSPARSE           : ${G2O_SOLVER_CSPARSE}")
    message(STATUS "G2O_SOLVER_CSPARSE_EXTENSION : ${G2O_SOLVER_CSPARSE_EXTENSION}")
    message(STATUS "G2O_SOLVER_DENSE             : ${G2O_SOLVER_DENSE}")
    message(STATUS "G2O_SOLVER_PCG               : ${G2O_SOLVER_PCG}")
    message(STATUS "G2O_SOLVER_SLAM2D_LINEAR     : ${G2O_SOLVER_SLAM2D_LINEAR}")
    message(STATUS "G2O_SOLVER_STRUCTURE_ONLY    : ${G2O_SOLVER_STRUCTURE_ONLY}")
    message(STATUS "G2O_SOLVER_EIGEN             : ${G2O_SOLVER_EIGEN}")
    message(STATUS "G2O_TYPES_DATA               : ${G2O_TYPES_DATA}")
    message(STATUS "G2O_TYPES_ICP                : ${G2O_TYPES_ICP}")
    message(STATUS "G2O_TYPES_SBA                : ${G2O_TYPES_SBA}")
    message(STATUS "G2O_TYPES_SCLAM2D            : ${G2O_TYPES_SCLAM2D}")
    message(STATUS "G2O_TYPES_SIM3               : ${G2O_TYPES_SIM3}")
    message(STATUS "G2O_TYPES_SLAM2D             : ${G2O_TYPES_SLAM2D}")
    message(STATUS "G2O_TYPES_SLAM3D             : ${G2O_TYPES_SLAM3D}")

    set(G2O_LIBRARIES
        ${G2O_CORE_LIBRARY}
        ${G2O_STUFF_LIBRARY}
        ${G2O_CLI_LIBRARY}
        ${G2O_SOLVER_CHOLMOD}
        ${G2O_SOLVER_CSPARSE}
        ${G2O_SOLVER_CSPARSE_EXTENSION}
        ${G2O_SOLVER_DENSE}
        ${G2O_SOLVER_PCG}
        ${G2O_SOLVER_SLAM2D_LINEAR}
        ${G2O_SOLVER_STRUCTURE_ONLY}
        # ${G2O_SOLVER_EIGEN}
        ${G2O_TYPES_DATA}
        ${G2O_TYPES_ICP}
        ${G2O_TYPES_SBA}
        ${G2O_TYPES_SCLAM2D}
        ${G2O_TYPES_SIM3}
        ${G2O_TYPES_SLAM2D}
        ${G2O_TYPES_SLAM3D}
    )
else()
    message(FATAL_ERROR "G2O_FOUND: ${G2O_FOUND}")
endif()

# CMake helper functions.
function(elastic_reconstruction_set_global_properties target)
    # Libraries need to be compiled with position independent code
    get_target_property(target_type ${target} TYPE)
    if (NOT target_type STREQUAL "EXECUTABLE")
        set_target_properties(${target} PROPERTIES POSITION_INDEPENDENT_CODE ON)
    endif()

    target_include_directories(${target} PRIVATE
        $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}>
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
        ${G2O_INCLUDE_DIR}
    )
    target_link_directories(${target} PRIVATE
        ${PCL_LIBRARY_DIRS}
        ${Boost_LIBRARY_DIRS}
    )
    target_link_libraries(${target} PRIVATE
        ${CSPARSE_LIBRARY}
        ${PCL_LIBRARIES}
        ${BOOST_LIBRARIES}
        boost_program_options # TODO: update me
        /home/yixing/repo/ElasticReconstruction/Deps/build/install/lib/libg2o_opengl_helper.so
        ${CHOLMOD_LIBRARIES}
        ${G2O_LIBRARIES}
    )
    target_compile_definitions(${target} PRIVATE
        EIGEN_USE_NEW_STDVECTOR
        EIGEN_YES_I_KNOW_SPARSE_MODULE_IS_NOT_STABLE_YET
    )

    # Ignores some PCL warnings
    target_compile_options(${target} PRIVATE
        -Wno-attributes
        -Wno-unused-result

        -Wno-conversion
        -Wno-dangling-else
        -Wno-deprecated-declarations
        -Wno-expansion-to-defined
        -Wno-enum-compare
        -Wno-float-conversion
        -Wno-format-extra-args
        -Wno-format
        -Wno-ignored-attributes
        -Wno-implicit-fallthrough
        -Wno-int-in-bool-context
        -Wno-invalid-offsetof
        -Wno-logical-not-parentheses
        -Wno-misleading-indentation
        -Wno-narrowing
        -Wno-old-style-cast
        -Wno-reorder
        -Wno-sign-compare
        -Wno-strict-aliasing
        -Wno-unknown-pragmas
        -Wno-unused-function
        -Wno-unused-local-typedefs
        -Wno-unused-parameter
        -Wno-unused-variable

        -fpermissive # Could be dangerous
    )

endfunction()

# Subdirectories.
add_subdirectory(BuildCorrespondence)
add_subdirectory(FragmentOptimizer)
add_subdirectory(GlobalRegistration)
add_subdirectory(GraphOptimizer)
add_subdirectory(Integrate)
