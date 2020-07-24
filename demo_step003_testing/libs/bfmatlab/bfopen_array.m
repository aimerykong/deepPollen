function [arr,metadata] = bfopen_array(id, varargin)

% Toggle the autoloadBioFormats flag to control automatic loading
% of the Bio-Formats library using the javaaddpath command.
autoloadBioFormats = 1;

% Toggle the stitchFiles flag to control grouping of similarly
% named files into a single dataset based on file numbering.
stitchFiles = 0;

% load the Bio-Formats library into the MATLAB environment
status = bfCheckJavaPath(autoloadBioFormats);
assert(status, ['Missing Bio-Formats library. Either add bioformats_package.jar '...
    'to the static Java path or add it to the Matlab path.']);

% Initialize logging
bfInitLogging();

% Get the channel filler
r = bfGetReader(id, stitchFiles);

% Test plane size
if nargin >=4
    planeSize = javaMethod('getPlaneSize', 'loci.formats.FormatTools', ...
                           r, varargin{3}, varargin{4});
else
    planeSize = javaMethod('getPlaneSize', 'loci.formats.FormatTools', r);
end

if planeSize/(1024)^3 >= 2,
    error(['Image plane too large. Only 2GB of data can be extracted '...
        'at one time. You can workaround the problem by opening '...
        'the plane in tiles.']);
end

numSeries = r.getSeriesCount();

if (numSeries > 1)
  error('this code only handles single series');
else
  s = 1;
end

fprintf('Reading series #%d', s);
r.setSeries(s - 1);
metadata = r.getMetadataStore();

pixelType = r.getPixelType();
bpp = javaMethod('getBytesPerPixel', 'loci.formats.FormatTools', pixelType);
bppMax = power(2, bpp * 8);

sizeX = metadata.getPixelsSizeX(0).getValue(); % image width, pixels
sizeY = metadata.getPixelsSizeY(0).getValue(); % image height, pixels
sizeZ = metadata.getPixelsSizeZ(0).getValue(); % number of Z slices
sizeC = metadata.getPixelsSizeC(0).getValue(); % number of channels
sizeT = metadata.getPixelsSizeT(0).getValue(); % number of time points

fprintf(1,'\nallocating single array %d %d %d %d\n',sizeY,sizeX,sizeZ,sizeC);
arr = zeros(sizeY,sizeX,sizeZ,sizeC,'single'); 
%whos arr

if (r.getImageCount() ~= sizeZ*sizeC)
  fprintf(1,'imagecount=%d\n',r.getImageCount());
  fprintf(1,'sizeT=%d (should be 1)\n',sizeT);
  error('image count doesnt match expected metadata'); 
end

ct = 1;
tt = 0;
tic
for i = 1:sizeZ
  fprintf('\rloading z-plane:  %d / %d   (%2.2f sec/plane)   ',i,sizeZ,tt/(i-1));
  for c = 1:sizeC
    arr(:,:,i,c) = single(bfGetPlane(r, ct, varargin{:}))/bppMax;
    ct = ct + 1;
  end
  tt = toc;
end
fprintf('\n');
fprintf('read in %2.2f seconds  (%2.2f seconds/plane)',tt,tt/sizeZ);
r.close();
