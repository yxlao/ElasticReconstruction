add_executable(Integrate)
target_sources(Integrate PRIVATE
    ControlGrid.cpp
    IntegrateApp.cpp
    Integrate.cpp
    TSDFVolume.cpp
    TSDFVolumeUnit.cpp
)
elastic_reconstruction_set_global_properties(Integrate)
