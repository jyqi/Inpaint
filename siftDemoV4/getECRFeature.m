

function [featureA] = getECRFeature(imageFileNamePrefix, start_frame, end_frame, frame_interval)

featureA = [];

fileName = strcat(imageFileNamePrefix,num2str(start_frame),'.png');
im = imread(fileName);
imd = rgb2gray(im);
bw1 = edge(imd, 'sobel'); 

for i = start_frame : frame_interval : end_frame
	fileName = strcat(imageFileNamePrefix,num2str(i),'.png');
	im = imread(fileName);
	imd = rgb2gray(im);
	bw2 = edge(imd, 'sobel'); 
	ibw2 = 1-bw2; 

    ibw1 = 1-bw1; 
    

    s1 = size(find(bw1),1);
    s2 = size(find(bw1),1);

    se = strel('square',3);
    dbw1 = imdilate(bw1, se);
    dbw2 = imdilate(bw2, se);

    imIn = dbw1 & ibw2;
    imOut = dbw2 & ibw1;
    
    ECRIn = size(find(imIn),1)/s2;
    ECROut = size(find(imOut),1)/s1;
    
    ECR = max(ECRIn, ECROut);
    featureA = [featureA; i ECR];
    bw1 = bw2;
end

return;