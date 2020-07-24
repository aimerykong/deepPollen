%% add path and setup configuration
clc; clear; close all;

path_to_matconvnet = './libs/matconvnet';
run(fullfile(path_to_matconvnet, 'matlab', 'vl_setupnn'));
addpath(genpath(fullfile('dependencies', 'matconvnet','examples')));
addpath('./libs/exportFig');
addpath(genpath('./libs/layerExt'));
addpath(genpath('./libs/myFunctions'));
addpath(genpath('./script'));

mean_r = 123.68; %means to be subtracted and the given values are used in our training stage
mean_g = 116.779;
mean_b = 103.939;
mean_bgr = reshape([mean_b, mean_g, mean_r], [1,1,3]);
mean_rgb = reshape([mean_r, mean_g, mean_b], [1,1,3]);
%% read matconvnet model
load('./script/imdb_for_test.mat');
imdb.test = imdb.val;
imdb.meta.classNum = length(imdb.meta.genusName);
imdb.root_path = '/home/skong2/restore/dataset/pollen_catatumbus/dataset_part3_by_Ingrid';

imdbRef = load('./script/imdb_for_training.mat');
imdbRef = imdbRef.imdb;
imdbRef.meta.classNum = length(imdb.meta.genusName);
imdbRef.root_path = '/home/skong2/restore/dataset/pollen_catatumbus';

% set GPU
gpuId = 1; %[1, 2];
gpuDevice(gpuId);
%% setup network
saveFolder = 'main003_cls_MIL4View2_v4_aboveRes4_512dim_ftEpoch48';
modelName = 'softmax_net-epoch-104.mat';


netbasemodel = load( fullfile('./models', saveFolder, modelName) );
netbasemodel = netbasemodel.net;
netbasemodel = dagnn.DagNN.loadobj(netbasemodel);

allSoftmax = sprintf('softmaxLayer');
netbasemodel.vars(netbasemodel.layers(netbasemodel.getLayerIndex(allSoftmax)).outputIndexes).precious = 1;
layerTop = sprintf('MaxProbLayer');
netbasemodel.vars(netbasemodel.layers(netbasemodel.getLayerIndex(layerTop)).outputIndexes).precious = 1;

saveToken = [strrep(saveFolder, '/', ''), '_', strrep(modelName, '/', '')];
[~, modelName] = fileparts(modelName);
saveFolder = fullfile('figFolder', [strrep(saveFolder, '/', ''), '_' modelName, '_visualization']);

netbasemodel.move('gpu');
netbasemodel.mode = 'test' ;
% netMat.mode = 'normal' ;
netbasemodel.conserveMemory = 1;
%% test res2
saveFolder = 'visualizeView2Prediction';
if ~isdir(saveFolder)
    mkdir(saveFolder);
end

setName = 'val'; % train val

for sampleIdx = 1:length(imdb.(setName).view1)
    %% read the image and annotation
    fprintf('image-%03d %s ... \n', sampleIdx, imdb.(setName).view1{sampleIdx});
    path4view2List = imdb.val.view2{sampleIdx};
    grndLabel = imdb.(setName).label(sampleIdx);
    
    path4view1 = imdb.(setName).view1{sampleIdx};
    curSampleView1 = imread(fullfile(imdb.root_path, imdb.datasetFolder, imdb.meta.genusName{grndLabel}, path4view1));
    imBatch = zeros(640, 640, 3, length(path4view2List), 'single');
    for jj = 1:length(path4view2List)
        curpath4view2 = path4view2List{jj};
        cur_image = imread(fullfile(imdb.root_path, imdb.datasetFolder, imdb.meta.genusName{grndLabel}, curpath4view2));
        cur_image = repmat(cur_image,[1 1 3]);
        imBatch(:,:,:,jj) = cur_image;
    end
    inputs = {'data', gpuArray(bsxfun(@minus, single(imBatch), mean_rgb))};
    netbasemodel.eval(inputs) ;
    allSoftmaxFea = gather(netbasemodel.vars(netbasemodel.layers(netbasemodel.getLayerIndex(allSoftmax)).outputIndexes).value);
    SoftMaxLayer = gather(netbasemodel.vars(netbasemodel.layers(netbasemodel.getLayerIndex(layerTop)).outputIndexes).value);
    
    tmp = squeeze(allSoftmaxFea);
    tmp = max(tmp,[],1);
    tmp = squeeze(tmp);
    [~,viewIndex] = max(tmp);    
    [probVal, predLabel] = max(SoftMaxLayer);
    %% visualization
    imgFig = figure(1);clf;
    set(imgFig, 'Position', [100 100 1000 800]) % [1 1 width height]
    subplot(1,2,1);
    imagesc(curSampleView1); colormap(gray); axis off image;
    title(sprintf('pred label:%s, view1 (max-projection)', imdbRef.meta.genusName{predLabel}))
    subplot(1,2,2);
    imagesc(imBatch(:,:,1,viewIndex)); colormap(gray); axis off image;
    title(sprintf('view2: NO.%d of %d in total', viewIndex, numel(tmp)));
    export_fig(fullfile(saveFolder,sprintf('%03d_%s.jpg', sampleIdx, imdb.(setName).view1{sampleIdx})));
end
%% leaving blank

