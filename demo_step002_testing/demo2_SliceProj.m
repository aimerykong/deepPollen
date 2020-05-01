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
testAugmentation = 1;
setName = 'test'; % train val test
grndList = zeros(1, length(imdb.(setName).view2));
predList = zeros(1, length(imdb.(setName).view2));
confMat = zeros(length(imdbRef.meta.genusName), length(imdb.(setName).view1));
txtLine = {};

outputF = fopen('model2_sliceProj_catatumbus_part2.csv', 'w');
fprintf(outputF, 'testSampleName, ' );
for i = 1:length(imdbRef.meta.genusName)    
    fprintf(outputF, '%s', imdbRef.meta.genusName{i});
    if i ~= length(imdbRef.meta.genusName)    
        fprintf(outputF, ',');
    else
        fprintf(outputF, '\n');
    end
end

for i = 1:length(imdb.(setName).view1) 
    %% read the image and annotation 
    %fprintf('image-%03d %s ... \n', i, imdb.(setName).view1{i});
    path4view2List = imdb.(setName).view2{i};
    label = imdb.(setName).label(i);    
    grndList(i) = label;   
    imBatch = zeros(640, 640, 3, length(path4view2List), 'single');
    for jj = 1:length(path4view2List)
        curpath4view2 = path4view2List{jj};
        cur_image = imread(fullfile(imdb.root_path, imdb.datasetFolder, 'S_catatumbus_eocene_SA_selected', curpath4view2));
        
        cur_image = repmat(cur_image,[1 1 3]);
        cur_image = bsxfun(@minus, single(cur_image), mean_rgb) ;
        imBatch(:,:,:,jj) = cur_image;
    end
    inputs = {'data', gpuArray(imBatch)};
    netbasemodel.eval(inputs) ;
    SoftMaxLayer = gather(netbasemodel.vars(netbasemodel.layers(netbasemodel.getLayerIndex(layerTop)).outputIndexes).value);
    SoftMaxLayer = SoftMaxLayer(:);
    confMat(:,i) = SoftMaxLayer;
    [probVal, predClass] = max(SoftMaxLayer);       
    %% recording    
    predList(i) = predClass;
    txtLine{end+1} = sprintf('%02d name:%s \t\t pred-genus: %s (%.3f)', i, imdb.(setName).view1{i}, imdbRef.meta.genusName{predClass}, probVal);
    fprintf('%s\n',txtLine{end});
    
    fprintf(outputF, '%s, ', imdb.(setName).view1{i} );
    for j = 1:length(imdbRef.meta.genusName)    
        fprintf(outputF, '%.3f', SoftMaxLayer(j));
        if j ~= length(imdbRef.meta.genusName)
            fprintf(outputF, ',');
        else
            fprintf(outputF, '\n');
        end
    end
end
fclose(outputF);

%% save
save(sprintf('./result/fossilPart2_view2_%s',saveToken), 'txtLine', 'predList', 'confMat');
%% leaving blank
%{
01 name:S_catatumbus_max2_M119_T58_2_Airyscan Processing_mz.png                  pred-genus: Crudia (0.926)
02 name:S_catatumbus_max2_M120_V24_4_Airyscan Processing_mz.png                  pred-genus: Isoberlinia (0.723)
03 name:S_catatumbus_max2_M128_J49_1_Airyscan Processing_mz.png                  pred-genus: Crudia (0.440)
04 name:S_catatumbus_max2_M129_R55_4_Airyscan Processing_mz.png                  pred-genus: Crudia (0.988)
05 name:S_catatumbus_max2_M129_S51_4_Airyscan Processing_mz.png                  pred-genus: Crudia (0.951)
06 name:S_catatumbus_max2_M50_W31_1_Airyscan Processing_mz.png           pred-genus: Berlinia (0.877)
%}

