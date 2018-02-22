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

import h5py
import numpy as np
import pandas as pd
from itertools import product
from operator import itemgetter
from sklearn.manifold import TSNE
import random
import math
import time

from gensim.models import Word2Vec
from gensim.models.word2vec import LineSentence

import embed_functions as emb
import r2v_functions as r2v

k = 10
d = 256
a = 1e-05


path_totalkmers = '/home/sw424/embed_samples/out/total_kmers.pkl'

path_out = '/home/sw424/embed_samples/out/sample_reads_embeddings/'
if not os.path.exists(path_out):
    os.makedirs(path_out)

path_model = '/home/sw424/embed_samples/data/models/gg_%s_%s_5_%s_%s_%s_100_model.pkl' \
        % (k,d,50,10,1e-06)

sample_id = ['ERR1249998','ERR1080271','ERR1233472','ERR1249697','ERR1233470',
             'ERR1073507','ERR1073636','ERR1075330','ERR1073635','ERR1080064']
for sample in sample_id:
    path_sample = '/home/sw424/embed_samples/data/split/%s.fasta' % (sample)
    r2v.embed_reads(path_sample,path_totalkmers,path_model,path_out,k=k,a=1e-5,
            verbose=True,v=1000)