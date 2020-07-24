clear
close all;
clc;

addpath ../libs/exportFig;

% addpath(genpath('./pollen_gan/toolbox/bfmatlab'))
% addpath('./pollen_gan/')
% javaaddpath('/home/skong2/dataset/pollen_catatumbus/pollen_gan/toolbox/bfmatlab/bioformats_package.jar')

tmpImdb = load('imdb_valid_dataset_part2_by_Ingrid.mat');
tmpImdb = tmpImdb.imdb;

rng(777);
%% init
imdb.root_path = pwd;
imdb.datasetFolder = 'annotation_cropCalibMultiView_640x640';
imdb.meta.genusName = {};
imdb.meta.genusCount = [];
imdb.meta.title = 'Pollen Metric of S. Catatumbus';

imdb.train.view1 = {};
imdb.train.view2 = {};
imdb.train.label = [];

imdb.val.view1 = {};
imdb.val.view2 = {};
imdb.val.label = [];

imdb.test.view1 = {};
imdb.test.view2 = {};
imdb.test.label = [];

imdb.all.view1 = {};
imdb.all.label = [];

generaNameList = dir(fullfile(imdb.root_path, imdb.datasetFolder));
generaNameList = generaNameList(3:end);
genusCount = 0;

imdb.meta.valRatioPerGenus = 1;

for genusIdx = 1:length(generaNameList)
    %if contains(generaNameList(genusIdx).name, 'AfricanNigeria')
    %    continue;
    %end
    imdb.meta.genusName{end+1} = generaNameList(genusIdx).name;
    genusCount = genusCount + 1;
    imdb.meta.genusCount(end+1) = 0; 
    %% listing the images
    imgList = dir(fullfile(imdb.root_path, imdb.datasetFolder, generaNameList(genusIdx).name,'*mz.png'));
    randIdx = randperm(length(imgList));
    for imgIdx = 1:length(imgList)        
        imdb.all.view1{end+1} = imgList(imgIdx).name;   
        %imdb.all.view1{end+1} = imgList(randIdx(imgIdx)).name;        
        imdb.all.label(end+1) = genusCount;
        imdb.meta.genusCount(genusCount) = imdb.meta.genusCount(genusCount) + 1;
    end    
end
%% train and val
imdb.meta.valNum = floor(imdb.meta.genusCount*imdb.meta.valRatioPerGenus);
imdb.meta.trainNum = imdb.meta.genusCount-imdb.meta.valNum;
idxAnchor = 1;
for genusIdx = 1:length(imdb.meta.genusName) 
    for trainIdx = 1:imdb.meta.trainNum(genusIdx)
        imdb.train.view1{end+1} = imdb.all.view1{idxAnchor};
        imdb.train.label(end+1) = imdb.all.label(idxAnchor);
        
        view2List = {};
        [~,tmpName,~] = fileparts( imdb.all.view1{idxAnchor});
        imgList = dir(fullfile(imdb.root_path, imdb.datasetFolder, imdb.meta.genusName{genusIdx},[tmpName '_*.png']));
        for jj = 1:length(imgList)
            view2List{end+1} = imgList(jj).name;
        end
        imdb.train.view2{end+1} = view2List;
        idxAnchor = idxAnchor+1;
    end
    for valIdx = 1:imdb.meta.valNum(genusIdx)
        imdb.val.view1{end+1} = imdb.all.view1{idxAnchor};
        imdb.val.label(end+1) = imdb.all.label(idxAnchor);
        
        view2List = {};
        [~,tmpName,~] = fileparts( imdb.all.view1{idxAnchor});
        imgList = dir(fullfile(imdb.root_path, imdb.datasetFolder, imdb.meta.genusName{genusIdx},[tmpName '_*.png']));
        for jj = 1:length(imgList)
            view2List{end+1} = imgList(jj).name;
        end
        imdb.val.view2{end+1} = view2List;
        idxAnchor = idxAnchor+1;
    end
end
%% test set
for genusIdx = 1:length(generaNameList)
    if ~contains(generaNameList(genusIdx).name, 'AfricanNigeria')
        continue;
    end    
    %% listing the images
    imgList = dir(fullfile(imdb.root_path, imdb.datasetFolder, generaNameList(genusIdx).name,'*mz.png'));    
    for imgIdx = 1:length(imgList)        
        imdb.test.view1{end+1} = imgList(imgIdx).name;        
        imdb.test.label(end+1) = -1;        
        
        view2List = {};
        [~,tmpName,~] = fileparts(imgList(imgIdx).name);
        imgView2List = dir(fullfile(imdb.root_path, imdb.datasetFolder, generaNameList(genusIdx).name, [tmpName '_*.png']));
        for jj = 1:length(imgView2List)
            view2List{end+1} = imgView2List(jj).name;
        end
        imdb.test.view2{end+1} = view2List;        
    end    
end


%% save
save('imdb_for_test.mat', 'imdb');
%% leaving blank











