%Author: Gentry Atkinson
%Date: 01 May 2020
%Organization: Texas State University

features = readmatrix("motionsense_normalized_features.csv");
mislabels = readmatrix("motionsense_mislabels.csv");
labels = readmatrix("motionsense_labels.csv");
alteredindexes = readmatrix("altered_indexes.csv");
sprimeprime = readmatrix("motionsense_sprimeprime.csv");

num_classes = 6;

oneHot_mislabels = zeros(num_classes, size(mislabels, 1));

for i = 1:num_classes
   for j = 1:size(mislabels,1)
      if mislabels(j) == i-1
          oneHot_mislabels(i,j) = 0;
      else
          oneHot_mislabels(i,j) = 1;
      end
   end
end
