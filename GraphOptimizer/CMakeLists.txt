add_executable(GraphOptimizer)
target_sources(GraphOptimizer PRIVATE
    GraphOptimizer.cpp
    OptApp.cpp
    vertigo/edge_se3Switchable.cpp
    vertigo/edge_switchPrior.cpp
    vertigo/types_g2o_robust.cpp
    vertigo/vertex_switchLinear.cpp
)
elastic_reconstruction_set_global_properties(GraphOptimizer)
