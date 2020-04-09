%Author: Gentry Atkinson
%Date: 25 March 2020
%Organization: Texas State University

files = ["sub_1.csv", "sub_2.csv", "sub_3.csv", "sub_4.csv", "sub_5.csv", "sub_6.csv",...
    "sub_7.csv", "sub_8.csv", "sub_9.csv", "sub_10.csv", "sub_11.csv", "sub_12.csv",...
    "sub_13.csv", "sub_14.csv", "sub_15.csv", "sub_16.csv", "sub_17.csv", "sub_18.csv",...
    "sub_19.csv", "sub_20.csv", "sub_21.csv", "sub_22.csv", "sub_23.csv", "sub_24.csv"];

dirs = ["dws_1", "dws_2", "dws_11", "jog_9", "jog_16", "sit_5", "sit_13", "std_6",...
    "std_14", "ups_3", "ups_4", "ups_12", "wlk_7", "wlk_8", "wlk_15"];

for i = 1:15
    for j = 1:24
        fprintf("%s\n", strcat(dirs(i),"/", files(j)));
        sample = readmatrix(strcat("motionsense-dataset/A_DeviceMotion_data/",dirs(i),"/", files(j)));
    end
end