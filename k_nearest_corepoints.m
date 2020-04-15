%Author: Gentry Atkinson
%Date: 24 March 2020
%Organization: Texas State University

function [matrix] = k_nearest_corepoints(epsilon, minPts, k, sprimeprime, syntheticmislabels, alteredindexes)

    %load files: no point in doing this in a function call. Pushed out
    %syntheticfeatures = readmatrix("synthetic_features.csv");
    %syntheticmislabels = readmatrix("synthetic_mislabels.csv");
    %alteredindexes = readmatrix("altered_indexes.csv");
    %sprimeprime = readmatrix("synthetic_sprimeprime_normalized.csv");

    %defined values for one experiment
    %epsilon = 0.1;
    %minPts = 100;
    %k = 3;

    %cluster sprimeprime to find core points
    [c, iscore] = dbscan(sprimeprime, epsilon, minPts, 'Distance', 'cosine');

    %convert the core point indexes into lists of core points and labels
    corepts = sprimeprime(iscore==1, :);
    corelabels = syntheticmislabels(iscore==1, :);
    
    if size(corepts, 1) == 0
        matrix = zeros(2,2);
        return;
    end

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

    matrix = confusionmat(real_mislabeled, predicted_mislabeled);
    %visual = tsne(sprimeprime, 'Distance', 'cosine');
    %figure('Name', "Clusters");
    %gscatter(visual(:,1), visual(:,2), c);
    %figure('Name', "Core Points");
    %gscatter(visual(:,1), visual(:,2), iscore);
    %figure('Name', "Predicted Mislabeled Points");
    %gscatter(visual(:,1), visual(:,2), predicted_mislabeled);
    %figure('Name', "Actual Mislabeled Points");
    %gscatter(visual(:,1), visual(:,2), real_mislabeled);

    prec = (matrix(2,2))/(matrix(1,2)+matrix(2,2));

end


