add_executable(OniWriter)
target_sources(OniWriter PRIVATE
    OniWriter.cpp
)
elastic_reconstruction_set_global_properties(OniWriter)
