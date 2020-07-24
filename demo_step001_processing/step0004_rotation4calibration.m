clear
close all;
clc;

addpath exportFig;
% addpath(genpath('./pollen_gan/toolbox/bfmatlab'))
% addpath('./pollen_gan/')
% javaaddpath('/home/skong2/dataset/pollen_catatumbus/pollen_gan/toolbox/bfmatlab/bioformats_package.jar')

load imdb_valid_dataset_part3_by_Ingrid.mat;
%%
basepath = './cmax';
outpath = './annotation_rot4calibr';
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
    %% click to rotate
    imdemo = imresize(im, 0.5);
    imdemo = repmat(imdemo,[1,1,3]);
    
    figure(1);
    subplot(1,2,1);
    imagesc(imdemo); axis off image; colormap(gray);

    [xtop,ytop] = ginput(1);
    xtop = round(xtop);
    ytop = round(ytop);
    imdemo(ytop-2:ytop+2,xtop-2:xtop+2,1) = 255;
    imdemo(ytop-2:ytop+2,xtop-2:xtop+2,2) = 0;
    imdemo(ytop-2:ytop+2,xtop-2:xtop+2,3) = 0;    
    subplot(1,2,1);
    imagesc(imdemo); axis off image; colormap(gray);

    [xbot,ybot] = ginput(1);
    xbot = round(xbot);
    ybot = round(ybot);
    imdemo(ybot-2:ybot+2,xbot-2:xbot+2,1) = 0;
    imdemo(ybot-2:ybot+2,xbot-2:xbot+2,2) = 0;
    imdemo(ybot-2:ybot+2,xbot-2:xbot+2,3) = 255;    
    subplot(1,2,1);
    imagesc(imdemo); axis off image; colormap(gray);
    
    %line([xtop,xbot],[ytop,ybot]); % % line([x1,x2],[y1,y2])
    dp = [xbot-xtop, ybot-ytop];
    hold on;
    quiver(xtop, ytop, dp(1), dp(2),0)
    
    theta =  dp(2) / sqrt(dp(:)'*dp(:));
    theta = sign(dp(1))*acos(theta) / pi*180; % clockwise rotation
    imdemo = imrotate(imdemo, -theta);
    subplot(1,2,2);
    imagesc(imdemo); axis off image; colormap(gray);
    title(sprintf('image-%02d',i));
    %% save manual calibration
    %outfile = fullfile(outpath, subfolder, sprintf('%04d_%s', i, imdb.filename{i}));
    outfile = fullfile(outpath, subfolder, sprintf('%s', imdb.filename{i}));
    save([outfile '.mat'],'xbot','ybot','xtop','ytop','dp','theta');
    export_fig([outfile '_rotDemo.png']);
    clf;
end
%% leaving blank
%{
002
%}