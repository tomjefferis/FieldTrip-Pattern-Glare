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
X = np.reshape(X, (X.shape[0], X.shape[1], X.shape[2], 1))
mask = np.isnan(X).any(axis=(1, 2, 3))
X = X[~mask]
scores = scores[~mask]

X -= np.min(X)
X /= np.max(X)
scores -= 1
X_train, X_test, Y_train, Y_test = train_test_split(X, scores, test_size=0.2, random_state=42)


model = EEGNet_seq(3, 128, 2150, loss='sparse_categorical_crossentropy', dropoutType='SpatialDropout2D', learning_rate=0.001)
history = model.fit(X_train, Y_train, epochs=500, validation_data=(X_test, Y_test))
#save model
model.save("eegnet.h5")

# plot the accuracy and loss in two subplots
import matplotlib.pyplot as plt
plt.subplot(2, 1, 1)

plt.plot(history.history['accuracy'])
plt.plot(history.history['val_accuracy'])
plt.title('model accuracy')
plt.ylabel('accuracy')
plt.xlabel('epoch')
plt.legend(['train', 'test'], loc='upper left')

plt.subplot(2, 1, 2)
plt.plot(history.history['loss'])
plt.plot(history.history['val_loss'])
plt.title('model loss')
plt.ylabel('loss')
plt.xlabel('epoch')
plt.legend(['train', 'test'], loc='upper left')

#save plot
plt.savefig("eegnet.png")

#show plot
plt.show()

# plot confusion matrix
from sklearn.metrics import confusion_matrix
import seaborn as sns
import pandas as pd

Y_pred = model.predict(X_test)
Y_pred = np.argmax(Y_pred, axis=1)
cm = confusion_matrix(Y_test, Y_pred)
sns.heatmap(cm, annot=True, fmt='g', cmap='Blues')
plt.show()

#save plot
plt.savefig("eegnet_confusion_matrix.png")

#show plot
plt.show()



