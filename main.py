import numpy as np
import pandas as pd
import tensorflow as tf
import sys
import sklearn

sys.path.append("SAUCIE")
import SAUCIE

filename = sys.argv[1]
print(filename)
out_filename = sys.argv[2]
tf.reset_default_graph()

# get input file as np array
data = np.loadtxt(filename)

saucie = SAUCIE.SAUCIE(data.shape[1])
loadtrain = SAUCIE.Loader(data, shuffle=True)
saucie.train(loadtrain, steps=1000)

loadeval = SAUCIE.Loader(data, shuffle=False)
embedding = saucie.get_embedding(loadeval)
number_of_clusters, clusters = saucie.get_clusters(loadeval)
#reconstruction = saucie.get_reconstruction(loadeval)
df_out = pd.DataFrame(data=embedding, columns=["SAUCIE1", "SAUCIE2"])
df_out["clusters"] = clusters

#write df_out to file
np.savetxt(out_filename, df_out)
