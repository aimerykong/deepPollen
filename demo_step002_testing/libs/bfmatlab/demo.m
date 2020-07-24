clc;
% addpath(genpath('./toolbox'))
addpath(genpath('./toolbox/bfmatlab'))
javaaddpath('/home/skong2/dataset/pollen_catatumbus/pollen_gan/toolbox/bfmatlab/bioformats_package.jar')

% addpath(fullfile(prefdir,'bfmatlab'));
% addpath(fullfile('./bfmatlab'));

% javaaddpath('/home/skong2/dataset/pollen_catatumbus/pollen_gan/bfmatlab/bioformats_package.jar')
% javaclasspath('/home/skong2/dataset/pollen_catatumbus/pollen_gan/bfmatlab/')




% dpath = {'/home/skong2/dataset/pollen_catatumbus/pollen_gan/bfmatlab/bioformats_package.jar'};
% javaclasspath('-v1')
% javaclasspath(dpath)

javaclasspath()

infile = '../Neochevalierodendron/Neochevalierodendron_stephanii01.czi';
[I,omeMeta] = bfopen_array(infile);

data = bfopen(infile);
% basepath = '../Neochevalierodendron';
% outpath = './cmax/'
% f = 1;
% 
% files = dir([basepath '/*.czi']);
% fname = files(f).name;
% infile = fullfile(basepath, fname);
% [I,omeMeta] = bfopen_array(infile);
% [h,w,z] = size(I);
% fprintf('%s  -  [%d x %d x %d]\n',fname,h,w,z);
% my = squeeze(max(I,[],1));
% mx = squeeze(max(I,[],2));
% mz = max(I,[],3);
% maxval = max(mx(:));
% mx = mx / maxval;
% my = my / maxval;
% mz = mz / maxval;
% outfile = [outpath fname(1:end-4)];

% D = dir(basepath)
% for d = 3:length(D)
%     subdir = '.';
% %   subdir = [basepath D(d).name '/'];
%   files = dir([basepath '/*.czi']);
%   for f = 1:length(files)
%     fname = files(f).name;
%     infile = [subdir fname];
%     [I,omeMeta] = bfopen_array(infile);
%     [h,w,z] = size(I);
%     fprintf('%s  -  [%d x %d x %d]\n',fname,h,w,z);
%     my = squeeze(max(I,[],1));
%     mx = squeeze(max(I,[],2));
%     mz = max(I,[],3);
%     maxval = max(mx(:));
%     mx = mx / maxval;
%     my = my / maxval;
%     mz = mz / maxval;
%     outfile = [outpath fname(1:end-4)];
%     imwrite(mx,[outfile '_mx.jpg'],'jpg','Quality',99);
%     imwrite(my,[outfile '_my.jpg'],'jpg','Quality',99);
%     imwrite(mz,[outfile '_mz.jpg'],'jpg','Quality',99);
%   end
% end
%
%
% basepath = '/scratch2/fowlkes/pollen/bombacaceae/'
% outpath = '/scratch2/fowlkes/pollen/bmax/'
% D = dir(basepath)
% for d = 3:length(D)
%   subdir = [basepath D(d).name '/'];
%   files = dir([subdir '*.czi']);
%   for f = 1:length(files)
%     fname = files(f).name;
%     infile = [subdir fname];
%     [I,omeMeta] = bfopen_array(infile);
%     [h,w,z] = size(I);
%     fprintf('%s  -  [%d x %d x %d]\n',fname,h,w,z);
%     my = squeeze(max(I,[],1));
%     mx = squeeze(max(I,[],2));
%     mz = max(I,[],3);
%     maxval = max(mx(:));
%     mx = mx / maxval;
%     my = my / maxval;
%     mz = mz / maxval;
%     outfile = [outpath fname(1:end-4)];
%     imwrite(mx,[outfile '_mx.jpg'],'jpg','Quality',99);
%     imwrite(my,[outfile '_my.jpg'],'jpg','Quality',99);
%     imwrite(mz,[outfile '_mz.jpg'],'jpg','Quality',99);
%   end
% end
%
%
% % d6 : removed : Bombax/Bombax_castatum02.czi
% % d20 : removed : Neobuchia/Neobuchia_pailinae09_Maximum_intensity_projection.czi
% % d23 : removed : Patinoa_almirajo02czi_Maximum_intensity_projection.czi
% dlist = [6 20 23];
% for di = 1:3
%   d = dlist(di)
%   subdir = [basepath D(d).name '/'];
%   files = dir([subdir '*.czi']);
%   for f = 1:length(files)
%     fname = files(f).name;
%     infile = [subdir fname];
%     [I,omeMeta] = bfopen_array(infile);
%     [h,w,z] = size(I);
%     fprintf('%s  -  [%d x %d x %d]\n',fname,h,w,z);
%     my = squeeze(max(I,[],1));
%     mx = squeeze(max(I,[],2));
%     mz = max(I,[],3);
%     maxval = max(mx(:));
%     mx = mx / maxval;
%     my = my / maxval;
%     mz = mz / maxval;
%     outfile = [outpath fname(1:end-4)];
%     imwrite(mx,[outfile '_mx.jpg'],'jpg','Quality',99);
%     imwrite(my,[outfile '_my.jpg'],'jpg','Quality',99);
%     imwrite(mz,[outfile '_mz.jpg'],'jpg','Quality',99);
%   end
% end





