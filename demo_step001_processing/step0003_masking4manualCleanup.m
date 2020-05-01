% step00002_masking4manualCleanup.m
clear
close all;
clc;

% addpath(genpath('./pollen_gan/toolbox/bfmatlab'))
% addpath('./pollen_gan/')
% javaaddpath('/home/skong2/dataset/pollen_catatumbus/pollen_gan/toolbox/bfmatlab/bioformats_package.jar')

load imdb_valid_dataset_part3_by_Ingrid.mat;
%%
basepath = '/home/skong2/restore/dataset/pollen_catatumbus/dataset_part3_by_Ingrid/cmax';
outpath = '/home/skong2/restore/dataset/pollen_catatumbus/dataset_part3_by_Ingrid/annotation_mask4manualCleanup';
if ~isdir(outpath)
    mkdir(outpath);
end

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
    
    path_to_file = fullfile(basepath, subfolder, imdb.filename{i});
    im = imread([path_to_file '_mz.png']);
    
    im = double(im)/255;
    
    %% get mask    
    imBlur = imfilter(im, GauF, 'replicate', 'same', 'conv');
    %subplot(3,3,4); imshow(imBlur); title('image-blur');
    
    imBlurBinary = imBlur;
    imBlurBinary(imBlurBinary > thres) = 1;
    imBlurBinary(imBlurBinary <= thres) = 0;
    %subplot(3,3,5); imshow(imBlurBinary); title('image-blur-binary');
        
    %imBlurBinary = makeImSquareByPadding(imBlurBinary);
    imBlurBinaryMask = imBlurBinary;
    imBlurBinaryMaskcomplement = 1-imBlurBinaryMask;
    
    SE = strel('disk',25);
    BW1 = imerode(imBlurBinaryMask,SE);
    BW2 = imdilate(BW1, SE);
    
    SE = strel('disk',10);
    BW3 = imdilate(BW2, SE);
    BW4 = imerode(BW3,SE);
    imBlurBinaryMask = BW4;
    
    mask = zeros(size(imBlurBinaryMask));    
    cntCMPO = bwconncomp(imBlurBinaryMask, 8);
    CMPOholeList = zeros(numel(cntCMPO.PixelIdxList),1);
    maxIdx = 0;
    maxArea = 0;
    for jj = 1:length(cntCMPO.PixelIdxList)
        if numel(cntCMPO.PixelIdxList{jj})>maxArea
            maxArea = numel(cntCMPO.PixelIdxList{jj});
            maxIdx = jj;
        end
    end
    mask(cntCMPO.PixelIdxList{maxIdx}) = 1;
    SE = strel('disk',10);
    mask = imdilate(mask, SE);
    mask = imerode(mask,SE);
    %% masking    
    %     imHistEq = im;
    %     imHistEq = histeq(imHistEq,100);
    %     imHistEq = imHistEq-min(imHistEq(:));
    %     imHistEq = imHistEq./max(imHistEq(:));
    %     imshow(imHistEq);
        
    imdemo = cat(3, im*255, ones(size(im),'single')*50, single(mask)*254+1);
    %imshow(uint8(imdemo));
    
    
    %outfile = fullfile(outpath, subfolder, sprintf('%04d_%s', i, imdb.filename{i}));
    outfile = fullfile(outpath, subfolder, sprintf('%s', imdb.filename{i}));
    %imwrite(mask,[outfile '_mask.png']);
    imwrite(uint8(imdemo),[outfile '_mask4manualCleanup.png']);
    %copyfile([path_to_file '_mz.png'], [outfile '_mz.png']);        
end
%% leaving blank
%{
%}
