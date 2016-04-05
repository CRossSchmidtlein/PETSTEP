 function data = poisson0_cerr(xm)
%function data = poisson0_cerr(xm)
%	generate poisson random vector with mean xm
%	brute force by summing exponentials - dumb loops
%
%| From the Image Reconstruction Tool Box (irt) 
%| http://web.eecs.umich.edu/~fessler/code/
%| Modified for use in CERR, CRS
%|
%| Copyright 1997-4-29, Jeff Fessler, University of Michigan

	for ii=1:length(xm)
		g = exp(-xm);
		data(ii) = 0;
		t = rand(1,1);
		while t > g
			t = t * rand(1,1);
			data(ii) = data(ii) + 1;
		end
	end
