
function [featureA] = getHistogramFeature_All(imageFileNamePrefix, start_frame, end_frame, frame_interval)

frame_num = (end_frame - start_frame + 1) / frame_interval;
featureA = zeros(frame_num, frame_num);
%   read first frame

for i = start_frame : frame_interval : end_frame
    fileName = strcat(imageFileNamePrefix,num2str(i),'.png');
    im = imread(fileName);
    imd = rgb2gray(im);
    [n1, xnum1] = imhist(imd);
    for j = start_frame : frame_interval : end_frame
        fileName = strcat(imageFileNamePrefix,num2str(j),'.png');
        im = imread(fileName);
        imd = rgb2gray(im);
        [n2, xnum2] = imhist(imd);
        var = (n2-n1).*(n2-n1);
        var = sum(var);
        d = sqrt(var);
        featureA(i, j) = d;
        %featureA = [featureA; i d];
        %n1 = n2;
    end
end

return;
