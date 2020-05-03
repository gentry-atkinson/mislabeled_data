%Author: Gentry Atkinson
%Date: 01 May 2020
%Organization: Texas State University

features = readmatrix("motionsense_normalized_features.csv");
mislabels = readmatrix("motionsense_mislabels.csv");
labels = readmatrix("motionsense_labels.csv");
alteredindexes = readmatrix("altered_indexes.csv");
%sprimeprime = readmatrix("motionsense_sprimeprime.csv");

numLabels = 6;
k = 3;

oneHot_mislabels = zeros(numLabels, size(mislabels, 1));
predicted_mislabeled = zeros(size(mislabels, 1), 1);
actual_mislabeled = zeros(size(mislabels, 1), 1);
km_knn_classifiers = cell(numLabels);

for i = 1:numLabels
   for j = 1:size(mislabels,1)
      if mislabels(j) == i-1
          oneHot_mislabels(i,j) = 0;
      else
          oneHot_mislabels(i,j) = 1;
      end
   end
end

for i = 1:numLabels
    label_set = oneHot_mislabels(i, :);
    knn_classifiers{i} = fitcknn(features, label_set, 'Distance', 'cosine', 'NumNeighbors', k);
end

for i = 1:numLabels
   for j = 1:size(mislabels,1)
        predictLabel = predict(knn_classifiers{i}, features(j, :));
        if predictLabel ~= oneHot_mislabels(i, j)
            predicted_mislabeled(j) = 1;
        end
   end
end

fprintf("Number of predicted mislabeled points: %d\n", sum(predicted_mislabeled(:)==1));

for i = 1:size(alteredindexes,1)
   actual_mislabeled(i) = 1; 
end
fprintf("Number of actual mislabeled points: %d\n", sum(actual_mislabeled(:)==1));

matrix = confusionmat(actual_mislabeled, predicted_mislabeled);

