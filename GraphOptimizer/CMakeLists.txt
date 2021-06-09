add_executable(GraphOptimizer)
target_sources(GraphOptimizer PRIVATE
    GraphOptimizer.cpp
    OptApp.cpp
)
elastic_reconstruction_set_global_properties(GraphOptimizer)
