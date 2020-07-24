clear;
close all;
clc;
filename = 'excel_file_African_striatopollis.csv';
fn = fopen(filename);
tline = fgets(fn);
lineCount = 0;

imdb.genus = {};
imdb.specie= {};
imdb.geographicalDistribution = {};
imdb.folderName = {};
imdb.filename = {};

while ischar(tline)    
    A = strsplit(tline, ',');
    imdb.genus{end+1} = strtrim(A{1});
    imdb.specie{end+1} = strtrim(A{2});
    imdb.geographicalDistribution{end+1} = strtrim(A{3});
    imdb.folderName{end+1} = strtrim(A{end-1}); 
    imdb.filename{end+1} = strtrim(A{end});
    
    lineCount = lineCount+1;
    tline = fgets(fn);
end
fclose(fn);

imdb.filename = imdb.filename(1:11);
imdb.folderName = imdb.folderName(1:11);
imdb.geographicalDistribution = imdb.geographicalDistribution(1:11);
imdb.specie = imdb.specie(1:11);
imdb.genus = imdb.genus(1:11);

save('imdb_dataset_part2_by_Ingrid.mat', 'imdb');