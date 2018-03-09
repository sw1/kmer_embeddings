#!/usr/bin/env python

from sys import argv
import os
from os.path import splitext, isfile
import gzip
import csv
import six.moves.cPickle
import collections

import pandas as pd
import numpy as np
from itertools import product
import random
import math
import time

from sklearn.decomposition import TruncatedSVD
from gensim.models import Word2Vec
from gensim.models.word2vec import LineSentence

k = 10
d = 256
a = 1e-05

out_path = '/home/sw424/embed_samples/out/ag_samples_embeddings'

print('Loading sample kmers.')
sample_profile = six.moves.cPickle.load(open(os.path.join(out_path,'merged_subsets.pkl'),'rb'))
samples = sample_profile['sample_embeddings']
total_kmers = sample_profile['total_kmers']
total_reads = sample_profile['total_reads']
del sample_profile

print('Loading model.')
path_model = '/home/sw424/embed_samples/data/models/gg_%s_%s_5_%s_%s_%s_100_model.pkl' % (k,d,50,10,1e-06)
model = Word2Vec.load(path_model).wv

sample_ids = []
sample_idx = {sample:i for i,sample in enumerate(samples)}
embeddings = np.zeros((d,len(sample_idx)),dtype='float64')
for i,sample in enumerate(samples):
    print('%.4i: Embedding sample %s.' % (i,sample))
    sample_ids.append(sample)
    sample_kmers = samples[sample]
    n_kmers = 0
    embedding = np.zeros(d,dtype='float64')
    for kmer in sample_kmers:
        embedding += model[kmer] * sample_kmers[kmer] * (a/(a + total_kmers[kmer]))
        n_kmers += sample_kmers[kmer]
    embedding /= n_kmers
    #embedding /= total_reads[sample]
    embeddings[:,sample_idx[sample]] = embedding

print('Performing SVD.')
svd = TruncatedSVD(n_components=1, n_iter=7, random_state=0)
svd.fit(embeddings)
pc = svd.components_

print('Saving embedding matrix and sample indexes.')
#df_samples = pd.DataFrame.from_dict(sample_idx,orient='index')
#df_samples.to_csv(os.path.join(out_path,'sample_ids.csv.gz'),compression='gzip')

df_embeddings = pd.DataFrame(embeddings.T,index=sample_ids)
df_embeddings.to_csv(os.path.join(out_path,'sample_embeddings_raw.csv.gz'),compression='gzip')

embeddings -= embeddings.dot(pc.T) * pc

df_embeddings = pd.DataFrame(embeddings.T,index=sample_ids)
df_embeddings.to_csv(os.path.join(out_path,'sample_embeddings.csv.gz'),compression='gzip')

