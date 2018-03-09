#!/usr/bin/env Rscript

library(tidyverse)
library(dada2)

seed <- 3245
args <- commandArgs(trailingOnly=TRUE)
nc <- as.integer(args[1])

dir_fastq <- '/home/sw424/embed_samples/data/ag/fastq'
dir_filt <- '/home/sw424/embed_samples/data/ag/filtered'
dir.create(dir_filt,showWarnings=FALSE,recursive=TRUE)

fns_fastq <- list.files(dir_fastq,pattern='.fastq.gz',full.names=FALSE)
ids_samp <- gsub('.fastq.gz','',fns_fastq)
path_fastq <- file.path(dir_fastq,fns_fastq)
path_filt <- file.path(dir_filt,gsub('.fastq.gz','_filt.fastq.gz',fns_fastq))

set.seed(seed)

filt <- filterAndTrim(path_fastq, path_filt, truncLen=148, trimLeft=12,
                      maxN=0, maxEE=2, truncQ=2, rm.phix=TRUE,
                      compress=TRUE, multithread=nc)
path_filt <- list.files(dir_filt,pattern='_filt.fastq.gz',full.names=TRUE)

err <- learnErrors(path_filt, multithread=nc)

derep <- derepFastq(path_filt,verbose=TRUE)
names(derep) <- ids_samp

dd <- dada(derep, err=err, pool=TRUE, multithread=nc, verbose=TRUE)

rsv_chim <- makeSequenceTable(dd)

rsv <- removeBimeraDenovo(rsv_chim, method='consensus', multithread=nc, verbose=TRUE)

data.frame(SampleID=rownames(rsv),rsv,stringsAsFactors=FALSE) %>% 
    write_csv('/home/sw424/embed_samples/data/ag/tables/rsv.csv.gz')

tax <- assignTaxonomy(rsv, '/home/sw424/embed_samples/data/dada/gg_13_8_train_set_97.fa.gz', 
                      multithread=nc,verbose=TRUE)

data.frame(Sequence=rownames(tax),tax,stringsAsFactors=FALSE) %>% 
    write_csv('/home/sw424/embed_samples/data/ag/tables/rsv_taxa.csv.gz')
