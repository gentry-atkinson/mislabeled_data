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

%assign a cluster for every point in the feautre set
[clusters, corePoints] = dbscan(features,epsilon,minPts,'Distance','cosine');

fprintf("max cluster: %d\tmin cluster: %d\n", max(clusters), min(clusters));

%"train" a classifier for each cluster, except for noise
knn_classifiers = cell(max(clusters), 1);
for i = 1:max(clusters)
    point_set = features(clusters==i, :);
    label_set = mislabels(clusters==i);
    knn_classifiers{i} = fitcknn(point_set, label_set, 'Distance', 'cosine', 'NumNeighbors', k);
end

%"train" a classifer on the full feature set
traditional_knn_classifier = fitcknn(features, mislabels, 'Distance', 'cosine', 'NumNeighbors', k);

%allocate space for all the crud
predicted_mislabeled = zeros(size(features, 1), 1);
traditional_predicted_mislabeled = zeros(size(features, 1), 1);
observed_mislabeled = zeros(size(features, 1), 1);
matrix = zeros(2,2);
trad_matrix = zeros(2,2);

%walk through feature space and find the bad predictions from KNN
for i = 1:size(features,1)
   this_cluster = clusters(i);
   if this_cluster ~= -1
    predicted_label = predict(knn_classifiers{this_cluster}, features(i, :));
   else
    predicted_label = predict(traditional_knn_classifier, features(i, :));
   end
   if predicted_label ~= mislabels(i)
    predicted_mislabeled(i) = 1;
   end
   
   predicted_label = predict(traditional_knn_classifier, features(i, :));
   if predicted_label ~= mislabels(i)
    traditional_predicted_mislabeled(i) = 1;
   end
end

for i = 1:size(alteredindexes,1)
    observed_mislabeled(alteredindexes(i)+1) = 1;
end

matrix = confusionmat(observed_mislabeled, predicted_mislabeled);
trad_matrix = confusionmat(observed_mislabeled, traditional_predicted_mislabeled);
fprintf("Precision of new method: %f\n", matrix(2,2)/(matrix(1,2)+matrix(2,2)));
fprintf("Precision of old method: %f\n", trad_matrix(2,2)/(trad_matrix(1,2)+trad_matrix(2,2)));


