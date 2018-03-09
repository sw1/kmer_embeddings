#!/usr/bin/env python

import os
import re
import pandas as pd
import numpy as np
from sklearn.metrics.pairwise import cosine_similarity as cosim

def get_file_paths(directory):
    for dirpath,_,filenames in os.walk(directory):
        for f in filenames:
            yield os.path.abspath(os.path.join(dirpath,f))

def cosim_search(e,q=None,qw=None):
    
    if (q is None) or (qw is None):
       
        return cosim(e,e)
    
    else:
    
        idx = [i for i,v in enumerate(qw) if v != 0]
        e = e.as_matrix()
        e_idx = e[:,idx]
        q_idx = q[idx].reshape(1,-1)
   
        return cosim(q_idx,e_idx).flatten()

def read_taxa(path,verbose=False,v=100000):
    headers = ['readid','kingdom','phylum','class','order','family','genus','species','score']
    data = {h:[] for h in headers}
    with open(path,'r') as f:
        for i,line in enumerate(f):
            line = re.split('\t|;',line.strip('\n'))
            data['readid'].append(line[0])
            data['score'].append(line[-1])
            tax = line[1:-1]
            for j in range(len(tax)):
                data[headers[j+1]].append(tax[j])
            if len(tax) < 7:
                for j in range(len(tax),7):
                    data[headers[j+1]].append(headers[j+1][0] + '__')
            if verbose:
                if i % v == 0:
                    print('Processing read %s.' % i)

    df = pd.DataFrame.from_dict(data,orient='columns')
    df = df.set_index('readid')
    df.index.name = None

    return df

paths_remb = get_file_paths('/home/sw424/embed_samples/out/kegg_reads_embeddings')
paths_remb = [path for path in paths_remb if 'remb' in path]
path_taxa = '/home/sw424/embed_samples/data/kegg/rdp/seqs_tax_assignments.txt'

for path_remb in paths_remb:

    path_out = path_remb.replace('remb','cosim')

    print('Reading taxa data.')
    taxa = read_taxa(path_taxa)
    
    print('Reading embedding data.')
    remb = pd.read_csv(path_remb,index_col=0)

    print('Performing cosim search for %s.' % (path_remb))
    sim = pd.DataFrame(cosim_search(remb),index=remb.index,columns=remb.index)

    print('Joining cosim, embedding, and taxa.')
    sim = sim.join(taxa,how='outer')
    sim = sim.join(remb,how='outer')

    print('Saving output')
    sim.to_csv(path_out,compression='gzip')
