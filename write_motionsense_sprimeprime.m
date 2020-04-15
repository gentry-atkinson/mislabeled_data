ms_features = readmatrix("motionsense_normalized_features.csv");
ms_mislabels = readmatrix("motionsense_mislabels.csv");

ms_sprimeprime = zeros(360,27);

for i = 1:size(ms_sprimeprime, 1)
    ms_sprimeprime(i, 1:21) = ms_features(i, 1:21);
    ms_sprimeprime(i, 22+ms_mislabels(i)) = 1;
end

writematrix(ms_sprimeprime, "motionsense_sprimeprime.csv");


