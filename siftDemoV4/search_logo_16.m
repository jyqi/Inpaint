clc;clear;
tic;
seq_num         = 16;
frame_interval  = 10;
start_frame     = 10;
end_frame       = 100;
channel = 'ch_1';

img_min = imread(['../video_' num2str(seq_num) '/' channel '/vd_' num2str(seq_num) '_0' num2str(start_frame) '.bmp']);
img_max = imread(['../video_' num2str(seq_num) '/' channel '/vd_' num2str(seq_num) '_0' num2str(start_frame) '.bmp']);
[M,N] = size(img_min);
for i = start_frame:frame_interval:end_frame
    if i < 10
        img_name = ['../video_' num2str(seq_num) '/' channel '/vd_' num2str(seq_num) '_00' num2str(i) '.bmp'];
    else if i < 100
            img_name = ['../video_' num2str(seq_num) '/' channel '/vd_' num2str(seq_num) '_0' num2str(i) '.bmp'];
        else
            img_name = ['../video_' num2str(seq_num) '/' channel '/vd_' num2str(seq_num) '_' num2str(i) '.bmp'];
        end
    end
    img = imread(img_name);
    for p = 1:1:M
        for q = 1:1:N
            if(img(p,q) <= img_min(p,q)) 
                img_min(p,q) = img(p,q);
            else if(img(p,q) >= img_max(p,q)) 
                    img_max(p,q) = img(p,q);
                end
            end
        end
    end
end
img_change1 = img_max - img_min;
figure(1);imshow(img_change1);
figure(2);imshow(img_max);
figure(3);imshow(img_min);


channel = 'ch_2';
img_min = imread(['../video_' num2str(seq_num) '/' channel '/vd_' num2str(seq_num) '_0' num2str(start_frame) '.bmp']);
img_max = imread(['../video_' num2str(seq_num) '/' channel '/vd_' num2str(seq_num) '_0' num2str(start_frame) '.bmp']);

for i = start_frame:frame_interval:end_frame
    if i < 10
        img_name = ['../video_' num2str(seq_num) '/' channel '/vd_' num2str(seq_num) '_00' num2str(i) '.bmp'];
    else if i < 100
            img_name = ['../video_' num2str(seq_num) '/' channel '/vd_' num2str(seq_num) '_0' num2str(i) '.bmp'];
        else
            img_name = ['../video_' num2str(seq_num) '/' channel '/vd_' num2str(seq_num) '_' num2str(i) '.bmp'];
        end
    end
    img = imread(img_name);
    for p = 1:1:M
        for q = 1:1:N
            if(img(p,q) <= img_min(p,q)) 
                img_min(p,q) = img(p,q);
            else if(img(p,q) >= img_max(p,q)) 
                    img_max(p,q) = img(p,q);
                end
            end
        end
    end
end
img_change2 = img_max - img_min;


img_min = imread(['../video_' num2str(seq_num) '/' channel '/vd_' num2str(seq_num) '_0' num2str(start_frame) '.bmp']);
img_max = imread(['../video_' num2str(seq_num) '/' channel '/vd_' num2str(seq_num) '_0' num2str(start_frame) '.bmp']);

for i = start_frame:frame_interval:end_frame
    if i < 10
        img_name = ['../video_' num2str(seq_num) '/' channel '/vd_' num2str(seq_num) '_00' num2str(i) '.bmp'];
    else if i < 100
            img_name = ['../video_' num2str(seq_num) '/' channel '/vd_' num2str(seq_num) '_0' num2str(i) '.bmp'];
        else
            img_name = ['../video_' num2str(seq_num) '/' channel '/vd_' num2str(seq_num) '_' num2str(i) '.bmp'];
        end
    end
    img = imread(img_name);
    for p = 1:1:M
        for q = 1:1:N
            if(img(p,q) <= img_min(p,q)) 
                img_min(p,q) = img(p,q);
            else if(img(p,q) >= img_max(p,q)) 
                    img_max(p,q) = img(p,q);
                end
            end
        end
    end
end
img_change3 = img_max - img_min;
img_changeall = img_change1./3 + img_change2./3 + img_change3./3;
figure(4);imshow(img_changeall);
level = graythresh(img_changeall);
BW = ~im2bw(img_changeall, level);

figure(5);imshow(BW);
% B = [1 1 1
%     1 1 1
%     1 1 1];
% %BW1 = imerode(BW, B);
% BW = imdilate(BW, B);
% BW = imdilate(BW, B);
% BW = imdilate(BW, B);
%figure(3);imshow(BW);

[B,L] = bwboundaries(BW, 'noholes');
for k = 1:length(B)
    boundary = B{k};
    xmin = min(boundary(:, 1));
    xmax = max(boundary(:, 1));
    ymin = min(boundary(:, 2));
    ymax = max(boundary(:, 2));
    [flag] = check(M, N, xmin, xmax, ymin, ymax);
    if(flag == 0) 
        x = boundary(1, 1);
        y = boundary(1, 2);
        queue_head=1;       %队列头
        queue_tail=1;       %队列尾
        neighbour=[-1 -1;-1 0;-1 1;0 -1;0 1;1 -1;1 0;1 1];  %和当前像素坐标相加得到八个邻域坐标
        %neighbour=[-1 0;1 0;0 1;0 -1];     %四邻域用的
        clear tmp;
        tmp{queue_tail}=[x y];
        queue_tail=queue_tail+1;
        [ser1 ser2]=size(neighbour);

        while queue_head~=queue_tail
            pix=tmp{queue_head};
            for i=1:ser1
                pix1=pix+neighbour(i,:);
                if pix1(1)>=1 && pix1(2)>=1 && pix1(1)<= M && pix1(2)<= N
                    if BW(pix1(1),pix1(2))==1 
                        BW(pix1(1),pix1(2))=0;
                        tmp{queue_tail}=[pix1(1) pix1(2)];
                        queue_tail=queue_tail+1;
                    end      
                end
            end
            queue_head=queue_head+1;
        end
    end;
end
figure(6);imshow(BW);
imwrite(BW, ['../video_' num2str(seq_num) '/mask.bmp']);
