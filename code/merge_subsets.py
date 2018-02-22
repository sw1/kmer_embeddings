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
import random
import math
import time


out_path = '/home/sw424/embed_samples/out'
subset_path = '/scratch/sw424/embed_samples/out'
subset_fns = [fn for fn in os.listdir(subset_path) if fn.endswith('.pkl')]

accum = {}
for fn in subset_fns:
    
    print('Merging %s.' % (fn))

    subset = six.moves.cPickle.load(open(os.path.join(subset_path,fn),'rb'))
    for sample in subset:
        try:
            accum[sample] += subset[sample]
        except:
            accum[sample] = collections.Counter({})
            accum[sample] += subset[sample]

print('Calculating total_kmers and total_reads.')
total_kmers = collections.Counter({})
total_reads = {}
for sample in accum:
    total_kmers += accum[sample]
    total_reads[sample] = sum(accum[sample].values())
total_kmers_sum = sum(total_kmers.values())
total_kmers = {kmer:count/total_kmers_sum for kmer,count in total_kmers.items()}

print('Saving results.')
six.moves.cPickle.dump({'sample_embeddings':accum,
                        'total_kmers':total_kmers,
                        'total_reads':total_reads},
                       open(os.path.join(out_path,'merged_subsets.pkl'),'wb'))
