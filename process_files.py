########################################
#Author: Gentry Atkinson
#Date: 04 Feb 2020
#Organization: Texas State University
#Description: read the MNIST files into CSVs
########################################

TRAIN_IMAGES_FILENAME = "MNIST/train-images-idx3-ubyte"
TRAIN_LABELS_FILENAME = "MNIST/train-labels-idx1-ubyte"
TEST_IMAGES_FILENAME = "MNIST/t10k-images-idx3-ubyte"
TEST_LABELS_FILENAME = "MNIST/t10k-labels-idx1-ubyte"

PLAIN_TRAIN_IMAGES = "MNIST/train_images.csv"

import numpy as np

def main():
    with open(TRAIN_IMAGES_FILENAME, "rb") as file:
        byte = file.read(4)
        print("maginc number ", byte)
        byte = file.read(4)
        print("number of items ", int.from_bytes(byte, byteorder='big'))
        byte = file.read(4)
        print("number of rows ", int.from_bytes(byte, byteorder='big'))
        byte = file.read(4)
        print("number of columns ", int.from_bytes(byte, byteorder='big'))
        output = np.zeros((60000, 28, 28), dtype='int')
        for i in range(60000):
            for j in range(28):
                for k in range(28):
                    byte = file.read(1)
                    output[i][j][k] = int.from_bytes(byte, byteorder='big')
        np.savetxt(PLAIN_TRAIN_IMAGES, output.reshape((60000, 28*28)), delimiter=',')


if __name__ == "__main__":
    main()
