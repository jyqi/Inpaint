clc;clear;

seq_num         = 18;
frame_interval  = 4;
start_frame     = 2;
end_frame       = 80;

% 从视频中提取生成image 序列
firstObj    = VideoReader(['../video_' num2str(seq_num) '/vd_mask.avi']);
frames_num  = firstObj.NumberOfFrames;
for i = start_frame:frame_interval:end_frame
    if i < 10
        img_name = ['/vd_' num2str(seq_num) '_00' num2str(i)];
    else if i < 100
            img_name = ['/vd_' num2str(seq_num) '_0' num2str(i)];
        else
            img_name = ['/vd_' num2str(seq_num) '_' num2str(i)];
        end
    end
    img = read(firstObj, i);
    %img = imresize(img(93:626, 101:size(img, 2)-100, :), 0.5);
    %img = imresize(img(:, :, :), 0.5);
    if i < 10
        imwrite(img, ['../video_' num2str(seq_num) '/mask/mask_00' num2str(i) '.png']); 
    else if i < 100
            imwrite(img, ['../video_' num2str(seq_num) '/mask/mask_0' num2str(i) '.png']); 
        else
            imwrite(img, ['../video_' num2str(seq_num) '/mask/mask_' num2str(i) '.png']); 
        end
    end
    
%     imwrite(img(:,:,1), ['../video_' num2str(seq_num) '/ch_1' img_name '.bmp']);
%     imwrite(img(:,:,2), ['../video_' num2str(seq_num) '/ch_2' img_name '.bmp']);
%     imwrite(img(:,:,3), ['../video_' num2str(seq_num) '/ch_3' img_name '.bmp']);
end

%% 生成caption mask
% t_mask = imread(['../video_' num2str(seq_num) '/other/t_mask.bmp']);
% mask   = zeros(267, 540);
% caption                 = mask(87:116, 175:384);
% caption(t_mask > 0)     = 255;
% mask(87:116, 175:384)   = caption;
% 
% caption                 = mask(127:156, 175:384);
% caption(t_mask > 0)     = 255;
% mask(127:156, 175:384)  = caption;
% 
% caption                 = mask(167:196, 175:384);
% caption(t_mask > 0)     = 255;
% mask(167:196, 175:384)  = caption;
% imwrite(mask, ['../video_' num2str(seq_num) '/other/mask.bmp']);

%% 生成caption mask
% t_mask = imread(['../video_' num2str(seq_num) '/other/t_mask.bmp']);
% mask   = zeros(267, 540);
% 
% mask(94:109, 175:384)   = 255;
% mask(134:149, 175:384)  = 255;
% mask(174:189, 175:384)  = 255;
% imwrite(mask, ['../video_' num2str(seq_num) '/other/_mask.bmp']);

%% 加入inpainting前景
% t_mask = imread(['../video_' num2str(seq_num) '/other/t_mask.bmp']);
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
% %     img(71:110,171:210) = 0;
%     caption_rgb = [255 255 255];
%     for m = 1: 3
%         img_ch  = img(87:116, 175:384, m);
%         img_ch(t_mask > 0) = caption_rgb(m);
%         img(87:116, 175:384, m) = img_ch;
%         
%         img_ch  = img(127:156, 175:384, m);
%         img_ch(t_mask > 0) = caption_rgb(m);
%         img(127:156, 175:384, m) = img_ch;
%         
%         img_ch  = img(167:196, 175:384, m);
%         img_ch(t_mask > 0) = caption_rgb(m);
%         img(167:196, 175:384, m) = img_ch;
%     end
% %     imwrite(img, ['../video_' num2str(seq_num) '/rgb_input' img_name '.png']);
%     imwrite(img(:,:,1), ['../?video_' num2str(seq_num) '/ch_1' img_name '.bmp']);
%     imwrite(img(:,:,2), ['../video_' num2str(seq_num) '/ch_2' img_name '.bmp']);
%     imwrite(img(:,:,3), ['../video_' num2str(seq_num) '/ch_3' img_name '.bmp']);
% end

% 手动指定特征点，并保存
% for i = start_frame:frame_interval:end_frame
%     if i < 10
%         img_name = ['../video_' num2str(seq_num) '/rgb/vd_' num2str(seq_num) '_00' num2str(i) '.png'];
%     else if i < 100
%             img_name = ['../video_' num2str(seq_num) '/rgb/vd_' num2str(seq_num) '_0' num2str(i) '.png'];
%         else
%             img_name = ['../video_' num2str(seq_num) '/rgb/vd_' num2str(seq_num) '_' num2str(i) '.png'];
%         end
%     end
%     img = imread(img_name);
%     %figure(1);
%     %imshow(img);
%     disp(['frame: ' num2str(i)]);
% %     points(:,1) = int32(ginput(1));
% %     points(:,2) = int32(ginput(1));
% %     points(:,3) = int32(ginput(1));
% %     disp(points(:,1));
% %     disp(points(:,2));
% %     disp(points(:,3));
%     points(:, 1) = input('input 1st point:');
%     points(:, 2) = input('input 2nd point:');
%     points(:, 3) = input('input 3rd point:');
%     if i < 10
%          save(['../video_' num2str(seq_num) '/vd_' num2str(seq_num) '_00' num2str(i) '-points.mat'], 'points');
%     else if i < 100
%              save(['../video_' num2str(seq_num) '/vd_' num2str(seq_num) '_0' num2str(i) '-points.mat'], 'points');
%         else
%              save(['../video_' num2str(seq_num) '/vd_' num2str(seq_num) '_' num2str(i) '-points.mat'], 'points');
%         end
%     end
%    
% end

