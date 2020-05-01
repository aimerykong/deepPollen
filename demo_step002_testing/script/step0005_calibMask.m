clear
close all;
clc;

addpath ../libs/exportFig;

% addpath(genpath('./pollen_gan/toolbox/bfmatlab'))
% addpath('./pollen_gan/')
% javaaddpath('/home/skong2/dataset/pollen_catatumbus/pollen_gan/toolbox/bfmatlab/bioformats_package.jar')

load imdb_valid_dataset_part2_by_Ingrid.mat;
%%
path_to_cmax = '/home/skong2/restore/dataset/pollen_catatumbus/dataset_part2_by_Ingrid/cmax';
path_to_mask = '/home/skong2/restore/dataset/pollen_catatumbus/dataset_part2_by_Ingrid/annotation_maskAfterManualCleanup';
path_to_rotCalib = '/home/skong2/restore/dataset/pollen_catatumbus/dataset_part2_by_Ingrid/annotation_rot4calibr';

outpath = '/home/skong2/restore/dataset/pollen_catatumbus/dataset_part2_by_Ingrid/annotation_calibMasking';
if ~isdir(outpath)
   mkdir(outpath);
end

canonicalSize = 800;
reSZ = [40, 40];
thres = 0.2;
hsize = 10;
sigma = 2;
GauF = fspecial('gaussian', hsize, sigma);
for i = 2:length(imdb.folderName)
    subfolder = imdb.folderName{i};
    if ~isdir(fullfile(outpath,subfolder))
        mkdir(fullfile(outpath,subfolder));
    end
    fprintf('%d %s\n', i, imdb.filename{i});
    
    path_to_file = fullfile(path_to_cmax, subfolder, imdb.filename{i});
    im = imread([path_to_file '_mz.png']);
    rotMat = load([fullfile(path_to_rotCalib, subfolder, imdb.filename{i}) '.mat']);
    tmpMask = imread([fullfile(path_to_mask, subfolder, imdb.filename{i}) '_mask4manualCleanup.png']);
    
    im = double(im)/255;    
    curMask = (tmpMask(:,:,3)==255);
    %goodMask = (tmpMask(:,:,2)==255);
    %badMask = (tmpMask(:,:,2)==0);
    
    rotMask = imrotate(curMask, -rotMat.theta);
    rotImg = imrotate(im, -rotMat.theta);
    
    rotImg = rotImg.*rotMask;
    %% crop
    imCrop = makeImSquareByPadding(rotImg);
    maskCrop = makeImSquareByPadding(rotMask);
    
    [yy,xx] = find(maskCrop==1);
    ytop = min(yy);
    ybot = max(yy);
    xleft = min(xx);
    xright = max(xx);
    
    imCrop = imCrop(ytop:ybot,xleft:xright);
    maskCrop = maskCrop(ytop:ybot,xleft:xright);    
    if size(imCrop,1)<canonicalSize
        imCrop = makeImSquareByPadding(imCrop, [canonicalSize,size(imCrop,2)]); 
        maskCrop = makeImSquareByPadding(maskCrop, [canonicalSize,size(imCrop,2)]);                
    else
        c = size(imCrop,1)/2;
        imCrop = imCrop(round(c-canonicalSize/2)+1:round(c+canonicalSize/2),:);  
        maskCrop = maskCrop(round(c-canonicalSize/2)+1:round(c+canonicalSize/2),:);        
    end
    
    if size(imCrop,2)<canonicalSize
        imCrop = makeImSquareByPadding(imCrop, [size(imCrop,1),canonicalSize]);  
        maskCrop = makeImSquareByPadding(maskCrop, [size(imCrop,1),canonicalSize]);        
    else
        c = size(imCrop,2)/2;
        imCrop = imCrop(:,round(c-canonicalSize/2)+1:round(c+canonicalSize/2));   
        maskCrop = maskCrop(:,round(c-canonicalSize/2)+1:round(c+canonicalSize/2));        
    end
    %% visualize
%     figure(1);
%     subplot(2,2,1); imagesc(im); axis off image; colormap(gray); title('original image');
%     subplot(2,2,2); imagesc(curMask); axis off image; title('mask');
%     subplot(2,2,3); imagesc(rotImg); axis off image; title('rotCalibMasking');
%     subplot(2,2,4); imagesc(imCrop); axis off image; title('crop');
   
    %% get mask        
    %imdemo = cat(3, im*255, ones(size(im),'single')*50, single(mask)*254+1);

    outfile = fullfile(outpath, subfolder, sprintf('%s', imdb.filename{i}));    
    imwrite(imCrop,[outfile '_calibMasking.png']);
end
%% leaving blank
%{
%}