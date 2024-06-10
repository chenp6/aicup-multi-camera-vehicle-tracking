@echo off
setlocal enabledelayedexpansion

set "SOURCE_DIR_NAMES=<時間區間1> <時間區間2> ..."
set "YOLO_MODEL=trained_model\<追蹤使用的車輛偵測YOLO模型權重檔名>"
set "REID_WEIGHT_DIR=trained_model\<車輛外觀特徵提取ReID模型權重檔名>"

for %%s in (%SOURCE_DIR_NAMES%) do (
    python tools/mc_demo_yolov7.py ^
        --weights %YOLO_MODEL% ^
        --source "datasets/AI_CUP_MCMOT_dataset/train/images/%%s" ^
        --device "0" --name "%%s" ^
        --fuse-score --agnostic-nms ^
        --with-reid --fast-reid-config "fast_reid/configs/AICUP/VehicleID_with_data_augmentation.yml" ^
        --fast-reid-weights "%REID_WEIGHT_DIR%" ^
        --MMD_max 3000 ^
        --MMD_mask 0.7 ^
        --MMD_thresh 0.1 ^
        --ReID_mask 0.3 ^
        --ReID_thresh 0.25
)
python tools/auto_evalute_results.py
endlocal
