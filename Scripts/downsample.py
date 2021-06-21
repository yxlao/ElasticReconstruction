import open3d as o3d
from pathlib import Path
import os
import argparse

pwd = Path(os.path.dirname(os.path.realpath(__file__)))
sandbox_dir = pwd.parent / "Sandbox"


def down_sample(pcd, voxel_size=0.05, nb_neighbors=20, std_ratio=2.0):
    # pcd = pcd->VoxelDownSample(params.voxel_size_);
    # pcd->RemoveStatisticalOutliers(20, 2.0);
    # pcd->EstimateNormals();
    pcd_down = pcd.voxel_down_sample(voxel_size)
    pcd_down, _ = pcd_down.remove_statistical_outlier(nb_neighbors, std_ratio)
    pcd_down.estimate_normals()
    return pcd_down


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--voxel_size",
                        dest="voxel_size",
                        required=True,
                        default=0.05,
                        type=float)
    parser.add_argument("--src_dir", dest="src_dir", required=True, type=str)
    parser.add_argument("--dst_dir", dest="dst_dir", required=True, type=str)
    args = parser.parse_args()
    print(f"[downsample.py] voxel_size: {args.voxel_size}")
    print(f"[downsample.py] src_dir   : {args.src_dir}")
    print(f"[downsample.py] dst_dir   : {args.dst_dir}")

    if args.src_dir == args.dst_dir:
        raise ValueError("src_dir cannot be the same as dst_dir")

    src_dir = Path(args.src_dir)
    dst_dir = Path(args.dst_dir)
    dst_dir.mkdir(parents=True, exist_ok=True)  # OK if already exists.

    for src_file in sorted(src_dir.glob('*.pcd')):
        dst_file = dst_dir / src_file.name

        pcd = o3d.io.read_point_cloud(str(src_file))
        pcd_down = down_sample(pcd, voxel_size=args.voxel_size)
        print(f"# points : {len(pcd.points)} -> {len(pcd_down.points)}")
        print(f"# colors : {len(pcd.colors)} -> {len(pcd_down.colors)}")
        print(f"# normals: {len(pcd.normals)} -> {len(pcd_down.normals)}")

        o3d.io.write_point_cloud(str(dst_file), pcd_down)
        print(f"src: {src_file}->\ndst: {dst_file}")

    print(f"[downsample.py] voxel_size: {args.voxel_size}")
    print(f"[downsample.py] src_dir   : {args.src_dir}")
    print(f"[downsample.py] dst_dir   : {args.dst_dir}")
    print(f"[downsample.py] Downsampling done.")
