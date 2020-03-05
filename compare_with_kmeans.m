%Author: Gentry Atkinson
%Date: 26 Feb 2020
%Organization: Texas State University
%
%Inputs: syntheticfeatures, syntheticsprimeprime_normal, alterindexes, and numLabels

tolerance = 0.10;

feature_length = size(syntheticfeatures(1,:), 2);
number_samples = size(syntheticfeatures, 1);

feat_norm = normalize(syntheticfeatures);
%spp_norm = normalize(syntheticsprimeprime);

distance = zeros(number_samples, 2);
mislabels_observed = zeros(number_samples, 1);
mislabels_predicted = zeros(number_samples, 1);
feat_norm_padded = zeros(number_samples, feature_length+numLabels);

%pad the feature array with zeros for lables
for i = 1:number_samples
    for j = 1:feature_length
        feat_norm_padded(i, j) = feat_norm(i,j);
    end
    for k = 1:numLabels
       feat_norm_padded(i, feature_length+k) = 0;
    end
end

%compute cluster with k=numLabels
[C, centers, sums, dis_to_all_clusters] = kmeans(feat_norm_padded, numLabels, 'Distance', 'cosine');

%flag values: 0=correct, 1=mislabeled

%find who's distance has moved the most
for i = 1:number_samples
    %dis_to_my_cluster = 1-getCosineSimilarity(syntheticsprimeprimenormalized(i,:), centers(C(i),:));
    %dis_to_my_cluster = sqrt(sum((syntheticsprimeprimenormalized(i,:) - centers(C(i),:)) .^ 2));
    
    dis_to_my_cluster = 1-getCosineSimilarity(syntheticsprimeprimenormalized(i,:), centers(C(i),:));
    %if abs(dis_to_my_cluster-dis_to_all_clusters(i,C(i))) > tolerance*(abs(dis_to_all_clusters(1)-dis_to_all_clusters(2)))
    %   mislabels_predicted(i) = 1;
    %end
    
    distance(i, 1) = abs(dis_to_my_cluster - dis_to_all_clusters(C(i)));
    distance(i,2) = i;
        
end

distance = sortrows(distance,1, 'descend');

for i = 1:(tolerance * number_samples)
    mislabels_predicted(distance(i,2)) = 1;
end

%use alterindexes to set flags in mislabels_observed
for i = 1:size(alterindexes, 1)
   mislabels_observed(alterindexes(i)) = 1; 
end


confusion_matrix = confusionmat(mislabels_observed, mislabels_predicted);
