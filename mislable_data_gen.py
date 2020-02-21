########################################
#Author: Gentry Atkinson
#Date: 05 Feb 2020
#Organization: Texas State University
#Description: randomly alter several labels in an arbitrary file
########################################

import random as rand
import sys
import numpy as np

def main():
    if len(sys.argv) != 5:
        print("Usage is mislable_data_gen inputFile outputFile numberLabels percentToAlter")
        exit()
    inFileName = sys.argv[1]
    outFileName = sys.argv[2]
    numLabels = int(sys.argv[3])
    percentAlter = int(sys.argv[4])

    inFile = open(inFileName, 'r')
    outFile = open(outFileName, 'w+')
    outIndexes = open("alter_indexes.csv", 'w+')
    oldLabelCount = np.zeros(numLabels, dtype='int16')
    newLabelCount = np.zeros(numLabels, dtype='int16')

    index = 0

    labelArray = np.loadtxt(inFileName, '\n');

    for label in labelArray:
        checker = rand.randint(1, 100)
        oldLabelCount[label] += 1
        if(checker < percentAlter):
            oldLabel = label
            while oldLabel == label:
                label = rand.randint(0, numLabels-1)
            outIndexes.write(str(index) + "\n")
        newLabelCount[label] += 1
        outFile.write(str(label) + "\n")
        index += 1

    print("Old label counts: ")
    for i in range(numLabels):
        print ("\tLabel ", i, ": ", oldLabelCount[i])
    print("New label counts: ")
    for i in range(numLabels):
        print ("\tLabel ", i, ": ", newLabelCount[i])


if __name__ == "__main__":
    main()
