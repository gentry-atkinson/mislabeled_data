%Author: Gentry Atkinson
%Date: 24 March 2020
%Organization: Texas State University

function [prec] = k_nearest_corepoints(epsilon, minPts, k)

    %load files
    syntheticfeatures = readmatrix("synthetic_features.csv");
    syntheticmislabels = readmatrix("synthetic_mislabels.csv");
    alteredindexes = readmatrix("altered_indexes.csv");
    sprimeprime = readmatrix("synthetic_sprimeprime_normalized.csv");

    %defined values for one experiment
    %epsilon = 0.1;
    %minPts = 100;
    %k = 3;

    %cluster sprimeprime to find core points
    [c, iscore] = dbscan(sprimeprime, epsilon, minPts, 'Distance', 'cosine');

    %convert the core point indexes into lists of core points and labels
    corepts = sprimeprime(iscore==1, :);
    corelabels = syntheticmislabels(iscore==1, :);

    %"train" the knn model on the sprimeprime set and produce set of closest
    %labels
    knn_model = fitcknn(corepts, corelabels, 'Distance', 'cosine', 'NumNeighbors', k);
    closest = predict(knn_model, sprimeprime);

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

    prec = (confusion_matrix(2,2))/(confusion_matrix(1,2)+confusion_matrix(2,2));

end


