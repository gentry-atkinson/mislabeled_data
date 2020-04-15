%Author: Gentry Atkinson
%Date: 09 April 2020
%Organization: Texas State University

msfeatures = readmatrix("motionsense_normalized_features.csv");
msmislabels = readmatrix("motionsense_mislabels.csv");
alteredindexes = readmatrix("altered_indexes.csv");
mssprimeprime = readmatrix("motionsense_sprimeprime.csv");

maxPrec = 0;
maxK = 0;
maxMinPts = 0;
maxEpsilon = 0;

for k = 1:7
   for minPts = 10:5:500
       for epsilon = 0.05:0.05:1
           thisPrec = k_nearest_corepoints(epsilon, minPts, k, mssprimeprime, msmislabels, alteredindexes);
           fprintf('k: %d, minPts: %d, ep: %f, prec: %f\n', k, minPts, epsilon, thisPrec);
           if thisPrec > maxPrec
               maxPrec = thisPrec;
               maxK = k;
               maxMinPts = minPts;
               maxEpsilon = epsilon;
           end
       end
   end
end

fprintf('-----------------------------------------------\n');
fprintf('Best Epsilon: %f', maxEpsilon);
fprintf('Best MinPts: %d', maxMinPts);
fprintf('Best K: %d', maxK);
fprintf('Best Precision: %f', maxPrec);