clc;
clear all;
close all;
addpath RASL_toolbox ;
currentPath = cd;

userName = 'video_2' ;
channelName = 'rgb';
canonSize = [ 250 250  ];
canonSizeColor = [250 250 3];
% input path
imagePath = fullfile(currentPath,['inpaintData/' userName '/' channelName]) ;
pointPath = fullfile(currentPath, ['inpaintData/' userName]) ; % path to files containing initial feature coordinates

% output path
destRoot = fullfile(currentPath, ['results/' userName]) ;
destDir = fullfile(destRoot,channelName) ;
if ~exist(destDir,'dir')
    mkdir(destRoot,channelName) ;
end
load([destRoot '/tmpT.mat'], 'tmpT');
load([destRoot '/Fo.mat'], 'Fo');
load([destRoot '/T.mat'], 'T');
load([destRoot '/R.mat'], 'R');
load([destRoot '/inv.mat'], 'inv_trans');
numImages = 18;
inpaintingImagePath = fullfile(currentPath,['inpaintData/' userName '/rgb']) ;
[inpaintingImages] = getInpaintingImages( inpaintingImagePath);
% originalImagePath = fullfile(currentPath,['inpaintData/' userName '/rgb']);
% [originalImages] = getInpaintingImages(originalImagePath);
% pointPath = fullfile(currentPath, ['inpaintData/' userName]) ; % path to files containing initial feature coordinates
% transformationInit = 'AFFINE';
% canonicalCoords = [ 65  65  208; ...
%                     121  54   54 ];
% [originalImages] = get_training_images( originalImagePath, pointPath, userName, canonicalCoords, transformationInit) ;         
%% reverse the alignment results to original
for i = 1:numImages
    mask = imread(['./inpaintData/' userName '/mask/vd_2_' num2str((i - 1) * 4+218) '.bmp']);
    inv_Tfm = fliptform(maketform('projective',inv_trans{i}'));
    inv_I   = vec(imtransform(reshape(T(:,i), canonSizeColor), inv_Tfm,'bicubic','XData',[1 540],'YData',[1 267],'Size',[267 540 3]));
    inv_I = inv_I / norm(inv_I) ; % normalize
    inv_I   = mapminmax(inv_I', 0, 1)';
    inpaint_I = reshape(inv_I, 267, 540, 3)*255;
    inpaint_I = uint8(inpaint_I);
    I = imread(inpaintingImages{i});
    figure(99);
    imshow(inpaint_I);
    imwrite(inpaint_I, [destDir '/affine/vd_2_' num2str(i) '.bmp']);
    figure(100);
    imshow(I);
    figure(101);
    imshow(mask);
    I_mask          = I(131:221, 187:387, :);
    inpaint_mask    = inpaint_I(131:221, 187:387, :);
    mask_mask       = mask(131:221, 187:387);
    tmp1 = mask_mask==0;
    tmp1 = cat(3, tmp1, tmp1, tmp1);
    dotDivide       = double(I_mask(tmp1))./double(inpaint_mask(tmp1));
    alpha = median(median(dotDivide));
    tmp = logical(mask)~=0;
    I(tmp) = inpaint_I(tmp).*alpha;
    imwrite(I, [destDir '/vd_2_' num2str(i) '.bmp']);
end



numImage = 20;

xI = 3 ;
yI = 6 ;
gap = 4 ;
gap2 = 2 ;

canonicalImageSize = [250 250 3];
container = ones(canonicalImageSize(1)+gap, canonicalImageSize(2)+gap, 3); 
% white edges
bigpic = cell(xI,yI); % (xI*canonicalImageSize(1),yI*canonicalImageSize(2));

% D
for i = 1:xI
    for j = 1:yI
        if yI*(i-1)+j > numImage
            bigpic{i,j} = ones(canonicalImageSize(1)+gap, canonicalImageSize(2)+gap, 3);
        else
            tmp = reshape(Fo(:,yI*(i-1)+j), canonicalImageSize);
%             fff = cat(3, tmp(:,:,1), tmp(:,:,2), tmp(:,:,3));
%             fff = fff.*100;
%             figure(1);
%             imshow(fff);
%             figure(2);
%             imshow(fff, [], 'DisplayRange', [0,max(max(max(fff)))]);
            for k = 1:3
                container ((gap2+1):(end-gap2), (gap2+1):(end-gap2), k) = tmp(:, :, k);
            end
            bigpic{i,j} = uint8(container);
        end
    end
end
figure
% fprintf('%d/n', max(max(Fo)));
% fprintf('%d/n', min(min(Fo)));
imshow(cell2mat(bigpic),[],'DisplayRange',[0 max(max(Fo))],'Border','tight')
title('Input images') ;

% Do
for i = 1:xI
    for j = 1:yI
        if yI*(i-1)+j > numImage
            bigpic{i,j} = ones(canonicalImageSize(1)+gap, canonicalImageSize(2)+gap, 3);
        else
            tmp = reshape(T(:,yI*(i-1)+j), canonicalImageSize);
            for k = 1:3
                container ((gap2+1):(end-gap2), (gap2+1):(end-gap2), k) = tmp(:, :, k);
            end
            bigpic{i,j} = uint8(container);
            c_img   = mapminmax(T(:,yI*(i-1)+j)', 0, 1)';
%             imwrite(uint8(reshape(c_img, canonicalImageSize)*255), ['./results/video_11/align_input/ch_3/vd_11_input_align_' num2str(yI*(i-1)+j+82) '.bmp']);
        end
    end
end
figure
imshow(cell2mat(bigpic),[],'DisplayRange',[0 max(max(T))],'Border','tight')
title('Aligned images') ;


% A
for i = 1:xI
    for j = 1:yI
        if yI*(i-1)+j > numImage
            bigpic{i,j} = ones(canonicalImageSize(1)+gap, canonicalImageSize(2)+gap, 3);
        else
            tmp = reshape(R(:,yI*(i-1)+j), canonicalImageSize);
            for k = 1:3
                container ((gap2+1):(end-gap2), (gap2+1):(end-gap2), k) = tmp(:, :, k);
            end
            bigpic{i,j} = uint8(container);
            c_img   = mapminmax(R(:,yI*(i-1)+j)', 0, 1)';
            %imwrite(uint8(reshape(c_img, canonicalImageSize)*255), ['./results/video_11/align_output/ch_1/vd_11_input_align_' num2str(yI*(i-1)+j+82) '.bmp']);
        end
    end
end
figure
imshow(cell2mat(bigpic),[],'DisplayRange',[0 max(max(R))],'Border','tight')
title('Aligned images adjusted for sparse errors') ;