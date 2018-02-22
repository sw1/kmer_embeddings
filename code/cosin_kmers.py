#!/usr/bin/env python

import os
import pandas as pd
import numpy as np
from sklearn.metrics.pairwise import cosine_similarity as cosim
from gensim.models import Word2Vec

def cosim_search(vocab,e,q,qw):
   
   idx = [i for i,v in enumerate(qw) if v != 0]
   
   e_idx = e[:,idx]
   q_idx = q[idx].reshape(1,-1)

   sim = cosim(q_idx,e_idx).flatten()
   
   columns = ['sim'] + [str(i+1) for i in range(e.shape[1])]
   df = {k:(sim[i],) + tuple(e[i,:]) for i,k in enumerate(vocab)}
   df = pd.DataFrame(df).T
   df.columns = columns

   return df


k = 10
d = 256

path_lasso = '/home/sw424/embed_samples/out/lasso_weights.csv.gz'
path_model = '/home/sw424/embed_samples/data/models/gg_%s_%s_5_%s_%s_%s_100_model.pkl' \
        % (k,d,50,10,1e-06)

model = Word2Vec.load(path_model).wv
vocab = model.vocab
e = np.asarray([model[kmer] for kmer in vocab])

lasso = pd.read_csv(path_lasso).as_matrix()

s = lasso[:,0]
sw = lasso[:,2]

f = lasso[:,1]
fw = lasso[:,3]

s_sim = cosim_search(vocab,e,s,sw)
f_sim = cosim_search(vocab,e,f,fw)

f_sim.to_csv('/home/sw424/embed_samples/out/cosin_reads_fecal.csv.gz',compression='gzip')
s_sim.to_csv('/home/sw424/embed_samples/out/cosin_reads_skin.csv.gz',compression='gzip')
