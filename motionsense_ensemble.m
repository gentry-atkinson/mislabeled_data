%Author: Gentry Atkinson
%Date: 01 May 2020
%Organization: Texas State University

features = readmatrix("motionsense_normalized_features.csv");
mislabels = readmatrix("motionsense_mislabels.csv");
labels = readmatrix("motionsense_labels.csv");
alteredindexes = readmatrix("altered_indexes.csv");

numClassifiers = 3;

predicted_mislabeled = zeros(size(mislabels, 1), 1);
actual_mislabeled = zeros(size(mislabels, 1), 1);
ensemble_classifiers = cell(numClassifiers);

ensemble_classifiers{1} = fitctree(features, mislabels);
ensemble_classifiers{2} = fitcnb(features, mislabels);
ensemble_classifiers{3} = fitcecoc(features, mislabels);

pl = zeros(3, 1);

for i = 1:size(features,1)
    pl(1) = predict(ensemble_classifiers{1}, features(i, :));
    pl(2) = predict(ensemble_classifiers{2}, features(i, :));
    pl(3) = predict(ensemble_classifiers{3}, features(i, :));
    
    if pl(1) == pl(2) && pl(1) ~= mislabels(i)
       predicted_mislabeled(i) = 1;
    elseif pl(1) == pl(3) && pl(1) ~= mislabels(i)
       predicted_mislabeled(i) = 1;
    elseif pl(2) == pl(3) && pl(2) ~= mislabels(i)
       predicted_mislabeled(i) = 1;
    end
end

for i = 1:size(alteredindexes, 1)
    actual_mislabeled(alteredindexes(i)+1) = 1;
end

matrix = confusionmat(actual_mislabeled, predicted_mislabeled);
fprintf("Number of predicted mislabeled points: %d\n", sum(predicted_mislabeled));
fprintf("Number of actual mislabeled points: %d\n", sum(actual_mislabeled));
fprintf("Precision of ensemble: %f\n", matrix(2,2)/(matrix(1,2)+matrix(2,2)));
