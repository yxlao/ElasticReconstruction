include(ExternalProject)

ExternalProject_Add(
    ext_eigen
    PREFIX eigen
    URL https://gitlab.com/libeigen/eigen/-/archive/3.0.4/eigen-3.0.4.zip
    INSTALL_DIR ${ELASTIC_RECONSTRUCTION_DEPS_INSTALL_PREFIX}
    CMAKE_ARGS
        -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
)
