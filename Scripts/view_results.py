import open3d as o3d
import os
from pathlib import Path

pwd = Path(os.path.dirname(os.path.realpath(__file__)))
sandbox_dir = pwd.parent / "Sandbox"
ply_dir = sandbox_dir / "ply"

if __name__ == "__main__":
    ply_files = sorted(ply_dir.glob('*.ply'))

    meshes = []
    for ply_file in ply_files:
        meshes.append(o3d.io.read_triangle_mesh(str(ply_file)))

    o3d.visualization.draw_geometries(meshes)
