########################################
#Author: Gentry Atkinson
#Date: 05 Feb 2020
#Organization: Texas State University
#Description: compare KNN for mislabeled data identification with and without
#   feature extraction.
########################################

PLAIN_TRAIN_IMAGES = "MNIST/Extracted Data/train_images.csv"
PLAIN_TEST_IMAGES = "MNIST/Extracted Data/test_images.csv"
PLAIN_TRAIN_LABELS = "MNIST/Extracted Data/train_labels.csv"
PLAIN_TEST_LABELS = "MNIST/Extracted Data/test_labels.csv"
ALTERED_TRAIN_LABELS = "MNIST/Extracted Data/train_altered_labels.csv"
ALTERED_TRAIN_LABELS_INDEXES = "MNIST/Extracted Data/train_altered_label_indexes.csv"
ALTERED_TEST_LABELS = "MNIST/Extracted Data/test_altered_labels.csv"
ALTERED_TEST_LABELS_INDEXES = "MNIST/Extracted Data/test_altered_label_indexes.csv"
PLAIN_TEST_LABELS = "MNIST/Extracted Data/test_labels.csv"

K = 3
NUMBER_EPOCHS = 3
NUM_TRAINS_SAMPLES = 60000
NUM_TEST_SAMPLES = 10000

import tensorflow as tf
import tensorflow.keras as keras
import numpy as np
from tensorflow.keras.layers import Input
from tensorflow.keras.layers import Conv2D
from tensorflow.keras.layers import MaxPooling2D
from tensorflow.keras.layers import Flatten
from tensorflow.keras.layers import Dense
from tensorflow.keras.layers import Reshape
from tensorflow.keras.layers import Conv2DTranspose

from tensorflow.keras.models import Model

from tensorflow.keras.optimizers import RMSprop

def build_autoenc(images):
    print("Building input layer..................")
    inp = Input(images[0].shape)
    enc = Reshape((28, 28, 1))(inp)

    print("Building encoder.......................")
    enc = Conv2D(filters=32, kernel_size=(3,3), activation='relu', use_bias=True)(enc)
    enc = MaxPooling2D(pool_size=(2,2), data_format='channels_first')(enc)
    enc = Conv2D(filters=16, kernel_size=(3,3), activation='relu', use_bias=True)(enc)
    enc = MaxPooling2D(pool_size=(2,2), data_format='channels_first')(enc)
    hidden = Flatten()(enc)
    #hidden = Dense(784, activation='sigmoid')(enc)

    #print("Building decoder......................")
    dec = Reshape((24, 24, 1))(hidden)
    dec = Conv2DTranspose(filters=16, kernel_size=(3,3), activation='relu')(dec)
    dec = MaxPooling2D(pool_size=(2,2), data_format='channels_first')(dec)
    dec = Conv2DTranspose(filters=32, kernel_size=(3,3), activation='relu')(dec)
    dec = MaxPooling2D(pool_size=(2,2), data_format='channels_first')(dec)
    dec = Reshape((28,28))(dec)
    dec = Flatten()(dec)

    print("Compiling model.......................")
    autoenc = Model(inputs=[inp], outputs=[dec])
    autoenc.compile(optimizer='RMSprop', loss='mean_squared_error', metrics=['acc'])

    autoenc.summary()
    return autoenc

def train_AE(autoenc, train_set):
    print("-----------------Training Autoencoder-----------------")
    print("Passed " + str(len(train_set)) + " segments.")
    print("Segments have length " + str(train_set[0].shape))

    autoenc.fit(x=train_set, y=train_set, epochs=NUMBER_EPOCHS)
    return autoenc


def main():
    images = np.loadtxt(PLAIN_TRAIN_IMAGES, delimiter=',')
    #images = np.zeros((1, 784), dtype="int16")
    #images = images.reshape((NUM_TRAINS_SAMPLES, 28, 28))
    autoenc = build_autoenc(images)
    autoenc = train_AE(autoenc, images)


if __name__ == "__main__":
    main()
