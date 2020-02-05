########################################
#Author: Gentry Atkinson
#Date: 05 Feb 2020
#Organization: Texas State University
#Description: randomly alter several labels in the MNIST CSVs
########################################


PLAIN_TRAIN_LABELS = "MNIST/Extracted Data/train_labels.csv"
PLAIN_TEST_LABELS = "MNIST/Extracted Data/test_labels.csv"
ALTERED_TRAIN_LABELS = "MNIST/Extracted Data/train_altered_labels.csv"
ALTERED_TRAIN_LABELS_INDEXES = "MNIST/Extracted Data/train_altered_label_indexes.csv"
ALTERED_TEST_LABELS = "MNIST/Extracted Data/test_altered_labels.csv"
ALTERED_TEST_LABELS_INDEXES = "MNIST/Extracted Data/test_altered_label_indexes.csv"

PERCENT_TO_ALTER = 1
NUM_TRAINS_SAMPLES = 60000
NUM_TEST_SAMPLES = 10000

import numpy as np
import random as rand

def main():
    train_labels = np.loadtxt(PLAIN_TRAIN_LABELS, delimiter=',')
    altered_labels = open(ALTERED_TRAIN_LABELS, "w+")
    altered_indexes = open(ALTERED_TRAIN_LABELS_INDEXES, "w+")
    rand.seed()
    index = -1
    for label in train_labels:
        index = index + 1
        label = int(label)
        if rand.randint(0,100)<PERCENT_TO_ALTER:
            newLabel = rand.randint(0,10)
            while newLabel == label:
                newLabel = rand.randint(0,10)
            altered_labels.write(str(newLabel))
            altered_labels.write("\n")
            altered_indexes.write(str(index))
            altered_indexes.write("\n")
            print("Index ", index, " changed from ", label, " to ", newLabel)
        else:
            altered_labels.write(str(label))
            altered_labels.write("\n")


if __name__ == "__main__":
    main()
