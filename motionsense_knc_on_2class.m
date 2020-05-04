%Author: Gentry Atkinson
%Date: 01 May 2020
%Organization: Texas State University

features = readmatrix("motionsense_normalized_features.csv");
mislabels = readmatrix("motionsense_mislabels.csv");
labels = readmatrix("motionsense_labels.csv");
alteredindexes = readmatrix("altered_indexes.csv");

numLabels = 6;
k = 3;
epsilon = 0.015;
minPts = 10;

oneHot_mislabels = zeros(numLabels, size(mislabels, 1));
predicted_mislabeled = zeros(size(mislabels, 1), 1);
actual_mislabeled = zeros(size(mislabels, 1), 1);
knn_classifiers = cell(numLabels);
knc_classifiers = cell(numLabels);

[c, iscore] = dbscan(features, epsilon, minPts, 'Distance', 'cosine');
fprintf("%d clusters detected\n", max(c));
corepts = features(iscore==1, :);
coremislabels = mislabels(iscore==1, :);

oneHot_coremislabels = zeros(numLabels, size(coremislabels, 1));
predicted_coremislabeled = zeros(size(mislabels, 1), 1);

for i = 1:numLabels
   for j = 1:size(mislabels,1)
      if mislabels(j) == i-1
          oneHot_mislabels(i,j) = 0;
      else
          oneHot_mislabels(i,j) = 1;
      end
   end
   for j = 1:size(coremislabels,1)
      if coremislabels(j) == i-1
          oneHot_coremislabels(i,j) = 0;
      else
          oneHot_coremislabels(i,j) = 1;
      end
   end
end

for i = 1:numLabels
    label_set = oneHot_mislabels(i, :);
    corelabel_set = oneHot_coremislabels(i, :);
    knn_classifiers{i} = fitcknn(features, label_set, 'Distance', 'cosine', 'NumNeighbors', k);
    knc_classifiers{i} = fitcknn(corepts, corelabel_set, 'Distance', 'cosine', 'NumNeighbors', k);
end

for i = 1:numLabels
   for j = 1:size(mislabels,1)
        predictLabel = predict(knn_classifiers{i}, features(j, :));
        if predictLabel ~= oneHot_mislabels(i, j)
            predicted_mislabeled(j) = 1;
        end
   end
   for j = 1:size(coremislabels,1)
        predictLabel = predict(knc_classifiers{i}, features(j, :));
        if predictLabel ~= oneHot_mislabels(i, j)
            predicted_coremislabeled(j) = 1;
        end
   end
end

fprintf("Number of knn predicted mislabeled points: %d\n", sum(predicted_mislabeled(:)==1));
fprintf("Number of knc predicted mislabeled points: %d\n", sum(predicted_coremislabeled(:)==1));

for i = 1:size(alteredindexes,1)
   actual_mislabeled(alteredindexes(i)+1) = 1; 
end
fprintf("Number of actual mislabeled points: %d\n", sum(actual_mislabeled(:)==1));

knn_matrix = confusionmat(actual_mislabeled, predicted_mislabeled);
knc_matrix = confusionmat(actual_mislabeled, predicted_coremislabeled);

