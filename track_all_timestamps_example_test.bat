@echo off
setlocal enabledelayedexpansion

set "SOURCE_DIR_NAMES=0902_130006_131041 0902_180000_181551 0903_125957_131610 0903_175958_181607 0924_125953_132551 0924_175955_181603 0925_130000_131605 0925_175958_181604 1001_130000_131559 1001_180000_181558 1002_130000_131600 1002_180000_181600 1015_130000_131600 1015_180001_183846 1016_130000_131600 1016_180000_181600"
set "YOLO_MODEL=trained_model\yolo_car_detection_model.pt"
set "REID_WEIGHT_DIR=trained_model\reid_extractor_model.pth"

for %%s in (%SOURCE_DIR_NAMES%) do (
    python tools/mc_demo_yolov7.py ^
        --weights pretrained/%YOLO_MODEL% ^
        --source "datasets/AI_CUP_MCMOT_dataset/test/images/%%s" ^
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
python auto_evalute_results.py
endlocal
