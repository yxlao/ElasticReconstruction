import open3d as o3d
from pathlib import Path
import os

pwd = Path(os.path.dirname(os.path.realpath(__file__)))
sandbox_dir = pwd.parent / "Sandbox"

if __name__ == "__main__":
    # pcd = pcd->VoxelDownSample(params.voxel_size_);
    # pcd->RemoveStatisticalOutliers(20, 2.0);
    # pcd->EstimateNormals();

    src_dir = sandbox_dir / "pcds"
    dst_dir = sandbox_dir / "pcds_down"

    src_files = sorted(src_dir.glob('*.pcd'))
    src_file = src_files[0]
    pcd = o3d.io.read_point_cloud(str(src_file))
    print("Input pcd")
    print("# points:", len(pcd.points))
    print("# colors:", len(pcd.colors))
    print("# normals:", len(pcd.normals))

    pcd_down = pcd.voxel_down_sample(0.05)
    pcd_down, _ = pcd_down.remove_statistical_outlier(20, 2.0)
    pcd_down.estimate_normals()

    print("Output pcd_down")
    print("# points:", len(pcd_down.points))
    print("# colors:", len(pcd_down.colors))
    print("# normals:", len(pcd_down.normals))

    o3d.visualization.draw_geometries([pcd_down])
