import os
import cv2
import glob
import argparse

from tqdm import tqdm


def convert_bbox(args, data):
    img_height, img_width = args.imgsz
    
    # Normalized bbox to Absoulate
    bb_width = float(data[3]) * img_width
    bb_height = float(data[4]) * img_height
    bb_left = float(data[1]) * img_width - bb_width / 2
    bb_top = float(data[2]) * img_height - bb_height / 2
    track_id = data[5].split('\n')[0]
    
    x1, y1, x2, y2 = bb_left, bb_top, bb_left + bb_width, bb_top + bb_height

    return int(x1), int(y1), int(x2), int(y2), int(track_id)


def make_parser():
    parser = argparse.ArgumentParser("AICUP ReID dataset")

    parser.add_argument("--data_path", default="", help="path to AICUP train data")
    parser.add_argument("--save_path", default="fast_reid/datasets", help="Path to save the MOT-ReID dataset")
    parser.add_argument('--imgsz', type=tuple, default=(720, 1280), help='img size, (height, width)')
    parser.add_argument('--train_ratio', type=float, default=0.8, help='The ratio of the train set when splitting the train set and the test set')

    return parser


def main(args):

    # Create folder for outputs
    save_path = os.path.join(args.save_path, 'AICUP-ReID')
    os.makedirs(save_path, exist_ok=True)

    train_save_path = os.path.join(save_path, 'bounding_box_train')
    os.makedirs(train_save_path, exist_ok=True)
    test_save_path = os.path.join(save_path, 'bounding_box_test')
    os.makedirs(test_save_path, exist_ok=True)
    
    # Split train/test set
    total_files = sorted(glob.glob(os.path.join(args.data_path, 'images', '*')))
    total_count = len(total_files)
    train_count = int(total_count * args.train_ratio)
    train_files = total_files[:train_count]
    
    for time_path in total_files:
        for img_path in tqdm(glob.glob(os.path.join(time_path, '*')), desc=f'convert {time_path}'):
            path_txt = img_path.split(os.sep)
            timestemp, img_name = path_txt[-2], path_txt[-1].split('.')[0]
            frame_id = img_name.split('_')[-1]
            img = cv2.imread(img_path)
            
            with open(os.path.join(args.data_path, 'labels', timestemp, f'{img_name}.txt'), 'r') as gt_file:
                for line in gt_file.readlines():
                    data = line.split(' ')
                    x1, y1, x2, y2, track_id = convert_bbox(args, data)
                    patch = img[y1:y2, x1:x2, :]
                    
                    # TrackID_TimeStemp_FrameID_acc_data.bmp
                    file_name = f'{str(track_id).zfill(7)}_{timestemp.replace("_", "-")}_{str(frame_id).zfill(7)}_acc_data.bmp'

                    if time_path in train_files:
                        cv2.imwrite(os.path.join(train_save_path, file_name), patch)
                    else:
                        cv2.imwrite(os.path.join(test_save_path, file_name), patch)


if __name__ == "__main__":
    args = make_parser().parse_args()
    main(args)
