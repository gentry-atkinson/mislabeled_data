%Author: Gentry Atkinson
%Date: 26 Feb 2020
%Organization: Texas State University
%
%Inputs: syntheticfeatures, syntheticsprimeprime, alterindexes, and numLabels

feature_length = size(syntheticfeatures(1,:), 2);
number_samples = size(syntheticfeatures, 1);

distance = zeros(numLabels, 1);
mislabels_observed = zeros(number_samples, 1);
mislabels_predicted = zeros(number_samples, 1);
syntheticfeatures_padded = zeros(number_samples, feature_length+numLabels);

%pad the feature array with zeros for lables
for i = 1:number_samples
    for j = 1:feature_length
        syntheticfeatures_padded(i, j) = syntheticfeatures(i,j);
    end
    for k = 1:numLabels
       syntheticfeatures_padded(i, feature_length+k) = 0;
    end
end

%compute cluster with k=numLabels
[C, centers] = kmeans(syntheticfeatures_padded, numLabels, 'Distance', 'cosine');

%find points in sprimeprime which are closer to the wrong cluster now
for i = 1:number_samples
    for j = 1:numLabels
        distance(j) = getCosineSimilarity(syntheticsprimeprime(i,:), centers(j,:));
    end
    dis_to_my_cluster = getCosineSimilarity(syntheticsprimeprime(i,:), centers(C(i),:));
    if min(distance) ~= dis_to_my_cluster
       mislabels_predicted = 1; 
    end
        
end
