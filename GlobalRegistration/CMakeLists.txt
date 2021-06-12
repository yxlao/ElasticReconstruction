add_executable(GlobalRegistration)
target_sources(GlobalRegistration PRIVATE
    GlobalRegistration.cpp
    RansacCurvature.cpp
)
elastic_reconstruction_set_global_properties(GlobalRegistration)
