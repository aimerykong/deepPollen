clear
close all;
clc;

load imdb_dataset_part3_by_Ingrid.mat;
imdb.path = '/home/skong2/restore/dataset/pollen_catatumbus/dataset_part3_by_Ingrid/';

%% modify the naming
for i = 1:length(imdb.genus)
    imdb.genus{i} = 'unknown';
    imdb.specie{i} = 'unknown';
    imdb.folderName{i} = 'S_catatumbus_eocene_SA_selected/';
    curfilename = imdb.filename{i} ;
    [path,curfilename,ext] =fileparts(curfilename);
    imdb.filename{i} = curfilename;
end



%{
for i = 1:7
    imdb.filename{i} = strrep(imdb.filename{i}, 'Anothonatha', 'Anthonotha');
end
for i = 87:96
    imdb.filename{i} = strrep(imdb.filename{i}, 'blancoi', 'blancoi_');
end
imdb.genus = [imdb.genus(1:126), imdb.genus(128:length(imdb.genus))];
imdb.specie = [imdb.specie(1:126), imdb.specie(128:length(imdb.specie))];
imdb.geographicalDistribution = [imdb.geographicalDistribution(1:126), imdb.geographicalDistribution(128:length(imdb.geographicalDistribution))];
imdb.folderName = [imdb.folderName(1:126), imdb.folderName(128:length(imdb.folderName))];
imdb.filename = [imdb.filename(1:126), imdb.filename(128:length(imdb.filename))];

for i = 0244:0249
    imdb.filename{i} = strrep(imdb.filename{i}, 'macrolobium_', 'Macrolobium_');
end
imdb.filename{257} = strrep(imdb.filename{257}, 'angustifolium08', 'angustifolium_08');
imdb.filename{318} = strrep(imdb.filename{318}, 'Macrolobium_ischnocalyx08', 'Macrolobium_ischnocalyx08.');

for i = 341:342
    imdb.filename{i} = strrep(imdb.filename{i}, 'costaricense', 'costaricense_');
end
for i = 0351:0360
    imdb.filename{i} = strrep(imdb.filename{i}, 'colombianum', 'columbianum');
end
for i = 0379:0388
    imdb.folderName{i} = strrep(imdb.folderName{i}, 'Gilbertiodendron', 'Gilbertodendron');
end
for i = 0479:0482
    imdb.filename{i} = strrep(imdb.filename{i}, 'S.catatumbus_SA_Llanos', 'S_catatumbus__SA_Llanos');
end

%% traverse to double check
for i = 1:length(imdb.folderName)    
    path_to_file = fullfile(imdb.path, imdb.folderName{i}, [imdb.filename{i},'.czi']);
    if exist(path_to_file, 'file')~=2
        fprintf('%04d %s\n', i, path_to_file);
    end
end
%}
save('imdb_valid_dataset_part2_by_Ingrid.mat', 'imdb')
%% leaving blank
%{
/home/skong2/dataset/pollen_catatumbus/dataset/Crudia/Crudia_blancoi01.czi
/home/skong2/dataset/pollen_catatumbus/dataset/Crudia/Crudia_blancoi_01.czi
%}
