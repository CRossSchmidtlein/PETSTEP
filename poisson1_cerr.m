  function data = poisson1_cerr(xmean, seed)
%|function data = poisson1_cerr(xmean, seed)
%| Generate poisson random column vector with mean xmean
%| by summing exponentials.
%| This is efficient only for small mean values, eg < 20.
%|
%| From the Image Reconstruction Tool Box (irt) 
%| http://web.eecs.umich.edu/~fessler/code/
%| Modified for use in CERR, CRS
%|
%| Copyright 1997-4-29, Jeff Fessler, University of Michigan


if nargin < 1, help(mfilename), error(mfilename), end

if isvar_cerr('seed') & ~isempty(seed)
	rand('state', seed)
end

dim = size(xmean);

data = zeros(dim);
i_do = ones(dim);
ee = exp(xmean);

while any(i_do(:))
	i_do = ee >= 1;
	data(i_do) = 1 + data(i_do);
	ee = ee .* rand(dim) .* i_do;
end

data = data - 1;
