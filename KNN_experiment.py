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
NUM_TRAINS_SAMPLES = 60000
NUM_TEST_SAMPLES = 10000

import tensorflow.keras as keras
import numpy as np

def build_autoenc(images):
    print("Building input layer..................")
    inp = Input(images[0].shape)

    print("Building encoder.......................")
    enc = Conv2D(filters=100, kernel_size=(4,4), activation='relu', use_bias=True)(inp)
    print(enc.shape)
    enc = MaxPooling2D(pool_size=100, data_format='channels_first')(enc)
    #enc = GlobalMaxPooling1D()(enc)

    enc = Flatten()(enc)
    hidden = Dense(500, activation='sigmoid')(enc)

    print("Building decoder......................")
    dec = hidden
    print(dec.shape)
    dec = Reshape((500, 1))(dec)
    dec = Conv2DTranspose(dec, filters=100, strides=1, kernel_size=(4,4))
    print(dec.shape)
    dec = MaxPooling1D(pool_size=35, data_format='channels_last')(dec)
    print(dec.shape)
    dec = Flatten()(dec)

    print("Compiling model.......................")
    autoenc = Model(inp, dec)
    autoenc.compile(optimizer='RMSprop', loss='mean_squared_error', metrics=['acc'])

    autoenc.summary()
    return autoenc


def main():
    images = np.loadtxt(PLAIN_TRAIN_IMAGES, delimiter=',')
    autoenc = build_autoenc(images)


if __name__ == "__main__":
    main()
