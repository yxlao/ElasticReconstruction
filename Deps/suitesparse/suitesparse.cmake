include(ExternalProject)

ExternalProject_Add(
    ext_suitesparse
    PREFIX suitesparse
    URL https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v5.10.1.tar.gz
    INSTALL_DIR ${ELASTIC_RECONSTRUCTION_DEPS_INSTALL_PREFIX}
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND make  # make -j is not helpful here
    INSTALL_COMMAND make install INSTALL=<INSTALL_DIR>
    BUILD_IN_SOURCE ON
)
