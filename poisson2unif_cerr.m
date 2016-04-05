function [uu] = poisson2unif_cerr(count, lambda)

%	function [uu] = poisson2unif_cerr(count, lambda)
%	INPUT:
%		count: [Nx1]	measured counts
%		lambda: [Nx1]	hypothesized means
%	OUTPUT:
%		uu: [Nx1]	uniform numbers
%	see veklerov and llacer 1987
%
%| From the Image Reconstruction Tool Box (irt) 
%| http://web.eecs.umich.edu/~fessler/code/
%| Modified for use in CERR, CRS
%|
%| Copyright 1997-4-29, Jeff Fessler, University of Michigan

	[s0, d] = p_poisson_cerr(count, lambda);

	rand('uniform')
	uu = s0 + d .* rand(nrow(count), ncol(count));
