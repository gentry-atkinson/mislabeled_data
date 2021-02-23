%Author: Gentry Atkinson
%Date: 26 Feb 2020
%Organization: Texas State University
%
%C -> the results of clustering SPrimePrime

syntheticfeatures = readmatrix("synthetic_features.csv");
syntheticmislabels = readmatrix("synthetic_mislabels.csv");
alteredindexes = readmatrix("altered_indexes.csv");
sprimeprime = readmatrix("synthetic_sprimeprime_normalized.csv");

epsilon = 0.1;
minPts = 20;

C = dbscan(sprimeprime, epsilon, minPts, 'Distance', 'cosine');
%disp("Clustering complete");


number_of_clusters = max(C);
disp(number_of_clusters);
disp(max(size(C)));
C_counts = zeros(number_of_clusters,1);

for i = 1:max(size(C))
   if C(i) ~= -1
       C_counts(C(i)) = C_counts(C(i))+1;
   end
end

%1 is being used as a flag for a mislabeled cluster
mislabeled_clusters = zeros(number_of_clusters, 1);
for i = 1:number_of_clusters
   if C_counts(i) < minPts
       mislabeled_clusters(i) = 1;
   end
end

mislabeled_indexes = [];
for i = 1:max(size(C))
   if C(i) == -1
       mislabeled_indexes = [mislabeled_indexes; i];
   elseif mislabeled_clusters(C(i)) == 1
       mislabeled_indexes = [mislabeled_indexes; i];
   end
end

%1 is used to flag a mislabeled data point
real_mislabeled_list = zeros(size(C, 1), 1);
predicted_mislabeled_list = zeros(size(C, 1), 1);


for i = 1:size(alteredindexes, 1)
      real_mislabeled_list(alteredindexes(i)+1) = 1;
end
for i = 1:size(mislabeled_indexes, 1)
      predicted_mislabeled_list(mislabeled_indexes(i)) = 1;
end

confusion_matrix = confusionmat(real_mislabeled_list, predicted_mislabeled_list);