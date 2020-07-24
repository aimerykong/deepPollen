clear
close all;
clc;

load imdb_dataset_part2_by_Ingrid.mat;
imdb.path = '/home/skong2/restore/dataset/pollen_catatumbus/dataset_part2_by_Ingrid/';

%% modify the naming
for i = 1:length(imdb.genus)
    imdb.genus{i} = 'Nigeria';
    imdb.specie{i} = 'Striatopollis';
    imdb.folderName{i} = 'AfricanNigeria';
    curfilename = imdb.filename{i} ;
    [path,curfilename,ext] =fileparts(curfilename);
    imdb.filename{i} = curfilename;
end

save('imdb_valid_dataset_part2_by_Ingrid.mat', 'imdb')
%% leaving blank
%{
/home/skong2/dataset/pollen_catatumbus/dataset/Crudia/Crudia_blancoi01.czi
/home/skong2/dataset/pollen_catatumbus/dataset/Crudia/Crudia_blancoi_01.czi
%}