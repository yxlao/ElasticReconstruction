include(ExternalProject)
include(ProcessorCount)
ProcessorCount(NPROC)

ExternalProject_Add(
    ext_boost
    PREFIX boost
    URL ${PROJECT_SOURCE_DIR}/boost/boost_1_50_0.tar.bz2
    INSTALL_DIR ${ELASTIC_RECONSTRUCTION_DEPS_INSTALL_PREFIX}
    BUILD_IN_SOURCE ON
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ./bootstrap.sh -prefix=<INSTALL_DIR>
    BUILD_COMMAND ""
    INSTALL_COMMAND ./b2 toolset=gcc-4.8 cxxflags=-fPIC link=static install -j ${NPROC}
)
