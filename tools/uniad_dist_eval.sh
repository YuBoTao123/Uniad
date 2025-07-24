#!/usr/bin/env bash

T=`date +%m%d%H%M`

# -------------------------------------------------- #
# Usually you only need to customize these variables #
CFG=$1                                               #
CKPT=$2                                              #
GPUS=$3                                              #    
# -------------------------------------------------- #
# GPUS_PER_NODE=$(($GPUS<8?$GPUS:8))

# MASTER_PORT=${MASTER_PORT:-28596}
WORK_DIR=$(echo ${CFG%.*} | sed -e "s/configs/work_dirs/g")/
# Intermediate files and logs will be saved to UniAD/projects/work_dirs/

if [ ! -d ${WORK_DIR}logs ]; then
    mkdir -p ${WORK_DIR}logs
fi


# PYTHONPATH="$(dirname $0)/..":$PYTHONPATH \
# python -m torch.distributed.run \
#     --nproc_per_node=$GPUS_PER_NODE \
#     --master_port=$MASTER_PORT \
#     $(dirname "$0")/test.py \
#     $CFG \
#     $CKPT \
#     ${@:4} \
#     --eval bbox \
#     --show-dir ${WORK_DIR} \
#     2>&1 | tee ${WORK_DIR}logs/eval.$T


PYTHONPATH="$(dirname $0)/..":$PYTHONPATH \
python $(dirname "$0")/test.py \
    $CFG \
    $CKPT \
    --eval bbox \
    --show-dir ${WORK_DIR} \
    2>&1 | tee ${WORK_DIR}logs/eval.$T

# ./tools/uniad_dist_eval.sh ./projects/configs/stage1_track_map/base_track_map.py ./ckpts/uniad_base_track_map.pth
# ./tools/uniad_dist_eval.sh ./projects/configs/stage2_e2e/base_e2e.py ./ckpts/uniad_base_e2e.pth
# python ./tools/analysis_tools/visualize/run.py --predroot output/results.pkl \
#   --out_folder ./vis-dir \
#   --demo_video test_demo.avi \
#   --project_to_cam True