# plot confusion matrix
from sklearn.metrics import confusion_matrix
import seaborn as sns
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import tensorflow as tf
import utils.data as ft_load

model = tf.keras.models.load_model("eegnet.h5")

participant_data_name = "time_domain_mean_intercept_onsets_2_3_4_5_6_7_8_trial-level_onsets.mat"
data, order = ft_load.get_trials(participant_data_name, num_participants=4)

scores = []
X = []
for item in data:
    scores.append(item.events[:, 2])
    X.append(item.get_data())

X = np.concatenate(X)
scores = np.concatenate(scores)
X = np.reshape(X, (X.shape[0], X.shape[1], X.shape[2], 1))
mask = np.isnan(X).any(axis=(1, 2, 3))
X = X[~mask]
scores = scores[~mask]

scores -= 1

Y_pred = model.predict(X)
Y_pred = np.argmax(Y_pred, axis=1)
cm = confusion_matrix(scores, Y_pred)
sns.heatmap(cm, annot=True, fmt='g', cmap='Blues')
plt.show()

#save plot
plt.savefig("eegnet_confusion_matrix.png")

#show plot
plt.show()