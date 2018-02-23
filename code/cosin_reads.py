#!/usr/bin/env python

import os
import pandas as pd
import numpy as np
from sklearn.metrics.pairwise import cosine_similarity as cosim

def get_file_paths(directory):
    for dirpath,_,filenames in os.walk(directory):
        for f in filenames:
            yield os.path.abspath(os.path.join(dirpath,f))

def cosim_search(e,q,qw):
    idx = [i for i,v in enumerate(qw) if v != 0]
    e_idx = e[:,idx]
    q_idx = q[idx].reshape(1,-1)
    
    return cosim(q_idx,e_idx).flatten()


path_lasso = '/home/sw424/embed_samples/out/lasso_weights.csv.gz'
paths_sample = get_file_paths('/home/sw424/embed_samples/out/sample_reads_embeddings')
paths_taxa = [path for path in paths_sample if 'tax' in path]

lasso = pd.read_csv(path_lasso).as_matrix()
s = lasso[:,0]
sw = lasso[:,2]

f = lasso[:,1]
fw = lasso[:,3]



for path_taxa in paths_taxa:

    path_remb = path_taxa.replace('tax','remb')
    path_out = path_taxa.replace('tax','cosim')

    print('Performing cosim search for %s.' % (path_remb))
    
    taxa = pd.read_csv(path_taxa)
    remb = pd.read_csv(path_remb)
    remb = remb.drop(columns=remb.columns[0]).as_matrix().T

    s_sim = cosim_search(remb,s,sw)
    f_sim = cosim_search(remb,f,fw)

    taxa['sim_skin'] = pd.Series(s_sim,index=taxa.index)
    taxa['sim_fecal'] = pd.Series(f_sim,index=taxa.index)

    taxa.to_csv(path_out,compression='gzip')
