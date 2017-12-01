% This function takes the avi filename as input and detect hard cuts.

function []=shot_detection(start_frame, end_frame, frame_interval)
imageFileNamePrefix = '../vd_';
% calculate fetures values based on histogram dissimilarity
featureHist = getHistogramFeature(imageFileNamePrefix, start_frame, end_frame, frame_interval);

% calculate fetures values based on ECR
featureECR = getECRFeature(imageFileNamePrefix, noOfFrameImages - 1);

% detect hard cuts use adaptive threshold
cutHist = cutDetect(featureHist);
cutECR = cutDetect(featureECR);
[M N] = size(cutHist);
for i = 1:M
    imageFileNamePrefix = 'cutHist/cut_';
    fileName = strcat(imageFileNamePrefix,num2str(cutHist(i,1)),'.bmp');
    img = read(movieObj, cutHist(i,1));
    imwrite(img,fileName,'bmp');
end
[M N] = size(cutECR);
for i = 1:M
    imageFileNamePrefix = 'cutECR/cut_';
    fileName = strcat(imageFileNamePrefix,num2str(cutECR(i,1)),'.bmp');
    img = read(movieObj, cutECR(i,1));
    imwrite(img,fileName,'bmp');
end
% plot the result
figure; plot(featureHist(:,1),featureHist(:,2)); 
xlabel('Frame Number'); ylabel('Histogram Feature Value'); 
hold; plot(cutHist(:,1),cutHist(:,2),'rx'); legend('f(n)', 'cut');

figure; plot(featureECR(:,1),featureECR(:,2)); 
xlabel('Frame Number'); ylabel('ECR Feature Value'); 
hold; plot(cutECR(:,1),cutECR(:,2),'rx'); legend('f(n)', 'cut');

return;
