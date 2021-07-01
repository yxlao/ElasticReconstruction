from pathlib import Path
import os
import argparse

pwd = Path(os.path.dirname(os.path.realpath(__file__)))

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("reg_log", type=str)
    args = parser.parse_args()
    print(f"[report_correspondence_stats.py] reg_log: {args.reg_log}")

    with open(args.reg_log) as f:
        lines = f.readlines()
        lines = [line.strip() for line in lines]
        if len(lines) % 5 != 0:
            raise ValueError(f"num_lines {len(lines)} % 5 != 0")
        print(f"num_lines: {len(lines)}")

        lines = lines[::5]
        num_edges = len(lines)

        num_correspondences = [int(line.split()[2]) for line in lines]
        total_num_correspondences = sum(num_correspondences)
        print(
            f"{num_edges} valid edges, total {total_num_correspondences} correspondences"
        )
