%Author: Gentry Atkinson
%Date: 22 Apr 2020
%Organization: Texas State University

features = readmatrix("motionsense_normalized_features.csv");
mislabels = readmatrix("motionsense_mislabels.csv");
labels = readmatrix("motionsense_labels.csv");
alteredindexes = readmatrix("altered_indexes.csv");
sprimeprime = readmatrix("motionsense_sprimeprime.csv");

minPts = 10;
epsilon = 0.01;
k = 6;
numLabels = 6;

[clusters, corePoints] = dbscan(features,epsilon,minPts,'Distance','cosine');

fprintf("max cluster: %d\tmin cluster: %d\n", max(clusters), min(clusters));

knn_clasifiers = {};
for i = 1:max(clusters)
    point_set = features(clusters==i, :);
    label_set = mislabels(clusters==i);
    knn_clasifiers(i) = fitcknn(point_set, label_set, 'Distance', 'cosine', 'NumNeighbors', k);
end

