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

from gensim.models import Word2Vec
from gensim.models.word2vec import LineSentence

import embed_functions as emb
import r2v_functions as r2v


ss = int(argv[1])-1
k = int(argv[2])

path_reads = 'seqs_ag_split_%.3i' % (ss)
path_model = 'gg_%s_%s_5_%s_%s_%s_100_model.pkl' % (k,256,50,10,1e-06)
path_samples = 'seqs_ag_ids.dat'
path_profile = 'out/profile_ag_split_%.3i.pkl' % (ss)

r2v.gen_kmer_profile_dict(path_reads,path_model,path_profile,k)
