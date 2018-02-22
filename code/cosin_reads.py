import os
import pandas as pd
import numpy as np
from sklearn.metrics.pairwise import cosine_similarity as cosim

sample_path = '/home/sw424/embed_samples/out/sample_reads_embeddings'

sample = 'ERR1073507_remb.csv.gz'

print('Reading dataframe.')
emb = pd.read_csv(os.path.join(sample_path,sample)).as_matrix()

print(emb.shape)
