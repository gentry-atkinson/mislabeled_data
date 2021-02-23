for i = 1:10000
for j = 1:21
sprimeprime_normal(i,j)=examplefeatures_normal(i,j);
end
if syntheticmislabels(i) == 0
sprimeprime_normal(i, 22) = 1;
sprimeprime_normal(i, 23) = 0;
else
sprimeprime_normal(i, 22) = 0;
sprimeprime_normal(i, 23) = 1;
end
end