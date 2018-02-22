#!/bin/bash
#$ -S bin/bash
#$ -j y
#$ -cwd
#$ -M sw424@drexel.edu
#$ -l h_rt=12:00:00
#$ -P rosenPrj
#$ -pe shm 1
#$ -l mem_free=6G
#$ -l h_vmem=8G
##$ -q all.q@@intelhosts
#$ -t 1-10

. /etc/profile.d/modules.sh
module load shared
module load proteus
module load sge/univa
module load gcc/4.8.1
module load samtools/1.3.1

USERNAME=sw424
SCRATCH=/scratch/$USERNAME/rdp
DATA=/home/$USERNAME/embed_samples

script=$DATA/code/rdp.R

mkdir -p $SCRATCH

$script $NSLOTS $SGE_TASK_ID

exit 0
