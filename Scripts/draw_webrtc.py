#!/usr/bin/env python
import open3d as o3d
import os
import socket
import argparse

def detect_and_set_webrtc_ip():
    # Attempt to detect local IP address, may not be accurate.
    # https://stackoverflow.com/a/166589/1255535
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.connect(("8.8.8.8", 80))
    webrtc_ip = s.getsockname()[0]
    s.close()
    os.environ["WEBRTC_IP"] = webrtc_ip


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--mesh", dest="mesh", required=False, type=str)
    parser.add_argument("--pointcloud", dest="pointcloud", required=False, type=str)
    args = parser.parse_args()

    detect_and_set_webrtc_ip()
    o3d.visualization.webrtc_server.enable_webrtc()

    if args.mesh:
        print(f"Loading mesh from: {args.mesh}")
        mesh = o3d.io.read_triangle_mesh(args.mesh)
        mesh.compute_vertex_normals()
        o3d.visualization.draw(mesh)
    elif args.pointcloud:
        print(f"Loading pointcloud from: {args.pointcloud}")
        pcd = o3d.io.read_point_cloud(args.pointcloud)
        pcd.estimate_normals()
        o3d.visualization.draw(pcd)
    else:
        raise ValueError("Must specify --mesh or --pointcloud")