%% 合成rgb图像
% for i = start_frame:frame_interval:end_frame
%     num = uint8((i -start_frame) /3) + 1;
%     img_name = ['/vd_3_' num2str(num)];% num2str(seq_num) '_'
%     
% %     num = i;
% %     if num < 10
% %         img_name = ['/vd_' num2str(seq_num) '_00' num2str(num)];
% %     else if num < 100
% %             img_name = ['/vd_' num2str(seq_num) '_0' num2str(num)];
% %         else
% %             img_name = ['/vd_' num2str(seq_num) '_' num2str(num)];
% %         end
% %     end
%     img_r = imread(['../../results/video_' num2str(seq_num) '/ch_1' img_name '.bmp']);
%     img_g = imread(['../../results/video_' num2str(seq_num) '/ch_2' img_name '.bmp']);
%     img_b = imread(['../../results/video_' num2str(seq_num) '/ch_3' img_name '.bmp']);
%     
%     img(:, :, 1) = img_r;
%     img(:, :, 2) = img_g;
%     img(:, :, 3) = img_b;
%     imwrite(img, ['../../results/video_' num2str(seq_num) '/vd_3_output_' num2str(i) '.png']);
% end

%% 自动寻找匹配特征点，并保存
% addpath('siftDemoV4');
% distRatio = 0.3;
% 
% img1 = ['../video_' num2str(seq_num) '/vd_' num2str(seq_num) '_' num2str(start_frame) '.bmp'];
% [im1, des1, loc1] = sift(img1);
% 
% for i = start_frame+frame_interval:frame_interval:end_frame
%     img2 = ['../video_' num2str(seq_num) '/vd_' num2str(seq_num) '_' num2str(i) '.bmp'];
%     [im2, des2, loc2] = sift(img2);
%     
%     des2t = des2';                          % Precompute matrix transpose
%     match = ones(1, size(des1,1));
%     for j = 1 : size(des1,1)
%         if match(j) ~= 0
%             dotprods = des1(j,:) * des2t;        % Computes vector of dot products
%             [vals,indx] = sort(acos(dotprods));  % Take inverse cosine and sort results
%             
%             % Check if nearest neighbor has angle less than distRatio times 2nd.
%             if (vals(1) < distRatio * vals(2))
%                 match(j) = indx(1);
%             else
%                 match(j) = 0;
%             end
%         end
%     end
% end
% 
% sift3   = zeros(1,3);
% select_sift = [7 15 16];  %选择非0的特征点中三个序号
% sift_m  = 1;            %三个特征点
% nozero  = 1;            %非0的match点
% for k = 1: size(des1,1)
%     if (match(k) > 0 && sift_m <= 3)
%         if nozero == select_sift(sift_m)
%             points(:, sift_m) = [loc1(k,2); loc1(k,1)];
%             sift3(sift_m) = k;
%             sift_m = sift_m + 1;
%         end
%         nozero = nozero + 1;
%     else if sift_m > 3
%             break;
%         end
%     end
% end
% save(['../video_' num2str(seq_num) '/vd_' num2str(seq_num) '_' num2str(start_frame) '-points.mat'], 'points');
% num = sum(match > 0);
% fprintf('Found %d matches.\n', num);
% disp('img 1:')
% points
% 
% for i = start_frame+frame_interval:frame_interval:end_frame
%     img2 = ['../video_' num2str(seq_num) '/vd_' num2str(seq_num) '_' num2str(i) '.bmp'];
%     [im2, des2, loc2] = sift(img2);
%     
%     des2t = des2';                          % Precompute matrix transpose
%     for j = 1 : 3
%         dotprods = des1(sift3(j),:) * des2t;        % Computes vector of dot products
%         [vals,indx] = sort(acos(dotprods));  % Take inverse cosine and sort results
%         
%         points(:, j) = [loc2(indx(1),2); loc2(indx(1),1)];
%     end
% disp(['img ' num2str(i) ':']);
% points
% save(['../video_' num2str(seq_num) '/vd_' num2str(seq_num) '_' num2str(i) '-points.mat'], 'points');
% end
