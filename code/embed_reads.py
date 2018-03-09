#!/usr/bin/env python

import sys
from sys import argv
import os
import zipfile
from os.path import splitext, isfile
import gzip
import csv
import six.moves.cPickle
import collections
from shutil import copyfile

import numpy as np
import pandas as pd
from itertools import product
from operator import itemgetter
from sklearn.manifold import TSNE
import random
import math
import time
from glob import glob

from gensim.models import Word2Vec
from gensim.models.word2vec import LineSentence

import embed_functions as emb
import r2v_functions as r2v

k = 10
d = 256
a = 1e-05


path_totalkmers = '/home/sw424/embed_samples/out/total_kmers.pkl'

#path_out = '/home/sw424/embed_samples/out/group_reads_embeddings/'
path_out = '/home/sw424/embed_samples/out/kegg_reads_embeddings/'
if not os.path.exists(path_out):
    os.makedirs(path_out)

path_model = '/home/sw424/embed_samples/data/models/gg_%s_%s_5_%s_%s_%s_100_model.pkl' \
        % (k,d,50,10,1e-06)
#path_samples = '/home/sw424/embed_samples/data/groups'
#sample_ids = ['group_1']
path_samples = glob('/home/sw424/embed_samples/data/kegg/*.fasta')
for path_sample in path_samples:
    #fn = '%s.fasta' % (sample)
    #path_sample = os.path.join(path_samples,fn)
    r2v.embed_reads(path_sample,path_totalkmers,path_model,path_out,k=k,a=1e-5,delim=None,
            verbose=True,v=1000)
