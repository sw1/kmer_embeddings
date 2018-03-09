#!/bin/bash
#$ -S bin/bash
#$ -j y
#$ -cwd
#$ -M sw424@drexel.edu
#$ -l h_rt=06:00:00
#$ -P rosenPrj
#$ -pe shm 1
#$ -l mem_free=14G
#$ -l h_vmem=16G
#$ -q all.q

. /etc/profile.d/modules.sh
module load shared
module load proteus
module load sge/univa
module load gcc/4.8.1
module load python/3.6-current

USERNAME=sw424

py=/mnt/HA/opt/python/3.6.1/bin/python3
script=/home/$USERNAME/embed_samples/code/embed_samples.py

$py $script $SGE_TASK_ID $k

exit 0
