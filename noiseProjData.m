function [nFWPTtotal,nFWPTtrue,nFWPTscatter,nFWPTrandoms,countsNoise] = ...
    noiseProjData(FWPTtrue,FWPTscatter,FWPTrandoms)
%"noiseProjData"
%   Builds noised PET projection data
%
% CRS, 08/01/2013
%
%Usage: 
%   [nFWPTtotal,nFWPTtrue,nFWPTscatter,nFWPTrandoms,countsNoise] = noiseProjData(FWPTtrue,FWPTscatter,FWPTrandoms)
%       FWPTtrue    = True    counts projection data
%       FWPTscatter = Scatter counts projection data
%       FWPTrandoms = Randoms counts projection data
%
% Copyright 2010, Joseph O. Deasy, on behalf of the CERR development team.
% 
% This file is part of The Computational Environment for Radiotherapy Research (CERR).
% 
% CERR development has been led by:  Aditya Apte, Divya Khullar, James Alaly, and Joseph O. Deasy.
% 
% CERR has been financially supported by the US National Institutes of Health under multiple grants.
% 
% CERR is distributed under the terms of the Lesser GNU Public License. 
% 
%     This version of CERR is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
% CERR is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
% See the GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with CERR.  If not, see <http://www.gnu.org/licenses/>.%
%
%% Builds noised data 

FWPTtotal   = FWPTtrue + FWPTscatter + FWPTrandoms;

statPack = exist('poissrnd','file');
if (statPack == 2)
    nFWPTtotal   = poissrnd(FWPTtotal);
    nFWPTtrue    = poissrnd(FWPTtrue);
    nFWPTscatter = poissrnd(FWPTscatter);
    nFWPTrandoms = poissrnd(FWPTrandoms);
else
    jeffPack = exist('poisson_cerr','file');
    if (jeffPack == 2)
        nFWPTtotal   = poisson_cerr(FWPTtotal);
        nFWPTtrue    = poisson_cerr(FWPTtrue);
        nFWPTscatter = poisson_cerr(FWPTscatter);
        nFWPTrandoms = poisson_cerr(FWPTrandoms);
    else
        fprintf('\nError:\tYou must either have the Matlab statistical toolbox or \n');
        fprintf('\tthe Image Reconstruction Toolbox (irt) from Jeff Fessler.\n');
        fprintf('\tAvalable at: http://web.eecs.umich.edu/~fessler/code/\n');
        fprintf('\tRequired files:\t caller_name.m\n\t\t\t col.m\n');
        fprintf('\t\t\t isvar.m\n \t\t\t poisson.m\n \t\t\t poisson0.m\n');
        fprintf('\t\t\t poisson1.m\n \t\t\t poisson2.m\n \t\t\t poisson2unif.m\n');
        fprintf('\t\t\t streq.m\n \t\t\t vararg_pair.m\n\n ');
        error('ERROR: !!! NO POISSON RANDOM GENERATOR !!!');
    end
end
nFWPTtotal(nFWPTtotal     < 0) = 0;
nFWPTtrue(nFWPTtrue       < 0) = 0;
nFWPTscatter(nFWPTscatter < 0) = 0;
nFWPTrandoms(nFWPTrandoms < 0) = 0;

% nFWPTtotal   = nFWPTtrue + nFWPTscatter + nFWPTrandoms;

countsNoise.total   = sum( nFWPTtotal(:)   );
countsNoise.true    = sum( nFWPTtrue(:)    );
countsNoise.scatter = sum( nFWPTscatter(:) );
countsNoise.randoms = sum( nFWPTrandoms(:) );
countsNoise.NEC     = countsNoise.true^2 / countsNoise.total;

return