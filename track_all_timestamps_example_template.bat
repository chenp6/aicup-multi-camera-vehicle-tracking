@echo off
setlocal enabledelayedexpansion

set "SOURCE_DIR_NAMES=<時間區間1> <時間區間2> ..."
set "YOLO_MODEL=trained_model\<追蹤使用的車輛偵測YOLO模型權重檔(.pt)>"
set "REID_WEIGHT_DIR=trained_model\<車輛外觀特徵提取ReID模型權重(.pth)>"

for %%s in (%SOURCE_DIR_NAMES%) do (
    python tools/mc_demo_yolov7.py ^
        --weights %YOLO_MODEL% ^
        --source "<跨鏡頭車輛追蹤dataset_path>/images/%%s" ^
        --device "0" --name "%%s" ^
        --fuse-score --agnostic-nms ^
        --with-reid --fast-reid-config "configs/<ReID模型參數設定yml檔>" ^
        --fast-reid-weights "%REID_WEIGHT_DIR%" ^
        --MMD_max 3000 ^
        --MMD_mask 0.7 ^
        --MMD_thresh 0.1 ^
        --ReID_mask 0.3 ^
        --ReID_thresh 0.25
)
python tools/auto_evalute_results.py
endlocal
