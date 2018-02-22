#!/usr/bin/env Rscript

library(tidyverse)
library(Rtsne)
library(glmnet)

dat <- readRDS('/home/sw424/embed_samples/out/ag_bodysite_lasso.rds')
meta <- dat$meta
emb <- dat$emb
cv <- dat$cv
tsne <- dat$tsne
rm(dat)

g <- c('UBERON:skin','UBERON:feces')
targets <- data.frame(meta,tsne) %>%
  filter(body_site %in% c(g[1],g[2])) %>%
  group_by(body_site) %>%
    mutate(rank=ifelse(body_site == g[2],dense_rank(desc(X2)),dense_rank(X2))) %>%
    filter(rank <= 5) %>%
      select(SampleID,body_site)


df1 <- data.frame(colMeans(emb[meta$body_site == g[1],]),colMeans(emb[meta$body_site == g[2],]))
colnames(df1) <- c(g)

df2 <- data.frame(sapply(g,function(i) as.vector(coef(cv,min='lambda.min')[[i]])[-1]))
colnames(df2) <- paste0('w_',g)

df3 <- df1*df2
colnames(df3) <- paste0('prod_',g)

df <- data.frame(df1,df2,df3)

write_csv(df,'/home/sw424/embed_samples/out/lasso_weights.csv.gz')
write_csv(targets,'/home/sw424/embed_samples/out/tsne_targets.csv.gz')

cat('Saved weights and targets.')
