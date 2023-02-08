import tensorflow as tf
import utils.data as ft_load
import numpy as np
from sklearn.model_selection import train_test_split
from utils.classifier_gen import EEGNet_seq


participant_data_name = "time_domain_mean_intercept_onsets_2_3_4_5_6_7_8_trial-level_onsets.mat"
data, order = ft_load.get_trials(participant_data_name, num_participants=40)

scores = []
X = []
for item in data:
    scores.append(item.events[:, 2])
    X.append(item.get_data())

X = np.concatenate(X)
scores = np.concatenate(scores)


X -= np.min(X)
X /= np.max(X)

X_train, X_test, Y_train, Y_test = train_test_split(X, scores, test_size=0.2, random_state=42)

model = EEGNet_seq(3, 128, 2150, loss='sparse_categorical_crossentropy', dropoutType='SpatialDropout2D', learning_rate=0.001)
model.compile(optimizer='adam', loss='sparse_categorical_crossentropy', metrics=['accuracy'])
history = model.fit(X_train, Y_train, epochs=500, validation_split=0.1)
#save model
model.save("eegnet.h5")

