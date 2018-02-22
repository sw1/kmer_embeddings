#!/usr/bin/env Rscript

library(tidyverse)
library(Rtsne)

path_data <- '/home/sw424/embed_samples/out'
path_scratch <- '/scratch/sw424/lasso'

seed <- 3245
args <- commandArgs(trailingOnly=TRUE)
i <- as.integer(args[1])

classnames <- c('skin','fecal')
name <- classnames[i]

cosin_fn <- sprintf('cosin_reads_%s.csv.gz',name)
cosin_out_fn <- sprintf('cosin_reads_%s_tsne.csv.gz',name)

cat(sprintf('Reading dataframe for %s.\n',name))

df <- read_csv(file.path(path_data,cosin_fn)) %>%
    rename(kmer=X1)

cat(sprintf('Performing t-SNE on %s.\n',name))

set.seed(seed)
tsne <- Rtsne(df %>% select(`1`:`256`) %>% as.matrix(),
              dims=2,perplexity=100,check_duplicates=FALSE,
              pca=TRUE,initial_dims=50,pca_center=TRUE,pca_scale=FALSE,
              verbose=TRUE)$Y
colnames(tsne) <- c('D1','D2')

cat(sprintf('Saving output to %s.\n',cosin_out_fn))

write_csv(data.frame(df %>% select(kmer,sim),tsne),
          file.path(path_data,cosin_out_fn))
