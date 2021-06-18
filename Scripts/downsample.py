import open3d as o3d
from pathlib import Path
import os

pwd = Path(os.path.dirname(os.path.realpath(__file__)))
sandbox_dir = pwd.parent / "Sandbox"


def down_sample(pcd, voxel_size=0.05, nb_neighbors=20, std_ratio=2.0):
    pcd_down = pcd.voxel_down_sample(voxel_size)
    pcd_down, _ = pcd_down.remove_statistical_outlier(nb_neighbors, std_ratio)
    pcd_down.estimate_normals()
    return pcd_down


if __name__ == "__main__":
    # pcd = pcd->VoxelDownSample(params.voxel_size_);
    # pcd->RemoveStatisticalOutliers(20, 2.0);
    # pcd->EstimateNormals();

    src_dir = sandbox_dir / "pcds"
    dst_dir = sandbox_dir / "pcds_down"
    dst_dir.mkdir(parents=True, exist_ok=True)  # OK if already exists.

    for src_file in sorted(src_dir.glob('*.pcd')):
        dst_file = dst_dir / src_file.name

        pcd = o3d.io.read_point_cloud(str(src_file))
        pcd_down = down_sample(pcd)
        print(f"# points : {len(pcd.points)} -> {len(pcd_down.points)}")
        print(f"# colors : {len(pcd.colors)} -> {len(pcd_down.colors)}")
        print(f"# normals: {len(pcd.normals)} -> {len(pcd_down.normals)}")

        o3d.io.write_point_cloud(str(dst_file), pcd_down)
        print(f"src: {src_file}->\ndst: {dst_file}")
