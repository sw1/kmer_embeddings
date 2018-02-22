#!/bin/bash
#$ -S bin/bash
#$ -cwd
#$ -j y
#$ -M sw424@drexel.edu
#$ -l h_rt=02:00:00
#$ -P rosenPrj
#$ -pe shm 1
#$ -l mem_free=12G
#$ -l h_vmem=16G
#$ -q all.q

. /etc/profile.d/modules.sh
module load shared
module load proteus
module load sge/univa
module load gcc/4.8.1
module load qiime/gcc/64/1.9.1

USERNAME=sw424
fasta=/home/$USERNAME/embed_samples/data/raw/seqs_ag.fna
out=/home/$USERNAME/embed_samples/data/split

split_sequence_file_on_sample_ids.py -i $fasta -o $out

exit 0
