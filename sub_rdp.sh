#!/bin/bash
#$ -S bin/bash
#$ -j y
#$ -cwd
#$ -M sw424@drexel.edu
#$ -l h_rt=24:00:00
#$ -P rosenPrj
#$ -pe shm 1
#$ -l mem_free=64G
#$ -l h_vmem=64G
#$ -q all.q

. /etc/profile.d/modules.sh
module load shared
module load proteus
module load sge/univa
module load gcc/4.8.1
module load perl-threaded/5.24.1 # maybe unload perl first?
module load oracle/jdk/1.7.0_current
module load samtools/1.2
module load qiime/gcc/64/1.9.1
#module load qiime/gcc/64/1.8.0

USERNAME=sw424
SCRATCH=/scratch/$USERNAME/rdp
#SCRATCH=/scratch/$USERNAME/rdp180
DATA=/home/$USERNAME/embed_samples/data/kegg
OUT=${DATA}/rdp

ref_seqs=/mnt/HA/opt/qiime/gcc/64/1.9.1/lib/python2.7/site-packages/qiime_default_reference/gg_13_8_otus/rep_set/97_otus.fasta
ref_tax=/mnt/HA/opt/qiime/gcc/64/1.9.1/lib/python2.7/site-packages/qiime_default_reference/gg_13_8_otus/taxonomy/97_otu_taxonomy.txt
fna=seqs.fasta

mkdir -p $SCRATCH
mkdir -p $OUT

cp $DATA/$fna $SCRATCH/

assign_taxonomy.py -i $SCRATCH/$fna -m rdp --rdp_max_memory 64000 -o $OUT/

exit 0
