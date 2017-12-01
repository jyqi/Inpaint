clc;clear;
tic;
seq_num         = 16;
frame_interval  = 1;
start_frame     = 6;
end_frame       = 106;
    
% % 从视频中提取生成image 序列
% firstObj    = VideoReader(['../video_' num2str(seq_num) '/vd_' num2str(seq_num) '.mov']);
% frames_num  = firstObj.NumberOfFrames;
% for i = start_frame:frame_interval:end_frame
%     if i < 10
%         img_name = ['/vd_' num2str(seq_num) '_00' num2str(i)];
%     else if i < 100
%             img_name = ['/vd_' num2str(seq_num) '_0' num2str(i)];
%         else
%             img_name = ['/vd_' num2str(seq_num) '_' num2str(i)];
%         end
%     end
%     img = read(firstObj, i);
%     img = imresize(img(14:707, 1:size(img, 2)-200, :), 0.5);
%     imwrite(img, ['../video_' num2str(seq_num) img_name '.png']);
% end
% 
% % 加入inpainting前景
% for i = start_frame:frame_interval:end_frame
%     if i < 10
%         img_name = ['/vd_' num2str(seq_num) '_00' num2str(i)];
%     else if i < 100
%             img_name = ['/vd_' num2str(seq_num) '_0' num2str(i)];
%         else
%             img_name = ['/vd_' num2str(seq_num) '_' num2str(i)];
%         end
%     end
%     img = imread(['../video_' num2str(seq_num) '/rgb' img_name '.png']);
% 
%     %img(71:110,171:210, :) = 0;
% 
%     imwrite(img, ['../video_' num2str(seq_num) '/' img_name '.png']);
%     imwrite(img(:,:,1), ['../video_' num2str(seq_num) '/ch_1' img_name '.bmp']);
%     imwrite(img(:,:,2), ['../video_' num2str(seq_num) '/ch_2' img_name '.bmp']);
%     imwrite(img(:,:,3), ['../video_' num2str(seq_num) '/ch_3' img_name '.bmp']);
% end

% % 生成caption mask
% mask   = zeros(347, 540);
% mask(71:110,171:210) = 255;
% imwrite(mask, ['../video_' num2str(seq_num) '/others/mask.bmp']);
% 
% % 手动指定特征点，并保存
% for i = start_frame:frame_interval:end_frame
%     if i < 10
%         img_name = ['../video_' num2str(seq_num) '/vd_' num2str(seq_num) '_00' num2str(i) '.bmp'];
%     else if i < 100
%             img_name = ['../video_' num2str(seq_num) '/vd_' num2str(seq_num) '_0' num2str(i) '.bmp'];
%         else
%             img_name = ['../video_' num2str(seq_num) '/vd_' num2str(seq_num) '_' num2str(i) '.bmp'];
%         end
%     end
%     img = imread(img_name);
%     imshow(img);
%     disp(['frame: ' num2str(i)]);
%     points(:, 1) = input('input 1st point:');
%     points(:, 2) = input('input 2nd point:');
%     points(:, 3) = input('input 3rd point:');
%     save(['../video_' num2str(seq_num) '/vd_' num2str(seq_num) '_' num2str(i) '-points.mat'], 'points');
% end
% 
% % 合成rgb图像
% for i = start_frame:frame_interval:end_frame
%     if i < 10
%         img_name = ['/vd_' num2str(seq_num) '_output_00' num2str(i)];
%     else if i < 100
%             img_name = ['/vd_' num2str(seq_num) '_output_0' num2str(i)];
%         else
%             img_name = ['/vd_' num2str(seq_num) '_output_' num2str(i)];
%         end
%     end
%     img_r = imread(['../../results/video_' num2str(seq_num) '/ch_1/vd_' num2str(uint8((i -start_frame) /frame_interval) + 1) '.bmp']);
%     img_g = imread(['../../results/video_' num2str(seq_num) '/ch_2/vd_' num2str(uint8((i -start_frame) /frame_interval) + 1) '.bmp']);
%     img_b = imread(['../../results/video_' num2str(seq_num) '/ch_3/vd_' num2str(uint8((i -start_frame) /frame_interval) + 1) '.bmp']);
%     
%     img(:, :, 1) = img_r;
%     img(:, :, 2) = img_g;
%     img(:, :, 3) = img_b;
%     imwrite(img, ['../../results/video_' num2str(seq_num) img_name '.png']);
% end
% 
% % 5. corrected img into video
% frames_num = 20;
% mov(1:frames_num) = ...
%     struct('cdata', zeros(347, 540, 3, 'uint8'),...
%            'colormap', []);
% 
% for i = start_frame:frame_interval:end_frame
%     if i < 10
%         img_name = ['/vd_' num2str(seq_num) '_00' num2str(i)];
%     else if i < 100
%             img_name = ['/vd_' num2str(seq_num) '_0' num2str(i)];
%         else
%             img_name = ['/vd_' num2str(seq_num) '_' num2str(i)];
%         end
%     end
%     mov(i).cdata = imread(['../../inpaintData/video_' num2str(seq_num) '/rgb_input' img_name '.png']);
% end
% movie2avi(mov,['../../inpaintData/video_' num2str(seq_num) '/rgb_input' img_name '.avi'], 'fps', 20, 'compression', 'None');
% toc;
% 
% 自动寻找匹配特征点，并保存
addpath('siftDemoV4');
distRatio = 0.3;

