clc;clear;
tic;
seq_num         = 15;
frame_interval  = 50;
start_frame     = 100;
end_frame       = 5100;
channel = 'ch_3';
BW = imread(['../video_' num2str(seq_num) '/mask.bmp']);
img = imread(['../video_' num2str(seq_num) '/' channel '/vd_' num2str(seq_num) '_' num2str(end_frame) '.bmp']);
[M N] = size(img);
figure(5);imshow(img);
lambda=0.2;
a=0.5;
img = double(img);
imgn=img;
for l=1:300         %迭代次数
    for i=2:M-1
        for j=2:N-1
            if BW(i,j)==1     %如果当前像素是被污染的像素，则进行处理
                                            
                Un=sqrt((img(i,j)-img(i-1,j))^2+((img(i-1,j-1)-img(i-1,j+1))/2)^2);
                Ue=sqrt((img(i,j)-img(i,j+1))^2+((img(i-1,j+1)-img(i+1,j+1))/2)^2);
                Uw=sqrt((img(i,j)-img(i,j-1))^2+((img(i-1,j-1)-img(i+1,j-1))/2)^2);
                Us=sqrt((img(i,j)-img(i+1,j))^2+((img(i+1,j-1)-img(i+1,j+1))/2)^2);

                Wn=1/sqrt(Un^2+a^2);
                We=1/sqrt(Ue^2+a^2);
                Ww=1/sqrt(Uw^2+a^2);
                Ws=1/sqrt(Us^2+a^2);

                Hon=Wn/((Wn+We+Ww+Ws)+lambda);
                Hoe=We/((Wn+We+Ww+Ws)+lambda);
                How=Ww/((Wn+We+Ww+Ws)+lambda);
                Hos=Ws/((Wn+We+Ww+Ws)+lambda);

                Hoo=lambda/((Wn+We+Ww+Ws)+lambda);

                imgn(i,j)=Hon*img(i-1,j)+Hoe*img(i,j+1)+How*img(i,j-1)+Hos*img(i+1,j)+Hoo*img(i,j);
            
            end
        end
    end
    img=imgn;
    
end

figure(6);
imshow(img,[]);

