clear
close all;
clc;

addpath exportFig;

% addpath(genpath('./pollen_gan/toolbox/bfmatlab'))
% addpath('./pollen_gan/')
% javaaddpath('/home/skong2/dataset/pollen_catatumbus/pollen_gan/toolbox/bfmatlab/bioformats_package.jar')

load imdb_valid_dataset_part3_by_Ingrid.mat;
%%
path_to_cmax = './cmax_smart';
path_to_mask = './annotation_maskAfterManualCleanup';
path_to_rotCalib = './annotation_rot4calibr';

outpath = './annotation_cropCalibMultiView_640x640';
if ~isdir(outpath)
   mkdir(outpath);
end

canonicalSize = 640;
reSZ = [40, 40];
thres = 0.2;
hsize = 10;
sigma = 2;
GauF = fspecial('gaussian', hsize, sigma);
for i = 1:length(imdb.folderName)
    subfolder = imdb.folderName{i};
    if ~isdir(fullfile(outpath,subfolder))
        mkdir(fullfile(outpath,subfolder));
    end
    fprintf('%d %s\n', i, imdb.filename{i});
    rotMat = load([fullfile(path_to_rotCalib, subfolder, imdb.filename{i}) '.mat']);
    tmpMask = imread([fullfile(path_to_mask, subfolder, imdb.filename{i}) '_mask4manualCleanup.png']);
    curMask = (tmpMask(:,:,3)==255);
        
    rotMask = imrotate(curMask, -rotMat.theta);        
    [yy,xx] = find(rotMask==1);
    ytop = min(yy);
    ybot = max(yy);
    xleft = min(xx);
    xright = max(xx);
    
    %maskCrop = makeImSquareByPadding(rotMask);
    
    path_to_file = fullfile(path_to_cmax, subfolder, imdb.filename{i});
    imList = dir([path_to_file '_mz*.png']);
    for jj = 1:length(imList)        
        im = imread(fullfile(path_to_cmax, subfolder, imList(jj).name));
        im = double(im);
        rotImg = imrotate(im, -rotMat.theta);    
        rotImg = rotImg.*rotMask;
        imCrop = rotImg(ytop:ybot,xleft:xright);
        imCrop = makeImSquareByPadding(imCrop);
        imCrop = imresize(imCrop,0.5);
        %% pad to desired size
        if size(imCrop,1)<canonicalSize
            imCrop = makeImSquareByPadding(imCrop, [canonicalSize,size(imCrop,2)]);            
        else
            c = size(imCrop,1)/2;
            imCrop = imCrop(round(c-canonicalSize/2)+1:round(c+canonicalSize/2),:);            
        end
        
        if size(imCrop,2)<canonicalSize
            imCrop = makeImSquareByPadding(imCrop, [size(imCrop,1),canonicalSize]);            
        else
            c = size(imCrop,2)/2;
            imCrop = imCrop(:,round(c-canonicalSize/2)+1:round(c+canonicalSize/2));            
        end
        figure(1);
        imagesc(imCrop); axis off image; colormap(gray); 
        %% save
        outfile = fullfile(outpath, subfolder, imList(jj).name);
        imwrite(uint8(imCrop), outfile);
    end    
end
%% leaving blank
%{
%}