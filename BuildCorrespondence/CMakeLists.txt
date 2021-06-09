add_executable(BuildCorrespondence)
target_sources(BuildCorrespondence PRIVATE
    BuildCorrespondence.cpp
    CorresApp.cpp
)
elastic_reconstruction_set_global_properties(BuildCorrespondence)
