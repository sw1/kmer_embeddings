#!/usr/bin/env Rscript

library(tidyverse)
library(dada2)
library(Biostrings)

seed <- 311
args <- commandArgs(trailingOnly=TRUE)
nc <- as.integer(args[1])
i <- as.integer(args[2])

wd <- '/scratch/sw424/rdp'
remb_path <- '/home/sw424/embed_samples/out/sample_reads_embeddings'
fna_path <- '/home/sw424/embed_samples/data/split'
trainset <- '/home/sw424/embed_samples/data/dada/gg_13_8_train_set_97.fa.gz'

fnas <- list.files(remb_path,full.names=FALSE)
fnas <- fnas[grepl('^.*_remb.csv.gz$',fnas)]
samples <- sort(gsub('^(.*)_remb.csv.gz$','\\1',fnas))

sample <- samples[i]
fna <- file.path(fna_path,paste0(sample,'.fasta'))

set.seed(seed)

cat(sprintf('Classifying taxa for %s.\n',sample))
seqs <- as.character(readDNAStringSet(fna))
tax <- data.frame(unname(assignTaxonomy(seqs,trainset,verbose=TRUE)),stringsAsFactors=FALSE)

write_csv(tax,sprintf('%s/%s_tax.csv.gz',remb_path,sample))

