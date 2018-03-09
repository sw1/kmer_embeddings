#!/bin/bash
#$ -S bin/bash
#$ -j y
#$ -cwd
#$ -M sw424@drexel.edu
#$ -l h_rt=04:00:00
#$ -P rosenPrj
#$ -pe shm 64
#$ -l mem_free=3G
#$ -l h_vmem=4G
#$ -q all.q@@amdhosts

. /etc/profile.d/modules.sh
module load shared
module load proteus
module load sge/univa
module load gcc/4.8.1
module load vsearch/gcc/1.10.0

USERNAME=sw424

SCRATCH=/scratch/$USERNAME/vsearch
WORK=/home/$USERNAME/embed_samples
OUT=$WORK/out/kegg_reads_embeddings

name=kegg
reads=seqs.fasta
results=seqs_vsearch.txt

mkdir -p $SCRATCH

cp $WORK/data/$name/$reads $SCRATCH/

cd $SCRATCH

vsearch --allpairs_global $SCRATCH/$reads --uc $results --id 0.5 --threads $NSLOTS

cp $results $OUT/

exit 0
