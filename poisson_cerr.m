 function data = poisson_cerr(xm, seed, varargin)
%|function data = poisson_cerr(xm, seed, [options]) 
%| 
%| option
%|	'factor'	see poisson2_cerr.m
%|
%| Generate Poisson random vector with mean xm.
%| For small, use poisson1_cerr.m
%| For large, use poisson2_cerr.m
%| see num. rec. C, P. 222
%|
%| From the Image Reconstruction Tool Box (irt) 
%| http://web.eecs.umich.edu/~fessler/code/
%| Modified for use in CERR, CRS
%|
%| Copyright 1997-4-29, Jeff Fessler, University of Michigan

if nargin < 1, help(mfilename), error(mfilename), end
if nargin == 1 & streq_cerr(xm, 'test'), poisson_test_cerr, return, end

if ~isvar_cerr('seed')
	seed = [];
end

arg.factor = 0.85;
arg = vararg_pair_cerr(arg, varargin);

data	= xm;
xm	= xm(:);

small = xm < 12;
data( small) = poisson1_cerr(xm( small), seed);
data(~small) = poisson2_cerr(xm(~small), 'seed', seed, 'factor', arg.factor);


%
% poisson_test_cerr()
% run a timing race against matlab's poissrnd
%
function poisson_test_cerr
n = 2^8;
t = reshape(linspace(1, 1000, n^2), n, n);
cpu etic
poisson_cerr(t);
cpu etoc 'fessler poisson time'
if exist('poissrnd') == 2
	cpu etic
	poissrnd(t);
	cpu etoc 'matlab poissrnd time'
else
	warn 'matlab poissrnd unavailable'
end

if 0 % look for bad values?
	poisson_cerr(10^6 * ones(n,n));
	poisson_cerr(1e-6 * ones(n,n));
	poisson_cerr(linspace(11,13,2^10+1));
	poisson_cerr(linspace(12700,91800,n^3));
end
