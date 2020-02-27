%Author: Gentry Atkinson
%Date: 26 Feb 2020
%Organization: Texas State University
%
%C -> the results of clustering SPrimePrime


number_of_clusters = max(C) + 1;
C_counts = zeros(number_of_clusters);

for i = 1:size(C)
   if C(i) == -1
       C_counts(0) = C_counts(0)+1;
   else
       C_counts(C(i)) = C_counts(C(i))+1;
   end
end
