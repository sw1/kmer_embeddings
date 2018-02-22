#!/usr/bin/env Rscript

library(tidyverse)
library(glmnet)
library(doMC)
library(parallel)
library(Rtsne)

wd <- '/scratch/sw424/lasso'

seed <- 3245
args <- commandArgs(trailingOnly=TRUE)
nc <- as.integer(args[1])

cat('Preparing metadata.\n')
meta <- read_rds(file.path(wd,'ag_metadata.rds')) %>%
  select(PRIMARY_ID,sex,diet_type,body_site,age_corrected,bmi,gluten,dog,cat,thyroid) %>%
  left_join(read_delim(file.path(wd,'ag_PRJEB11419.txt'),delim='\t') %>%
            select(PRIMARY_ID=secondary_sample_accession,SampleID=run_accession),
            by='PRIMARY_ID') %>%
  left_join(read_csv(file.path(wd,'sample_ids.csv.gz')) %>%
            rename(SampleID=X1,idx=`0`),
            by='SampleID') %>%
  left_join(read_csv(file.path(wd,'total_reads.csv.gz')) %>%
            rename(SampleID=X1,total_reads=`0`),
            by='SampleID') %>%
  filter(!is.na(idx),
         total_reads >= 10000) %>%
  select(-PRIMARY_ID) %>%
  arrange(idx) %>%
  filter(!is.na(body_site),
         body_site %in% c('UBERON:feces','UBERON:skin of hand',
                          'UBERON:skin of head','UBERON:tongue')) %>%
  mutate(body_site=as.character.factor(body_site),
         body_site=ifelse(body_site %in% c('UBERON:skin of hand',
                                           'UBERON:skin of head'),
                          'UBERON:skin',
                          body_site))

cat('Loading embeddings.\n')
emb <- t(read_csv(file.path(wd,'sample_embeddings.csv.gz'))[,-1][,meta$idx + 1])

cat(sprintf('Creating cluster with %s cores.\n',nc))
registerDoMC(nc)
cat('Performing lasso cross validation.\n')
set.seed(seed)
cv <- cv.glmnet(emb,meta$body_site,family='multinomial',type.measure='class',parallel=TRUE)

cat('Performing t-SNE.')
tsne1 <- Rtsne(emb,dimx=2,perplexity=30,theta=.5,check_duplicates=FALSE,
               pca_center=FALSE,pca=FALSE)$Y

cat('Saving results.\n')
saveRDS(list(cv=cv,emb=emb,meta=meta,tsne=tsne1),file.path(wd,'ag_bodysite_lasso.rds'))

