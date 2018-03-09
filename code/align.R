#!/usr/bin/env Rscript


library(tidyverse)
library(Biostrings)
library(parallel)

args <- commandArgs(trailingOnly=TRUE)
nc <- as.integer(args[1])

cat('Reading embedding file.\n')
path_work <- '/home/sw424/embed_samples'
path_out <- file.path(path_work,'out/kegg_reads_embeddings/seqs_align.csv.gz')
dat <- read_csv(file.path(path_work,'out/kegg_reads_embeddings/seqs_cosim.csv.gz')) %>%
  dplyr::select(ReadID=X1,contains(':'))
seqs <- readDNAStringSet(file.path(path_work,'data/kegg/seqs.fasta'))

seqstop50 <- lapply(1:nrow(dat), function(i){
                    x <- dat[i,]
                    q <- unlist(x[1])
                    top50 <- names(sort(unlist(x[-1]),decreasing=TRUE))
                    top50 <- top50[top50 != q][1:50]
                    seqsq <- as.character(seqs[q])
                    seqs50 <- as.character(seqs[top50])
                    list(pattern=seqs50,subject=seqsq)
})

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
