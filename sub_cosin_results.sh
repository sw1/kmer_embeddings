#!/bin/bash
#$ -S bin/bash
#$ -j y
#$ -cwd
#$ -M sw424@drexel.edu
#$ -l h_rt=05:00:00
#$ -P rosenPrj
#$ -pe shm 1
#$ -l ua=haswell
#$ -l mem_free=4G
#$ -l h_vmem=6G
#$ -t 1-2

. /etc/profile.d/modules.sh
module load shared
module load proteus
module load sge/univa
module load gcc/4.8.1
module load samtools/1.3.1

USERNAME=sw424
DATA=/home/$USERNAME/embed_samples

script=$DATA/code/cosin_reads_results.R

$script $SGE_TASK_ID

exit 0