img1 = ['../video_' num2str(seq_num) '/vd_' num2str(seq_num) '_' num2str(start_frame) '.png'];
[im1, des1, loc1] = sift(img1);

for i = start_frame+frame_interval:frame_interval:end_frame
    img2 = ['../video_' num2str(seq_num) '/vd_' num2str(seq_num) '_' num2str(i) '.png'];
    [im2, des2, loc2] = sift(img2);
    
    des2t = des2';                          % Precompute matrix transpose
    match = ones(1, size(des1,1));
    for j = 1 : size(des1,1)
        if match(j) ~= 0
            dotprods = des1(j,:) * des2t;        % Computes vector of dot products
            [vals,indx] = sort(acos(dotprods));  % Take inverse cosine and sort results
            
            % Check if nearest neighbor has angle less than distRatio times 2nd.
            if (vals(1) < distRatio * vals(2))
                match(j) = indx(1);
            else
                match(j) = 0;
            end
        end
    end
end

sift3   = zeros(1,3);
select_sift = [7 15 16];  %选择非0的特征点中三个序号
sift_m  = 1;            %三个特征点
nozero  = 1;            %非0的match点
for k = 1: size(des1,1)
    if (match(k) > 0 && sift_m <= 3)
        if nozero == select_sift(sift_m)
            points(:, sift_m) = [loc1(k,2); loc1(k,1)];
            sift3(sift_m) = k;
            sift_m = sift_m + 1;
        end
        nozero = nozero + 1;
    else if sift_m > 3
            break;
        end
    end
end
save(['../video_' num2str(seq_num) '/vd_' num2str(seq_num) '_' num2str(start_frame) '-points.mat'], 'points');
num = sum(match > 0);
fprintf('Found %d matches.\n', num);
disp('img 1:')
points

for i = start_frame+frame_interval:frame_interval:end_frame
    img2 = ['../video_' num2str(seq_num) '/vd_' num2str(seq_num) '_' num2str(i) '.bmp'];
    [im2, des2, loc2] = sift(img2);
    
    des2t = des2';                          % Precompute matrix transpose
    for j = 1 : 3
        dotprods = des1(sift3(j),:) * des2t;        % Computes vector of dot products
        [vals,indx] = sort(acos(dotprods));  % Take inverse cosine and sort results
        
        points(:, j) = [loc2(indx(1),2); loc2(indx(1),1)];
    end
disp(['img ' num2str(i) ':']);
points
save(['../video_' num2str(seq_num) '/vd_' num2str(seq_num) '_' num2str(i) '-points.mat'], 'points');
end
