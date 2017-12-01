% This function is used to read frame image of a video and calculate the
% distance function based on intensity histogram. It take the frame
% filename's prefix and the total framenumber as input parameter.

function [featureA] = getHistogramFeature(imageFileNamePrefix, start_frame, end_frame, frame_interval)

featureA = [];
%   read first frame
fileName = strcat(imageFileNamePrefix,num2str(start_frame),'.png');
im = imread(fileName);
imd = rgb2gray(im);
[n1, xnum1] = imhist(imd);

for i = start_frame + 1 : frame_interval : end_frame
	fileName = strcat(imageFileNamePrefix,num2str(i),'.png');
	im = imread(fileName);
	imd = rgb2gray(im);
	[n2, xnum2] = imhist(imd);
    var = (n2-n1).*(n2-n1);
    var = sum(var);
    d = sqrt(var);
    featureA = [featureA; i d];
    n1 = n2;
end

return;
