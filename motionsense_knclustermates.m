%Author: Gentry Atkinson
%Date: 22 Apr 2020
%Organization: Texas State University

features = readmatrix("motionsense_normalized_features.csv");
mislabels = readmatrix("motionsense_mislabels.csv");
labels = readmatrix("motionsense_labels.csv");
alteredindexes = readmatrix("altered_indexes.csv");
sprimeprime = readmatrix("motionsense_sprimeprime.csv");

minPts = 80;
epsilon = 0.95;
k = 6;

[clusters, corePoints] = dbscan(features,epsilon,minPts,'Distance','cosine');