function [ TN ] = Color( sample)
% We take the RGB values of the Target and Noise to arrange them into a 1x6
% vectors
TN=[sample(1,1,1) sample(1,1,2) sample(1,1,3) sample(1,size(sample,2),1) sample(1,size(sample,2),2) sample(1,size(sample,2),3)];
end

