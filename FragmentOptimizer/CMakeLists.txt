add_executable(FragmentOptimizer)
target_sources(FragmentOptimizer PRIVATE
    FragmentOptimizer.cpp
    HashSparseMatrix.cpp
    OptApp.cpp
    PointCloud.cpp
)
elastic_reconstruction_set_global_properties(FragmentOptimizer)
