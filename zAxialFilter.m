function [IM] = zAxialFilter(IM,zFilter);

%"zAxialFilter"
%   Axially filters PET-like images via 3-Point Smoothing
%
% CRS, 08/01/2013
%
%Usage: 
%   [IM] = zAxialFilter(IM,zFilter)
%       IM   = image data
%       zFilter = axial post filter 3-point smoothing
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
%% Axial 3-Point Smoothing images

if (length(zFilter) ~= 3)
    return;
end
zFilter = zFilter/sum(zFilter);

zSlice = size(IM,3);

tmpIM = IM;
if (size(IM,4) == 1)
    for k = 2:zSlice-1
        tmpIM(:,:,k) = zFilter(1)*IM(:,:,k-1) + zFilter(2)*IM(:,:,k) + zFilter(3)*IM(:,:,k+1);
    end
    tmpIM(:,:,1)   =  (zFilter(1)/2+zFilter(2))*IM(:,:,1)     + (zFilter(1)/2+zFilter(3))*IM(:,:,2);
    tmpIM(:,:,end) =  (zFilter(3)/2+zFilter(1))*IM(:,:,end-1) + (zFilter(3)/2+zFilter(2))*IM(:,:,end);
else
    for j = 1:size(IM,4)
    for k = 2:zSlice-1
        tmpIM(:,:,k,j) = zFilter(1)*IM(:,:,k-1,j) + zFilter(2)*IM(:,:,k,j) + zFilter(3)*IM(:,:,k+1,j);
    end
    tmpIM(:,:,1,j)   =  (zFilter(1)/2+zFilter(2))*IM(:,:,1,j)     + (zFilter(1)/2+zFilter(3))*IM(:,:,2,j);
    tmpIM(:,:,end,j) =  (zFilter(3)/2+zFilter(1))*IM(:,:,end-1,j) + (zFilter(3)/2+zFilter(2))*IM(:,:,end,j);
end
IM = tmpIM;

end