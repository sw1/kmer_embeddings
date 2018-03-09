#!/bin/bash

. /etc/profile.d/modules.sh
module load shared
module load proteus
module load sge/univa
module load gcc/4.8.1
module load python/3.6-current

USERNAME=sw424

SCRATCH=/scratch/$USERNAME/embed_reads
OUT=$SCRATCH/out
CODE=/home/$USERNAME/embed_samples/code
DATA=/home/$USERNAME/embed_samples/data/raw
MODELS=/home/$USERNAME/embed_samples/data/models

script=embed_reads.py

mkdir -p $OUT

cp $CODE/embed_functions.py $CODE/r2v_functions.py $CODE/$script $SCRATCH
cp $MODELS/* $SCRATCH
cp $DATA/seqs_ag_split_* $DATA/seqs_ag_ids.dat $SCRATCH

qsub sub_embed_subsets.sh

exit 0
