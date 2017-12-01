function rasl_plot_color(numImage, canonicalImageSize, layout, Fotr, Tr, Rr)

%% display

% layout
if nargin < 4
    xI = ceil(sqrt(numImage)) ;
    yI = ceil(numImage/xI) ;

    gap = 2;
    gap2 = 1; % gap2 = gap/2;
else
    xI = layout.xI ;
    yI = layout.yI ;

    gap = layout.gap ;
    gap2 = layout.gap2 ; % gap2 = gap/2;
end
container = ones(canonicalImageSize(1)+gap, canonicalImageSize(2)+gap, 3); 
% white edges
bigpic = cell(xI,yI); % (xI*canonicalImageSize(1),yI*canonicalImageSize(2));

% D
for i = 1:xI
    for j = 1:yI
        if yI*(i-1)+j > numImage
            bigpic{i,j} = ones(canonicalImageSize(1)+gap, canonicalImageSize(2)+gap, 3);
        else
            tmp = reshape(Fotr(:,yI*(i-1)+j), canonicalImageSize);
            for k = 1:3
                container ((gap2+1):(end-gap2), (gap2+1):(end-gap2), k) = tmp(:, :, k);
            end
            bigpic{i,j} = uint8(container);
        end
    end
end
figure
imshow(cell2mat(bigpic),[],'DisplayRange',[0 max(max(Fotr))],'Border','tight')
title('Input images') ;

% Do
for i = 1:xI
    for j = 1:yI
        if yI*(i-1)+j > numImage
            bigpic{i,j} = ones(canonicalImageSize(1)+gap, canonicalImageSize(2)+gap, 3);
        else
            tmp = reshape(Tr(:,yI*(i-1)+j), canonicalImageSize);
            for k = 1:3
                container ((gap2+1):(end-gap2), (gap2+1):(end-gap2), k) = tmp(:, :, k);
            end
            bigpic{i,j} = uint8(container);
            c_img   = mapminmax(Tr(:,yI*(i-1)+j)', 0, 1)';
%             imwrite(uint8(reshape(c_img, canonicalImageSize)*255), ['./results/video_11/align_input/ch_3/vd_11_input_align_' num2str(yI*(i-1)+j+82) '.bmp']);
        end
    end
end
figure
imshow(cell2mat(bigpic),[],'DisplayRange',[0 max(max(Tr))],'Border','tight')
title('Aligned images') ;


% A
for i = 1:xI
    for j = 1:yI
        if yI*(i-1)+j > numImage
            bigpic{i,j} = ones(canonicalImageSize(1)+gap, canonicalImageSize(2)+gap, 3);
        else
            tmp = reshape(Rr(:,yI*(i-1)+j), canonicalImageSize);
            for k = 1:3
                container ((gap2+1):(end-gap2), (gap2+1):(end-gap2), k) = tmp(:, :, k);
            end
            bigpic{i,j} = uint8(container);
            c_img   = mapminmax(Rr(:,yI*(i-1)+j)', 0, 1)';
            %imwrite(uint8(reshape(c_img, canonicalImageSize)*255), ['./results/video_11/align_output/ch_1/vd_11_input_align_' num2str(yI*(i-1)+j+82) '.bmp']);
        end
    end
end
figure
imshow(cell2mat(bigpic),[],'DisplayRange',[0 max(max(Rr))],'Border','tight')
title('Aligned images adjusted for sparse errors') ;

% E
% for i = 1:xI
%     for j = 1:yI
%         if yI*(i-1)+j > numImage
%             bigpic{i,j} = ones(canonicalImageSize(1)+gap, canonicalImageSize(2)+gap);
%         else
%             container ((gap2+1):(end-gap2), (gap2+1):(end-gap2)) = reshape(E(:,yI*(i-1)+j), canonicalImageSize);
%             bigpic{i,j} = container;
%             c_img   = mapminmax(abs(E(:,yI*(i-1)+j)'), 0, 1)';
% %             imwrite(uint8(reshape(c_img, canonicalImageSize)*255), ['./results/video_11/error/ch_3/vd_11_error_' num2str(yI*(i-1)+j+82) '.bmp']);
%         end
%     end
% end
% figure
% imshow(abs(cell2mat(bigpic)),[],'DisplayRange',[0 max(max(abs(E)))],'Border','tight')
% title('Sparse corruptions in the aligned images') ;

% average face of D, Do and A
% bigpic = cell(1,3); 
% container ((gap2+1):(end-gap2), (gap2+1):(end-gap2)) = reshape(sum(D,2), canonicalImageSize);
% bigpic{1,1} = container;
% container ((gap2+1):(end-gap2), (gap2+1):(end-gap2)) = reshape(sum(Do,2), canonicalImageSize);
% bigpic{1,2} = container;
% container ((gap2+1):(end-gap2), (gap2+1):(end-gap2)) = reshape(sum(A,2), canonicalImageSize);
% bigpic{1,3} = container;
% 
% figure
% subplot(1,3,1)
% imshow(uint8(reshape(sum(Fotr,3), canonicalImageSize)),[])
% title('average of unaligned D')
% subplot(1,3,2)
% imshow(uint8(reshape(sum(Tr,3), canonicalImageSize)),[])
% title('average of aligned D')
% subplot(1,3,3)
% imshow(uint8(reshape(sum(Rr,3), canonicalImageSize)),[])
% title('average of A')