from datetime import datetime
from os.path import exists

from packaging import version
import tensorflow as tf
from keras.layers import LSTM, Dense
from sklearn.model_selection import train_test_split
from tensorflow import keras
from tensorflow.keras import layers
import tensorboard
import mne
from matplotlib import pyplot as plt
import utils.time_series as ts
import utils.data as ft_load
import pandas as pd
import numpy as np
from utils.scores import *
from utils.classifier_gen import *

participant_data_name = "time_domain_mean_intercept_onsets_2_3_4_5_6_7_8_trial-level_onsets.mat"
data, order = ft_load.get_trials(participant_data_name, num_participants=3)
y = matchscores(getscore('discomfort'),order)

scores = []

for index in range(0,len(data)):
    items = data[index].get_data()
    events = np.squeeze(np.delete(data[index].events,slice(2),1))
    items = items[events == 2]
    #normalize data
    #items = (items - np.mean(items)) / np.std(items)

    #data[index] = items[:25,:,:]
    scores.append(multiplyscores(y[index],items))
    data[index] = items

#x = np.reshape(data, (len(data),2150,25,128,1))


scores = np.concatenate(scores)
#scores = np.reshape(scores, (len(scores),1))
data = np.concatenate(data)
data = np.reshape(data, (len(data),128,2150,1))
# normalize data using sklearn


#data = np.reshape(data, (len(data),2150,1,128,1))
x_train, x_test, y_train, y_test = train_test_split(data, scores, test_size=0.2)



train_dataset = tf.data.Dataset.from_tensor_slices((x_train, y_train))
test_dataset = tf.data.Dataset.from_tensor_slices((x_test, y_test))


BATCH_SIZE = 3
SHUFFLE_BUFFER_SIZE = 50

train_dataset = train_dataset.shuffle(SHUFFLE_BUFFER_SIZE).batch(BATCH_SIZE)
test_dataset = test_dataset.batch(BATCH_SIZE)

#print(x_train.shape, y_train.shape)
# Define the Keras TensorBoard callback.
logdir="logs/fit/" + datetime.now().strftime("%Y%m%d-%H%M%S")
tensorboard_callback = keras.callbacks.TensorBoard(log_dir=logdir)
#model = keras.Sequential()
#model.add(layers.ConvLSTM2D(filters=40, kernel_size=(3, 3),input_shape=(2150, 1, 128, 1),padding='same', return_sequences=True))
#model.add(layers.BatchNormalization())
##model.add(layers.ConvLSTM2D(filters=40, kernel_size=(3, 3),input_shape=(2150, 1, 128, 1),padding='same', return_sequences=True))
#model.add(layers.BatchNormalization())
#model.add(layers.Flatten())
#model.add(layers.Dense(128))
#model.add(layers.Dense(1))
#model.compile(loss=tf.keras.losses.MeanSquaredError(), optimizer='adam', metrics=['accuracy'])
#model.fit(x_train,y_train, epochs=50,callbacks=[tensorboard_callback])

#model.evaluate(x_test, y_test)
#if model exists load it
if exists("models/EEGNet_seq_pattern_glare_class.h5"):
    model = keras.models.load_model("models/EEGNet_seq_pattern_glare_class.h5")
else:
    model = EEGNet_seq(8,128,2150)

model.fit(x_train,y_train, epochs=5000,batch_size=100)
#save model
model.save('models/EEGNet_seq_pattern_glare_class.h5')
model.evaluate(x_test, y_test)