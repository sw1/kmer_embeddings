#!/usr/bin/env Rscript


library(tidyverse)
library(Biostrings)
library(parallel)

args <- commandArgs(trailingOnly=TRUE)
nc <- as.integer(args[1])

cat('Reading embedding file.\n')
path_work <- '/home/sw424/embed_samples'
path_out <- file.path(path_work,'out/kegg_reads_embeddings/seqs_align_vsearch.csv.gz')
seqs <- readDNAStringSet(file.path(path_work,'data/kegg/seqs.fasta'))
dat <- read_delim(file.path(path_work,'out/kegg_reads_embeddings/seqs_vsearch.txt'),
                  delim='\t',col_names=FALSE) %>%
       dplyr::select(subject=X1,pattern=X2) %>%
       filter(subject != pattern) %>%
       mutate(seq=as.character(seqs[pattern])) %>%
       group_by(subject) %>%
       split(.$subject)

seqstop50 <- lapply(dat,function(x) list(subject=as.character(seqs[unique(x$subject)]),
                                         pattern=as.character(x$seq)))

rm(dat,seqs)

cat('Performing alignments.\n')
align <- mclapply(seqstop50,function(x){
                  pairwiseAlignment(x$pattern,x$subject,
                  type='global',
                  gapOpening=20,gapExtension=2,
                  scoreOnly=TRUE)
},mc.cores=nc)

names(align) <- sapply(seqstop50,function(x) names(x$subject))

cat(sprintf('Saving output to',path_out))
as_tibble(align) %>%
  write_csv(path_out)
