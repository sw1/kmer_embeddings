#!/usr/bin/env Rscript

library(tidyverse)
library(Rtsne)

path_data <- '/home/sw424/embed_samples/out/group_reads_embeddings'

seed <- 3245
name <- 'group_1'

cosin_fn <- sprintf('%s_cosim.csv.gz',name)
cosin_out_fn <- sprintf('cosim_%s_tsne.csv.gz',name)

cat(sprintf('Reading dataframe for %s.\n',name))
df <- read_csv(file.path(path_data,cosin_fn)) %>%
    rename(ReadID=X1)

cat(sprintf('Performing t-SNE on %s.\n',name))
set.seed(seed)
tsne <- Rtsne(df %>% select(`0`:`255`) %>% as.matrix(),
              dims=2,perplexity=100,check_duplicates=FALSE,
              theta=.9,max_iter=800,
              pca=TRUE,initial_dims=50,pca_center=TRUE,pca_scale=FALSE,
              verbose=TRUE)$Y
colnames(tsne) <- c('D1','D2')

cat(sprintf('Saving output to %s.\n',cosin_out_fn))
write_csv(data.frame(df %>% select(ReadID,f_sim,s_sim,
                                   kingdom,phylum,class,order,family,genus,species,score),
                     tsne,stringsAsFactors=FALSE),
          file.path(path_data,cosin_out_fn))
