# Multi-Camera Vehicle Tracking Based on ReID and Mapped Mahalanobis Distance

## Introduction

此專題提出一個結合車輛外觀辨識與行車路徑的跨相機多目標車輛追蹤方法。方法引用 BoT-SORT baseline 框架，過程同樣使用兩階段的追蹤匹配。於第一階段中，會同時考慮兩幀畫面中車輛的外觀與行車路徑的異同以進行匹配。不同於 BoT-SORT 以路徑為主，外觀為輔，僅設置外觀遮罩。本框架於兩者間皆設置遮罩以供開發者及使用者可以根據其資料特性，調整適當的遮罩參數與條件，以取得較為準確的追蹤效果。另外，為能更靈活的運用特徵，即考慮到資料取樣條件的不同，針對行車路徑距離的計算方式，此框架參考 UCMCTrack 使用投影至地面的Mahalanobis Distance作為依據的作法，而非原先容易受相機狀態與取樣頻率影響而失去追蹤的 IoU (Intersection over Union)，如此一來，便能避免逐幀進行相機補償所需的大量計算資源和時間，提升推理和追蹤的效率。

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Installation](#installation)


## Features

- 結合車輛外觀辨識與行車路徑的跨相機追蹤
- 自定義外觀和行車路徑遮罩
- 使用投影至地面的 Mahalanobis Distance 進行行車路徑計算
- 減少相機補償所需的計算資源

## Installation
The code was tested on Windows10
To install the project, follow these steps:

1. Clone the repository:
   ```bash
   git clone https://github.com/chenp6/aicup-multi-camera-vehicle-tracking.git  
2. Train 基於ReID的車輛外觀提取模型  
(1) 準備ReID訓練資料集
   ```bash
   cd <BoT-SORT_dir 剛剛clone的資料夾path>  
   rem For AICUP  
   python fast_reid/datasets/generate_AICUP_patches.py --data_path datasets/AI_CUP_MCMOT_dataset/train  

(2) 設置訓練參數與資料擴增方法   
   a. 使用此project提供之配置 : `fast_reid\configs\AICUP\VehicleID_with_data_augmentation.yml`  
   b. 可直接變更配置檔以自行重新設置參數 : 
   配置檔位於 `fast_reid\configs\AICUP\VehicleID_with_data_augmentation_custom.yml`  
      (`fast_reid/fast_reid/config/defaults.py`內有提供各參數與其調整方法)  
(3) 訓練ReID模型
   ```bash
   cd <BoT-SORT_dir 剛剛clone的資料夾path>   
   python fast_reid/tools/train_net.py --config-file fast_reid/configs/AICUP/<參數配置檔名稱> MODEL.DEVICE "cuda:0" 
(4) 取得訓練完成之模型  
   模型輸出路徑由配置檔中的`OUTPUT_DIR: <模型欲輸出路徑>`設定


3. 訓練YOLO模型  


4. 調整追蹤模型  
[備註] 提供Colab執行範例於
(1) 將訓練完成的ReID模型與YOLO模型放入`\trained_model`資料夾中  
(2) 將ground truth bbox文字檔案放入`\tracked_result_evaluation\gt_dir`資料夾中  
(3) 利用UCMCTrack提供的Estimation tool 建立各鏡頭的相機參數檔案並放入`camera_para_files`中  
    檔案命名方式須符合‵cam_para_<CamID>.txt`  
    [註] 預設檔案為AICUP資料集之八鏡頭的相機參數，若使用其他資料集則根據鏡頭數覆蓋與新增txt
   ```bash
   ├── cam_para_files
   │   ├── cam_para_0.txt
   │   ├── cam_para_1.txt
   │   ├── cam_para_2.txt
   │   ├── cam_para_3.txt
   │   ├── cam_para_4.txt
   │   ├── cam_para_5.txt
   │   ├── cam_para_6.txt
   │   ├── cam_para_7.txt   
   │   │   ...   

(3) 參考`track_all_timestamps_example_template.bat`建立追蹤模型執行之bash檔案     
   [註] 提供‵track_all_timestamps_example_train.bat` 與 ‵track_all_timestamps_example_test.bat` 分別為追蹤AICUP賽事資料集訓練與測試dataset的模型執行bash檔案  
(4) 根據資料集特性調整MMD與ReID的遮罩與閾值參數  
(5) 執行追蹤模型程式  
   ```bash
   cd <BoT-SORT_dir 剛剛clone的資料夾path>   
   <追蹤模型執行之bash檔案路徑>
   
(6) 取得結果  
a. 追蹤結果之畫面儲存於‵\tracked_result`
b. 追蹤結果之bbox文字檔儲存於‵\tracked_result_evaluation\ts_dir`
c. 評估結果呈現於終端機畫面中  


## Acknowledgement

A large part of the codes, ideas and results are borrowed from
- [BoT-SORT](https://github.com/NirAharon/BoT-SORT)
- [ByteTrack](https://github.com/ifzhang/ByteTrack)
- [StrongSORT](https://github.com/dyhBUPT/StrongSORT)
- [FastReID](https://github.com/JDAI-CV/fast-reid)
- [YOLOX](https://github.com/Megvii-BaseDetection/YOLOX)
- [YOLOv7](https://github.com/wongkinyiu/yolov7)
- [UCMCTrack](https://github.com/corfyi/UCMCTrack)
Thanks for their excellent work!
