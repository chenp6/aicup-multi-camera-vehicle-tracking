import os
import shutil
from pathlib import Path

source_dir = Path("tracked_result")
eval_dir = Path("tracked_result_evaluation/ts_dir")


eval_dir.mkdir(parents=True, exist_ok=True)

for subdir, dirs, files in os.walk(source_dir):
    for file in files:
        if file.endswith(".txt"):
            src_file = Path(subdir) / file
            dest_file = eval_dir / file
            shutil.copy(src_file, dest_file)

gt_dir = "tracked_result_evaluation/gt_dir"
ts_dir = str(eval_dir)

gt_files = list(Path(gt_dir).glob("*.txt"))

if gt_files:
    os.system(f"python tools/evaluate.py --gt_dir {gt_dir} --ts_dir {ts_dir}")
    print(f"Evaluation dataset is in {ts_dir}")
else:
    print(f"No ground truth files, skipping evaluation.")