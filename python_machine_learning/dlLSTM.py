import tensorflow as tf
from keras.layers import LSTM, Dense
from sklearn.model_selection import train_test_split
from tensorflow import keras
from tensorflow.keras import layers
import mne
from matplotlib import pyplot as plt
import utils.time_series as ts
import utils.data as ft_load
import pandas as pd
import numpy as np


participant_data_name = "time_domain_mean_intercept_onsets_2_3_4_5_6_7_8_grand-average_onsets.mat"
data = ft_load.get_participant(participant_data_name, num_participants=40, baseline=(2.8, 3.0))[2]
y = [
        -0.264, 0.4459, -0.49781, 1.77666, -0.55638, 0.87174, -0.68504, 0.92835, -0.80581, -0.87505, 0.39111, -0.76054,
        -0.68987, 1.60776, 1.13956, 1.53606, 0.12186, 0.08428, 0.61663, -1.47958, 2.28422, -0.80891, -0.55738, -0.93291,
        0.3791, -0.63074, 2.14683, -1.49948, 1.21954, -0.79734, -1.0687, -1.02592, -0.87653, 0.444
    ]
for index in range(0,len(data)):
    items = data[index].data
    data[index] = np.delete(items,np.s_[0:102],axis =1) # cuts off before stimulus on

x = np.reshape(data, (34,2048,128,1))
data = []



x_train, x_test, y_train, y_test = train_test_split(x, y, test_size=0.2)



train_dataset = tf.data.Dataset.from_tensor_slices((x_train, y_train))
test_dataset = tf.data.Dataset.from_tensor_slices((x_test, y_test))


BATCH_SIZE = 1
SHUFFLE_BUFFER_SIZE = 100

train_dataset = train_dataset.shuffle(SHUFFLE_BUFFER_SIZE).batch(BATCH_SIZE)
test_dataset = test_dataset.batch(BATCH_SIZE)

#print(x_train.shape, y_train.shape)

model = keras.Sequential()
model.add(layers.Conv2D(64, (4, 4), activation='relu', input_shape=(2048, 128, 1)))
model.add(layers.MaxPooling2D((3, 3)))
model.add(layers.Conv2D(64, (3, 3), activation='relu'))
model.add(layers.MaxPooling2D((2, 2)))
model.add(layers.Flatten())
#model.add(LSTM(128, input_shape=(2048,128)))
model.add(Dense(32))
model.add(Dense(1))
model.compile(loss='mean_squared_error', optimizer='adam',metrics=[tf.keras.metrics.MeanSquaredError()])
model.fit(train_dataset, epochs=250)

model.evaluate(test_dataset)
