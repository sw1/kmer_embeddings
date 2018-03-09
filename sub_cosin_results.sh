#!/bin/bash
#$ -S bin/bash
#$ -j y
#$ -cwd
#$ -M sw424@drexel.edu
#$ -l h_rt=24:00:00
#$ -P rosenPrj
#$ -pe shm 1
##$ -l ua=haswell
#$ -l mem_free=7G
#$ -l h_vmem=8G
#$ -t 1-2

. /etc/profile.d/modules.sh
module load shared
module load proteus
module load sge/univa
module load gcc/4.8.1
module load samtools/1.3.1
module load R/mro/3.3.3

USERNAME=sw424
DATA=/home/$USERNAME/embed_samples

script_reads=$DATA/code/cosin_reads_results.R
script_kmers=$DATA/code/cosin_kmers_results.R

if [[ $SGE_TASK_ID == 1 ]]; then
    $script_reads
fi

if [[ $SGE_TASK_ID == 2 ]]; then
    $script_kmers
fi

exit 0
