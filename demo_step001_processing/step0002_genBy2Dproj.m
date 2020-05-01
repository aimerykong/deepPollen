clear
close all;
clc;

addpath(genpath('../pollen_gan/toolbox/bfmatlab'))
addpath('../pollen_gan/')
javaaddpath('/home/skong2/restore/dataset/pollen_catatumbus/pollen_gan/toolbox/bfmatlab/bioformats_package.jar')


load imdb_valid_dataset_part3_by_Ingrid.mat

basepath = '/home/skong2/restore/dataset/pollen_catatumbus/dataset_part3_by_Ingrid';
outpath = '/home/skong2/restore/dataset/pollen_catatumbus/dataset_part3_by_Ingrid/cmax_smart';
if ~isdir(outpath)
    mkdir(outpath);
end
%%
%{
i = 11;
%path_to_file = 'nigeria_Ozuitem6_slide2_striatopollis02.czi';
path_to_file = fullfile(imdb.path, imdb.folderName{i}, [imdb.filename{i},'.czi']);
[I,omeMeta] = bfopen_array(path_to_file);
[h,w,z] = size(I);
%fprintf('%s  -  [%d x %d x %d]\n',imdb.filename{i},h,w,z);
my = squeeze(max(I,[],1));
mx = squeeze(max(I,[],2));
mz = max(I,[],3);
maxval = max(mx(:));
mx = mx / maxval;
my = my / maxval;
mz = mz / maxval;

subfolder = imdb.folderName{i};
if ~isdir(fullfile(outpath,subfolder))
    mkdir(fullfile(outpath,subfolder));
end
outfile = fullfile(outpath, subfolder, imdb.filename{i});
imwrite(mx,[outfile '_mx.png']); 
imwrite(my,[outfile '_my.png']); 
imwrite(mz,[outfile '_mz.png']); 
%}
%%
stackSize = 15;
stepSize = 10;
for i = 1:length(imdb.folderName)    
    subfolder = imdb.folderName{i};
    if ~isdir(fullfile(outpath,subfolder))
        mkdir(fullfile(outpath,subfolder));
    end
    
    path_to_file = fullfile(imdb.path, imdb.folderName{i}, [imdb.filename{i},'.czi']);
    [I,omeMeta] = bfopen_array(path_to_file);
    [h,w,z] = size(I); 
    fprintf('%s  -  [%d x %d x %d]\n',imdb.filename{i},h,w,z);
    my = squeeze(max(I,[],1));
    mx = squeeze(max(I,[],2));
    mz = max(I,[],3);
    maxval = max(mx(:));
    mx = mx / maxval;
    my = my / maxval;
    mz = mz / maxval;    
    outfile = fullfile(outpath, subfolder, imdb.filename{i});
    imwrite(mx,[outfile '_mx.png']); 
    imwrite(my,[outfile '_my.png']); 
    imwrite(mz,[outfile '_mz.png']); 
    
    for jj = 1:stepSize:size(I,3)-stackSize
        mz = max(I(:,:,jj:jj+stackSize),[],3); mz = mz / maxval; %imagesc(mz); axis off image; colormap(gray);
        imwrite(mz,[outfile sprintf('_mz_%03d.png',jj)]);
    end        
end
