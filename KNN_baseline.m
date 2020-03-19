%Author: Gentry Atkinson
%Date: 26 Feb 2020
%Organization: Texas State University

%load files
syntheticfeatures = readmatrix("synthetic_features.csv");
syntheticmislabels = readmatrix("synthetic_mislabels.csv");
alteredindexes = readmatrix("altered_indexes.csv");
sprimeprime = readmatrix("synthetic_sprimeprime_normalized.csv");

%develop set of closest neighbors
model = fitcknn(syntheticfeatures, syntheticmislabels, 'Distance', 'cosine', 'NumNeighbors', 7);
closest = predict(model, syntheticfeatures);

%set flags in predicted mislabeled set
%a value of 1 marks a mislabeled point
predicted_mislabeled = zeros(size(closest, 1), 1);
for i = 1:size(closest, 1)
    if closest(i) ~= syntheticmislabels(i)
        predicted_mislabeled(i) = 1;
    end
end

%build flags for actual mislabels
%a value of 1 marks a mislabeled point
real_mislabeled = zeros(size(syntheticmislabels, 1), 1);
for i = 1:size(alteredindexes, 1)
       real_mislabeled(alteredindexes(i)+1) = 1;
end

confusion_matrix = confusionmat(real_mislabeled, predicted_mislabeled);
visual = tsne(sprimeprime);
figure('Name', "Actual mislabeled points");
gscatter(visual(:,1), visual(:,2), real_mislabeled);
figure('Name', "Predicted mislabeled points");
gscatter(visual(:,1), visual(:,2), predicted_mislabeled);
