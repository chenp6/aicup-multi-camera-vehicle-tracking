@echo off
setlocal enabledelayedexpansion

set "SOURCE_DIR_NAMES=0902_150000_151900 0902_190000_191900 0903_150000_151900 0903_190000_191900 0924_150000_151900 0924_190000_191900 0925_150000_151900 0925_190000_191900 1015_150000_151900 1015_190000_191900 1016_150000_151900 1016_190000_191900"
set "YOLO_MODEL=trained_model\yolo_car_detection_model.pt"
set "REID_WEIGHT_DIR=trained_model\reid_extractor_model.pth"

for %%s in (%SOURCE_DIR_NAMES%) do (
    python tools/mc_demo_yolov7.py ^
        --weights %YOLO_MODEL% ^
        --source "datasets/AI_CUP_MCMOT_dataset/train/images/%%s" ^
        --device "0" --name "%%s" ^
        --fuse-score --agnostic-nms ^
        --with-reid --fast-reid-config "configs/VehicleID_with_data_augmentation.yml" ^
        --fast-reid-weights "%REID_WEIGHT_DIR%" ^
        --MMD_max 3000 ^
        --MMD_mask 0.7 ^
        --MMD_thresh 0.1 ^
        --ReID_mask 0.3 ^
        --ReID_thresh 0.25
)
python tools/auto_evalute_results.py
endlocal
