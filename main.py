import numpy as np
import pandas as pd
import tensorflow as tf
import sys
import sklearn

# from sklearn import datasets
# iris = datasets.load_iris()
# data = iris.data[:, :2] 

sys.path.append("SAUCIE")
import SAUCIE

filename = sys.argv[1]
out_filename = sys.argv[2]
lambda_b = float(sys.argv[3])
lambda_c = float(sys.argv[4])
lambda_d = float(sys.argv[5])
#tf.reset_default_graph()

# get input file as np array
data = np.loadtxt(filename)

saucie = SAUCIE.SAUCIE(data.shape[1], lambda_b=lambda_b, lambda_c=lambda_c, lambda_d=lambda_d)
loadtrain = SAUCIE.Loader(data, shuffle=True)
saucie.train(loadtrain, steps=1000)

loadeval = SAUCIE.Loader(data, shuffle=False)
embedding = saucie.get_embedding(loadeval)
number_of_clusters, clusters = saucie.get_clusters(loadeval)
#reconstruction = saucie.get_reconstruction(loadeval)
df_out = pd.DataFrame(data=embedding, columns=["SAUCIE1", "SAUCIE2"])
df_out["cluster_id"] = clusters

#write df_out to file
np.savetxt(out_filename, df_out)
