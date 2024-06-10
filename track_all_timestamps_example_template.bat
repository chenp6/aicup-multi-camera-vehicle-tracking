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
        --with-reid --fast-reid-config "fast_reid/configs/AICUP/<ReID模型參數設定yml檔>" ^
        --fast-reid-weights "%REID_WEIGHT_DIR%" ^
        --MMD_max <MMD正規化最大值之原始數值> ^
        --MMD_mask  <MMD遮罩(用來遮ReID，較為寬鬆)> ^
        --MMD_thresh <MMD閾值(較為嚴格)> ^
        --ReID_mask <ReID遮罩(用來遮MMD，較為寬鬆)> ^
        --ReID_thresh <ReID閾值(較為嚴格)>
)
python tools/auto_evalute_results.py
endlocal
