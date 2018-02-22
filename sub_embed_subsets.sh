#!/bin/bash
#$ -S bin/bash
#$ -j y
#$ -cwd
#$ -M sw424@drexel.edu
#$ -l h_rt=00:15:00
#$ -P rosenPrj
#$ -pe shm 1
#$ -l mem_free=3G
#$ -l h_vmem=4G
#$ -q all.q
#$ -t 1-754

. /etc/profile.d/modules.sh
module load shared
module load proteus
module load sge/univa
module load gcc/4.8.1
module load python/3.6-current

USERNAME=sw424

k=10
SCRATCH=/scratch/$USERNAME/embed_samples

py=/mnt/HA/opt/python/3.6.1/bin/python3
script=embed_subsets.py

cd $SCRATCH

$py $script $SGE_TASK_ID $k

exit 0
