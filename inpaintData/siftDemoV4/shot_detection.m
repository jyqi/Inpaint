% This function takes the avi filename as input and detect hard cuts.

function []=shot_detection(seq_num, start_frame, end_frame, frame_interval)
movieObj = VideoReader(['../video_15/vd_15.mp4']);
imageFileNamePrefix = ['../video_' num2str(seq_num) '/vd_' num2str(seq_num) '_'];
% calculate fetures values based on histogram dissimilarity
featureHist = getHistogramFeature_All(imageFileNamePrefix, start_frame, end_frame, frame_interval);

% calculate fetures values based on ECR
%featureECR = getECRFeature(imageFileNamePrefix, start_frame, end_frame, frame_interval);

% detect hard cuts use adaptive threshold
cutHist = cutDetect_All(featureHist);
%cutECR = cutDetect(featureECR);
[M N] = size(cutHist);
for i = 1:M
    imageFileNamePrefix = ['../video_' num2str(seq_num) '/cutHist/cut_'];
    fileName = strcat(imageFileNamePrefix,num2str(cutHist(i,1)),'.png');
    img = read(movieObj, cutHist(i,1));
    imwrite(img,fileName,'png');
end
% [M N] = size(cutECR);
% for i = 1:M
%     imageFileNamePrefix = ['../video_' num2str(seq_num) '/cutECR/cut_'];
%     fileName = strcat(imageFileNamePrefix,num2str(cutECR(i,1)),'.png');
%     img = read(movieObj, cutECR(i,1));
%     imwrite(img,fileName,'png');
% end
% plot the result
figure; plot(featureHist(:,1),featureHist(:,2)); 
xlabel('Frame Number'); ylabel('Histogram Feature Value'); 
hold; plot(cutHist(:,1),cutHist(:,2),'rx'); legend('f(n)', 'cut');

% figure; plot(featureECR(:,1),featureECR(:,2)); 
% xlabel('Frame Number'); ylabel('ECR Feature Value'); 
% hold; plot(cutECR(:,1),cutECR(:,2),'rx'); legend('f(n)', 'cut');

return;
