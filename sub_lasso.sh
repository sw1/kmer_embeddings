#!/bin/bash
#$ -S bin/bash
#$ -j y
#$ -cwd
#$ -M sw424@drexel.edu
#$ -l h_rt=06:00:00
#$ -P rosenPrj
#$ -pe shm 10
#$ -l mem_free=12G
#$ -l h_vmem=16G
#$ -q all.q

. /etc/profile.d/modules.sh
module load shared
module load proteus
module load sge/univa
module load gcc/4.8.1
module load samtools/1.3.1

USERNAME=sw424
SCRATCH=/scratch/$USERNAME/lasso
DATA=/home/$USERNAME/embed_samples

script=$DATA/code/lasso.R

mkdir -p $SCRATCH

cp $DATA/out/*.csv.gz $SCRATCH
cp $DATA/data/metadata/ag_* $SCRATCH

$script $NSLOTS

mv $SCRATCH/ag_bodysite_lasso.rds $DATA/out/

exit 0
