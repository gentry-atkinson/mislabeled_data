%Author: Gentry Atkinson
%Date: 25 March 2020
%Organization: Texas State University

%%%%%%%%%%%%%%%%%%%%%%%%%   Labels   %%%%%%%%%%%%%%
% 1-> downstairs
% 2-> jog
% 3-> sit
% 4-> stand
% 5-> upstairs
% 6-> walk


addpath("./FeatureExtraction/");

files = ["sub_1.csv", "sub_2.csv", "sub_3.csv", "sub_4.csv", "sub_5.csv", "sub_6.csv",...
    "sub_7.csv", "sub_8.csv", "sub_9.csv", "sub_10.csv", "sub_11.csv", "sub_12.csv",...
    "sub_13.csv", "sub_14.csv", "sub_15.csv", "sub_16.csv", "sub_17.csv", "sub_18.csv",...
    "sub_19.csv", "sub_20.csv", "sub_21.csv", "sub_22.csv", "sub_23.csv", "sub_24.csv"];

dirs = ["dws_1", "dws_2", "dws_11", "jog_9", "jog_16", "sit_5", "sit_13", "std_6",...
    "std_14", "ups_3", "ups_4", "ups_12", "wlk_7", "wlk_8", "wlk_15"];

ms_features = [];
sample_accel_magnitude = [];
ms_labels = zeros(360,1);
ms_features_norm = [];

for i = 1:15
    for j = 1:24
        fprintf("%s\n", strcat(dirs(i),"/", files(j)));
        sample = readmatrix(strcat("motionsense-dataset/A_DeviceMotion_data/",dirs(i),"/", files(j)));
        sample_accel = sample(:, 11:13);
        sample_accel_magnitude = zeros(size(sample_accel, 1), 1);
        for k = 1:size(sample_accel, 1)
            sample_accel_magnitude(k) = sqrt(sample_accel(k, 1)^2 + sample_accel(k,2)^2 + sample_accel(k,3)^2); 
        end
        ms_features = [ms_features; FeatureExtraction(sample_accel_magnitude, 50)];
        if strncmp("dws", dirs(i), 3) > 0
            ms_labels(24*(i-1)+j) = 0;
        elseif strncmp("jog", dirs(i), 3) > 0
            ms_labels(24*(i-1)+j) = 1;
        elseif strncmp("sit", dirs(i), 3) > 0
            ms_labels(24*(i-1)+j) = 2;
        elseif strncmp("std", dirs(i), 3) > 0
            ms_labels(24*(i-1)+j) = 3;
        elseif strncmp("ups", dirs(i), 3) > 0
            ms_labels(24*(i-1)+j) = 4;
        elseif strncmp("wlk", dirs(i), 3) > 0
            ms_labels(24*(i-1)+j) = 5;
        else
            ms_labels(i) = 7;
        end
    end
end

ms_features_norm = ms_features./max(ms_features(:));

writematrix(ms_features, "motionsense_features.csv");
writematrix(ms_labels, "motionsense_labels.csv");
writematrix(ms_features_norm, "motionsense_normalized_features.csv");