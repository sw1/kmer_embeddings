#!/bin/bash
#$ -S bin/bash
#$ -j y
#$ -cwd
#$ -M sw424@drexel.edu
#$ -l h_rt=24:00:00
#$ -l ua=haswell
#$ -P rosenPrj
#$ -pe shm 16
#$ -l mem_free=3G
#$ -l h_vmem=4G

. /etc/profile.d/modules.sh
module load shared
module load proteus
module load sge/univa
module load gcc/4.8.1
module load samtools/1.3.1
module load R/mro/3.4.3

USERNAME=sw424
DATA=/home/$USERNAME/embed_samples

script=$DATA/code/dada.R

mkdir -p $SCRATCH

$script $NSLOTS

exit 0
