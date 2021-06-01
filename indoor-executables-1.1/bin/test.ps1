Write-Host "Running .\pcl_kinfu_largeScale_release.exe"
.\pcl_kinfu_largeScale_release.exe

Write-Host "Running .\GlobalRegistration.exe"
.\GlobalRegistration.exe

Write-Host "Running .\GraphOptimizer.exe"
.\GraphOptimizer.exe

Write-Host "Running .\BuildCorrespondence.exe"
.\BuildCorrespondence.exe

Write-Host "Running .\FragmentOptimizer.exe"
.\FragmentOptimizer.exe

Write-Host "Running .\Integrate.exe"
.\Integrate.exe

Write-Host "Running .\pcl_kinfu_largeScale_mesh_output_release.exe"
.\pcl_kinfu_largeScale_mesh_output_release.exe

Write-Host "Running .\pcl_viewer_release.exe"
.\pcl_viewer_release.exe
