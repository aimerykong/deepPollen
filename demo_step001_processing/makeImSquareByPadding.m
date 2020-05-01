function im = makeImSquareByPadding(im, sz)
%
% Padding the image boundary with zero values -- the image is centered in
% the new (bigger) image.
%
% Shu Kong
% 04/29/2015

if ~exist('sz', 'var')
    sz = max(size(im));
    sz = [sz, sz];
end

A = zeros(sz(1), sz(2));
c = sz/2;
A(  round(c(1)-size(im,1)/2)+1:round(c(1)+size(im,1)/2), round(c(2)-size(im,2)/2)+1:round(c(2)+size(im,2)/2) ) = im;
im = A;

%{
sz = size(im);
if sz(1) > sz(2)
    im = [ zeros(size(im,1), floor((sz(1)-sz(2))/2)), ...
                    im, ...
                    zeros(size(im,1), ceil((sz(1)-sz(2))/2)) ];
                
elseif sz(2)>sz(1)
    im = [ zeros( floor((sz(2)-sz(1))/2),  size(im,2)); ...
                    im; ...
                    zeros( ceil((sz(2)-sz(1))/2), size(im,2)) ];
else

end
%}

