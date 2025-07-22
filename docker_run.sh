#!/bin/bash

HERE=$(pwd)
DOCKER_USER="${USER}"
# DEV_CONTAINER="nvcr.io/nvidia/tensorrt:21.05-py3"
DEV_CONTAINER="uniad:latest"
#DEV_CONTAINER="pytorch/pytorch:1.2-cuda10.0-cudnn7-runtime"
# DATA_DIR="pingshan_data"
# echo "data dir is $DATA_DIR"
xhost +

docker run \
    --shm-size=20g \
    -v $HERE:/workspace:rw \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /etc/timezone:/etc/timezone:ro \
    -v /etc/localtime:/etc/localtime:ro \
    -w /workspace \
    -u root \
    --gpus all \
    -it --privileged=true --rm \
    --name=uniad_1_0 \
    -e DISPLAY=unix$DISPLAY \
    $DEV_CONTAINER\
    /bin/bash


# docker run \
#     --shm-size=20g \
#     -v /tmp/.X11-unix:/tmp/.X11-unix \
#     -v /etc/timezone:/etc/timezone:ro \
#     -v /etc/localtime:/etc/localtime:ro \
#     -w /BEVFormer \
#     -u root \
#     --gpus all \
#     -it --privileged=true --rm \
#     --name=bevformer \
#     -e DISPLAY=unix$DISPLAY \
#     $DEV_CONTAINER\
#     /bin/bash

# export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libstdc++.so.6.0.28
# pip install requirements.txt

# python tools/create_data.py nuscenes --root-path ./data/nuscenes --out-dir ./data/infos --extra-tag nuscenes --version v1.0-mini --canbus ./data/nuscenes

# ./tools/uniad_dist_eval.sh ./projects/configs/stage1_track_map/base_track_map.py ./ckpts/uniad_base_track_map.pth 1
# ./tools/uniad_dist_eval.sh ./projects/configs/stage2_e2e/base_e2e.py ./ckpts/uniad_base_e2e.pth 1
# ./tools/analysis_tools/visualize/run.py --predroot output/results.pkl --out_folder ./vis-dir --demo_video test_demo.avi --project_to_cam True