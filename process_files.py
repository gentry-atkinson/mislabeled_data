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

PLAIN_TRAIN_IMAGES = "MNIST/Extracted Data/train_images.csv"
SAMPLE_TRAIN_IMAGE = "MNIST/Extracted Data/train_image.pgm"
PLAIN_TRAIN_LABELS = "MNIST/Extracted Data/train_labels.csv"
PLAIN_TEST_IMAGES = "MNIST/Extracted Data/test_images.csv"
SAMPLE_TEST_IMAGE = "MNIST/Extracted Data/test_image.pgm"
PLAIN_TEST_LABELS = "MNIST/Extracted Data/test_labels.csv"

import numpy as np

def main():
    print("----Writing training images to csv----")
    with open(TRAIN_IMAGES_FILENAME, "rb") as file:
        byte = file.read(4)
        print("magic number ", byte)
        byte = file.read(4)
        print("number of items ", int.from_bytes(byte, byteorder='big'))
        byte = file.read(4)
        print("number of rows ", int.from_bytes(byte, byteorder='big'))
        byte = file.read(4)
        print("number of columns ", int.from_bytes(byte, byteorder='big'))
        output = np.zeros((60000, 28, 28), dtype='int16')
        image_file = open(SAMPLE_TRAIN_IMAGE, "w+")
        image_file.write("P2\n")
        image_file.write("28 28\n")
        image_file.write("255\n")
        for i in range(60000):
            for j in range(28):
                for k in range(28):
                    byte = file.read(1)
                    output[i][j][k] = int.from_bytes(byte, byteorder='big')
                    if (i == 59999):
                        image_file.write(str(int.from_bytes(byte, byteorder='big')))
                        image_file.write(' ')
                        if (k == 27):
                            image_file.write("\n")
        np.savetxt(PLAIN_TRAIN_IMAGES, output.reshape((60000, 28*28)), delimiter=',')
        image_file.close()
        file.close()

        print("\n----Writing training labels to csv----")
        with open(TRAIN_LABELS_FILENAME, "rb") as file:
            byte = file.read(4)
            print("magic number ", byte)
            byte = file.read(4)
            print("number of items ", int.from_bytes(byte, byteorder='big'))
            byte = file.read(4)
            output = np.zeros((60000), dtype='int16')
            for i in range(60000):
                output[i] = int.from_bytes(byte, byteorder='big')
            np.savetxt(PLAIN_TRAIN_LABELS, output, delimiter=',')
            file.close()

        print("\n----Writing test labels to csv----")
        with open(TEST_IMAGES_FILENAME, "rb") as file:
            byte = file.read(4)
            print("magic number ", byte)
            byte = file.read(4)
            print("number of items ", int.from_bytes(byte, byteorder='big'))
            byte = file.read(4)
            print("number of rows ", int.from_bytes(byte, byteorder='big'))
            byte = file.read(4)
            print("number of columns ", int.from_bytes(byte, byteorder='big'))
            output = np.zeros((10000, 28, 28), dtype='int16')
            image_file = open(SAMPLE_TEST_IMAGE, "w+")
            image_file.write("P2\n")
            image_file.write("28 28\n")
            image_file.write("255\n")
            for i in range(10000):
                for j in range(28):
                    for k in range(28):
                        byte = file.read(1)
                        output[i][j][k] = int.from_bytes(byte, byteorder='big')
                        if (i == 9999):
                            image_file.write(str(int.from_bytes(byte, byteorder='big')))
                            image_file.write(' ')
                            if (k == 27):
                                image_file.write("\n")
            np.savetxt(PLAIN_TEST_IMAGES, output.reshape((10000, 28*28)), delimiter=',')
            image_file.close()
            file.close()

            print("\n----Writing test labels to csv----")
            with open(TEST_LABELS_FILENAME, "rb") as file:
                byte = file.read(4)
                print("magic number ", byte)
                byte = file.read(4)
                print("number of items ", int.from_bytes(byte, byteorder='big'))
                byte = file.read(4)
                output = np.zeros((10000), dtype='int16')
                for i in range(10000):
                    output[i] = int.from_bytes(byte, byteorder='big')
                np.savetxt(PLAIN_TEST_LABELS, output, delimiter=',')
                file.close()


if __name__ == "__main__":
    main()
