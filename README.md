# Multi-Camera Vehicle Tracking Based on ReID and Mapped Mahalanobis Distance

## Introduction

此專題提出一個結合車輛外觀辨識與行車路徑的跨相機多目標車輛追蹤方法。方法引用 BoT-SORT baseline 框架，過程同樣使用兩階段的追蹤匹配。於第一階段中，會同時考慮兩幀畫面中車輛的外觀與行車路徑的異同以進行匹配。不同於 BoT-SORT 以路徑為主，外觀為輔，僅設置外觀遮罩。本框架於兩者間皆設置遮罩以供開發者及使用者可以根據其資料特性，調整適當的遮罩參數與條件，以取得較為準確的追蹤效果。另外，為能更靈活的運用特徵，即考慮到資料取樣條件的不同，針對行車路徑距離的計算方式，此框架參考 UCMCTrack 使用投影至地面的Mahalanobis Distance作為依據的作法，而非原先容易受相機狀態與取樣頻率影響而失去追蹤的 IoU (Intersection over Union)，如此一來，便能避免逐幀進行相機補償所需的大量計算資源和時間，提升推理和追蹤的效率。

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [File Structure](#file-structure)
- [Contributing](#contributing)
- [License](#license)

## Features


- 結合車輛外觀辨識與行車路徑的跨相機追蹤
- 自定義外觀和行車路徑遮罩
- 使用投影至地面的 Mahalanobis Distance 進行行車路徑計算
- 減少相機補償所需的計算資源

## Installation

To install the project, follow these steps:

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/project-name.git
2. Train 基於ReID的車輛外觀提取模型  
(1) 設置訓練參數與資料擴增方法 
   a.使用此project提供之配置 : `fast_reid\configs\AICUP\VehicleID_with_data_augmentation.yml`  
   b.可直接變更配置檔以自行重新設置參數 : `fast_reid\configs\AICUP\VehicleID_with_data_augmentation_custom.yml`  
      (`fast_reid/fast_reid/config/defaults.py`內有提供各參數與其調整方法)  
(2) 訓練ReID模型
   ```bash
   python fast_reid/tools/train_net.py --config-file fast_reid/configs/AICUP/VehicleID_with_data_augmentation_custom.yml MODEL.DEVICE "cuda:0"  

3. 訓練YOLO模型


4. 調整追蹤模型
