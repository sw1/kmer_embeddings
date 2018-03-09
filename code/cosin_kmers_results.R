#!/usr/bin/env Rscript

library(tidyverse)
library(Rtsne)

path_data <- '/home/sw424/embed_samples/out'

seed <- 3245

cosin_fecal_fn <- 'cosin_kmers_fecal.csv.gz'
cosin_skin_fn <- 'cosin_kmers_skin.csv.gz'
cosin_out_fn <- 'cosin_kmers_tnse.csv.gz'

cat('Reading dataframe\n.')
df <- read_csv(file.path(path_data,cosin_fecal_fn)) %>%
    rename(kmer=X1,
           f_sim=sim) %>%
    left_join(read_csv(file.path(path_data,cosin_skin_fn)) %>% 
              select(kmer=X1,
                     s_sim=sim),
              by='kmer')

cat('Performing t-SNE.\n')
set.seed(seed)
tsne <- Rtsne(df %>% select(`1`:`256`) %>% as.matrix(),
              dims=2,perplexity=100,check_duplicates=FALSE,
              theta=.9,max_iter=800,
              pca=TRUE,initial_dims=50,pca_center=TRUE,pca_scale=FALSE,
              verbose=TRUE)$Y
colnames(tsne) <- c('D1','D2')

cat(sprintf('Saving output to %s.\n',cosin_out_fn))
write_csv(data.frame(df %>% select(kmer,f_sim,s_sim),tsne,stringsAsFactors=FALSE),
          file.path(path_data,cosin_out_fn))
