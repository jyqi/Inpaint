close all;clear all;clc;

addpath RASL_toolbox ;
currentPath = cd;
userName = 'video_22' ;
channelName = 'ch_1';

% input path
imagePath = fullfile(currentPath,['inpaintData/' userName '/' channelName]) ;
pointPath = fullfile(currentPath, ['inpaintData/' userName]) ; % path to files containing initial feature coordinates

% output path
destRoot = fullfile(currentPath, ['results/' userName]) ;
destDir = fullfile(destRoot,channelName) ;
if ~exist(destDir,'dir')
    mkdir(destRoot,userName) ;
end

% canonSize = [ 200 300  ];
% canonSizeColor = [200 300 3];
canonSize = [ 270 480  ];
canonSizeColor = [270 480 3];
canonicalCoords = [251 267 257; ...
                              67 66 84];
                          
transformationInit = 'AFFINE';
[IOR, tmpT, numImages, inv_trans] = get_training_images( imagePath, pointPath, userName, canonicalCoords, transformationInit) ;         
channelName = 'ch_2';
imagePath = fullfile(currentPath,['inpaintData/' userName '/' channelName]) ;
[IOG] = get_training_images( imagePath, pointPath, userName, canonicalCoords, transformationInit) ; 
channelName = 'ch_3';
imagePath = fullfile(currentPath,['inpaintData/' userName '/' channelName]) ;
[IOB] = get_training_images( imagePath, pointPath, userName, canonicalCoords, transformationInit) ;
%load(fullfile(destRoot, 'tmpT.mat'));
tic;
% For R channel
tmpI = IOR;
[Fotr, Tr, Rr, Nr, tran, inv_trans] = SID(tmpI, tmpT, canonSize, 1, inv_trans);
tmpT = tran;
 save(fullfile(destRoot, '/tmpT.mat'),'tmpT') ;
 save(fullfile(destRoot, '/inv.mat'),'inv_trans') ;
% % For G
mode = 0;
tmpI = IOG;
[Fotg, Tg, Rg, Ng] = SID(tmpI, tmpT, canonSize, mode);
% 
% % For B
tmpI = IOB;
[Fotb, Tb, Rb, Nb] = SID(tmpI, tmpT, canonSize, mode);
%close all

timeConsumed = toc;
disp(['consumed time: ' num2str(timeConsumed)]) ;

%% Show results
Fo = zeros(size(Fotr,1)*3, size(Fotr,2));
T = Fo;
R = Fo;
for i = 1 : size(Fotr,2)
%    figure;hold on;
%    subplot(1,3,1);
%    tmp = reshape(Fotr(:, i), canonSize);
   Fo(:, i) = reshape(cat(3, reshape(Fotr(:,i),canonSize),...
       reshape(Fotg(:,i),canonSize),reshape(Fotb(:,i),canonSize)), [size(Fotr, 1)*3, 1]);
%    imshow(uint8(tmp),[]);
   
%    subplot(1,3,2);
%    tmp = reshape(Tr(:, i), canonSize);
   T(:, i) = reshape(cat(3, reshape(Tr(:,i),canonSize),...
       reshape(Tg(:,i),canonSize),reshape(Tb(:,i),canonSize)), [size(Fotr, 1)*3, 1]);
%    imshow(uint8(tmp),[]);
%    subplot(1,3,3);
%    tmp = reshape(Rr(:, i), canonSize);
   R(:, i) = reshape(cat(3, reshape(Rr(:,i),canonSize),...
       reshape(Rg(:,i),canonSize),reshape(Rb(:,i),canonSize)), [size(Fotr, 1)*3, 1]);
%    imshow(uint8(tmp),[])
%    hold off
end
  save(fullfile(destRoot, '/Fo.mat'), 'Fo');
  save(fullfile(destRoot, '/T.mat'), 'T');
  save(fullfile(destRoot, '/R.mat'), 'R');
%% plot the results
numImage = 12;

layout.xI = 3 ;
layout.yI = 4 ;
layout.gap = 4 ;
layout.gap2 = 2 ;
% rasl_plot(numImages, canonSize, layout, Fotb, Tb, Rb);
rasl_plot_color(numImages, canonSizeColor, layout, Fo, T, R);