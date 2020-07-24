%
% load in a biofrmats tiff and translate 
% results into 4D array
%

% filename ='../wfheart_01_22_17/2017-01-17_MI-MWA4_whole-heart_ventral_5X_copy_Stitch.czi'

function J = bfread(filename)

addpath bfmatlab/
[I,omeMeta] = bfopen_array(filename);


% stack dimension
sizeX = omeMeta.getPixelsSizeX(0).getValue(); % image width, pixels
sizeY = omeMeta.getPixelsSizeY(0).getValue(); % image height, pixels
sizeZ = omeMeta.getPixelsSizeZ(0).getValue(); % number of Z slices
sizeC = omeMeta.getPixelsSizeC(0).getValue(); % number of channels
sizeT = omeMeta.getPixelsSizeT(0).getValue(); % number of time points
fprintf(1,'Loaded %d x %d x %d with %d channels\n',sizeY,sizeX,sizeZ,sizeC);

% in µm
% TODO: need to check if field exists or else this gives an error
%voxelSizeX = omeMeta.getPixelsPhysicalSizeX(0).value(ome.units.UNITS.MICROMETER).doubleValue(); 
%voxelSizeY = omeMeta.getPixelsPhysicalSizeY(0).value(ome.units.UNITS.MICROMETER).doubleValue(); 
%voxelSizeZ = omeMeta.getPixelsPhysicalSizeZ(0).value(ome.units.UNITS.MICROMETER).doubleValue(); 
%fprintf(1,'Voxel Sizes %3.3f x %3.3f x %3.3f\n',voxelSizeX,voxelSizeY,voxelSizeZ);


if (sizeT ~= 1)
  error('timepoints not implemented');
end

%
% reshape 
%
J = zeros(sizeY,sizeX,sizeZ,sizeC,'single');
for c = 1:sizeC
  J(:,:,:,c) = I(:,:,c:sizeC:end);
end

J = permute(J,[1 2 4 3]);


