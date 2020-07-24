clear; close all; clc;

matView1 = load('./result/fossilPart2_view1_main002_cls_baseline_v3_wholeNet_512dim_softmax_net-epoch-48.mat');
matView2 = load('./result/fossilPart2_view2_main003_cls_MIL4View2_v4_aboveRes4_512dim_ftEpoch48_softmax_net-epoch-104.mat');
matView12 = load('./result/fossilPart2_view12_main006_clsTwoViews_v1_aboveRes4_sumConf_softmax_net-epoch-19.mat');

for i = 1:size(matView1.confMat,2)
    tokens = strsplit(matView1.txtLine{i}, ' ');
    conf = matView1.confMat(:,i);
    [conf, predLabel] = max(conf);
    fprintf('%s (%.3f)\n',tokens{end}, conf);    
end


for i = 1:size(matView2.confMat,2)
    tokens = strsplit(matView2.txtLine{i}, ' ');
    conf = matView2.confMat(:,i);
    [conf, predLabel] = max(conf);
    fprintf('%s (%.3f)\n',tokens{end}, conf);    
end


for i = 1:size(matView12.confMat,2)
    tokens = strsplit(matView12.txtLine{i}, ' ');
    conf = matView12.confMat(:,i)/2;
    [conf, predLabel] = max(conf);
    fprintf('%s (%.3f)\n',tokens{end}, conf);    
end

for i = 1:size(matView12.confMat,2)
    tokens = strsplit(matView2.txtLine{i}, ' ');
    name = strfind(tokens{2},':');
    name = tokens{2}(name+1:end);
    [~,name ,~] = fileparts(name);
    fprintf('%02d %s\n', i, name);
end