function [IM] = xyPostFilter(IM,POST);

%"zAxialFilter"
%   Gaussian filters PET-like images via 2D-Kernel
%
% CRS, 08/01/2013
%
%Usage: 
%   [IM] = zAxialFilter(IM,zFilter)
%       IM   = image data
%       POST = 2D-Gaussian Filter
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
%% 2D-Gaussian Filter

if (numel(POST) < 3)
    return;
end
POST = POST/sum(POST(:));

zSlice = size(IM,3);

if (size(IM,4) == 1)
    for k = 1:zSlice
        IM(:,:,k) = imfilter(IM(:,:,k),POST,'replicate','same','conv');
    end
else
    for j = 1:size(IM,4)
        for k = 1:zSlice
            IM(:,:,k,j) = imfilter(IM(:,:,k,j),POST,'replicate','same','conv');
        end
    end
end

end