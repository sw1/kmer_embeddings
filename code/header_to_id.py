#!/usr/bin/env python

import pickle

ids = set()
with open('/home/sw424/embed_samples/data/raw/seqs_ag_headers.dat') as file:

    for line in file:
        ids.add(line[1:line.find('_')])

pickle.dump(list(ids),open('/home/sw424/embed_samples/data/raw/seqs_ag_ids.dat','wb'))
