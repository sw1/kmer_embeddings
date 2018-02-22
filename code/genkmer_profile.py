#!/usr/bin/env python

import sys
sys.path.insert(0, '/data/sw1/embeddings/code/')

from sys import argv
import os
import zipfile
from os.path import splitext, isfile
import gzip
import csv
import six.moves.cPickle
import collections
from shutil import copyfile

import matplotlib.pyplot as plt
from matplotlib.pyplot import cm
from ggplot import *

import numpy as np
import pandas as pd
from itertools import product
from operator import itemgetter
from sklearn.manifold import TSNE
import random
import math
import time
from sklearn.decomposition import TruncatedSVD
from scipy import sparse
from sklearn.metrics.pairwise import cosine_similarity

from gensim.models import Word2Vec
from gensim.models.word2vec import LineSentence

import embed_functions as emb
import r2v_functions as r2v

k = 10

path_models = '/data/sw1/embeddings/models'
path_raw = '/data/sw1/embeddings/data/raw'
path_kmers = '/data/sw1/embeddings/data/kmers/query'

reads_fn = 'seqs_ag.fna.gz'
kmers_fn = 'kmers_ag_profile.pkl'
model_fn = 'gg_%s_%s_5_%s_%s_%s_100_model.pkl' % (k,256,50,10,1e-06)

path_reads = os.path.join(path_raw,reads_fn)
path_model = os.path.join(path_models,model_fn)
path_kmers = os.path.join(path_kmers,kmers_fn)

r2v.gen_kmer_profile(path_reads,path_model,path_kmers,k=k,verbose=True,v=10000)
