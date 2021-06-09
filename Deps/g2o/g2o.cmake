include(ExternalProject)

ExternalProject_Add(
    ext_g2o
    PREFIX g2o
    GIT_REPOSITORY https://github.com/RainerKuemmerle/g2o.git
    GIT_TAG 20160424_git
    INSTALL_DIR ${ELASTIC_RECONSTRUCTION_DEPS_INSTALL_PREFIX}
    UPDATE_COMMAND ""
    CMAKE_ARGS
        -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
        -DCMAKE_CXX_FLAGS=-D_GLIBCXX_USE_CXX11_ABI=0
)
