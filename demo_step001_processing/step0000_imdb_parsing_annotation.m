clear;
close all;
clc;
%#filename = 'excel_file_African_striatopollis.csv';
%#fn = fopen(filename);
%#tline = fgets(fn);
%#lineCount = 0;

imdb.genus = {};
imdb.specie= {};
imdb.geographicalDistribution = {};
imdb.folderName = {};
imdb.filename = {};


imgList = dir('S_catatumbus_eocene_SA_selected/');
for i = 1:size(imgList)
	if size(imgList(i).name)<3
	continue;
	end
    imdb.genus{end+1} = 'void';
    imdb.specie{end+1} = 'void';
    imdb.geographicalDistribution{end+1} = 'void';
    imdb.folderName{end+1} = 'void';
    imdb.filename{end+1} = imgList(i).name;
end




save('imdb_dataset_part3_by_Ingrid.mat', 'imdb');
