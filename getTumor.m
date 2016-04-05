function [tumorPT,tumorCT,rtsPT,rtsCT,zSlices] = getTumor(PT,PTscanNum_old,CT,vox,minRegionSize)
%"getTumor"
%   converts RT-structures to tumors for synthetic lesions
%
% CRS, 08/01/2013
%
%Usage: 
%   [tumorPT,tumorCT,rtsPT,rtsCT,zSlices] = getTumor(PTscanNum,CTscanNum,minRegionSize)
%       PTscanNum     = PET scan number in CERR
%       CTscanNum     =  CT scan number in CERR
%       minRegionSize = smallest allowable 3D RT-structure
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
%% Get Tumor 
global stateS planC
indexS = planC{end};

% Get Structures and define PET tumor
sumMaskPT = [];
numStr  = length(planC{indexS.structures});
if (numStr >= 1)
    RTSname = lower({planC{indexS.structures}.structureName});
    % Get slices
    RTSname{:,:}
    sumMaskPT = zeros(vox.pet.nxn);
    for structNum = 1:numStr
        uSlices = []; maskRTS = []; maskRTStmp = [];
        [rasterSeg, planC, isError] = getRasterSegments(structNum,planC);
        if isempty(rasterSeg)
            warning('Could not create conotour.')
            fprintf('\tInvalid Structure: %d ... \n',structNum);
            continue
            %         return
        end
        [maskRTStmp, uSlices] = rasterToMask(rasterSeg, PTscanNum_old, planC);
        maskRTS = double(maskRTStmp);
        maskRTS = bwareaopen(maskRTS,minRegionSize,6); % remove stray contour fragments
        
        if (structNum == 1)
            sumMaskPT(:,:,uSlices) = maskRTS;
        else
            sumMaskPT(:,:,uSlices) = sumMaskPT(:,:,uSlices) + maskRTS;
        end
        
        if (structNum == 1)
            minSlice = uSlices(1);
            maxSlice = uSlices(end);
        else
            if (minSlice > uSlices(1)),   minSlice = uSlices(1);   end
            if (maxSlice < uSlices(end)), maxSlice = uSlices(end); end
        end
    end
    if (minSlice > 2)
        minSlice = minSlice - 2;
    else
        minSlice = 1;
    end
    if (maxSlice + 2 < vox.pet.nxn(3))
        maxSlice = maxSlice + 2;
    else
        maxSlice = vox.pet.nxn(3);
    end
    zSlices = minSlice:maxSlice;
    tumorPT = sumMaskPT(:,:,zSlices);
else
    zSlices = 1:vox.pet.nxn(3);
    tumorPT = zeros(vox.pet.nxn);
end
rtsPT = PT(:,:,zSlices);

% Get CT tumor
% loads PT tumor masks and upsacles to CT voxel size
for i = 1:length(zSlices)
    tumorCTtmp(:,:,i) = imresize(tumorPT(:,:,i),vox.pet.xyz(1)/vox.ct.xyz(1),'cubic');
end
tumorCTtmp(tumorCTtmp < 0.05) = 0;

tumorCT = zeros([ vox.ct.nxn(1:2) length(zSlices) ]);
if ( size(tumorCTtmp,1) > vox.ct.nxn(1) )
    xA = round(( size(tumorCTtmp,2) - vox.ct.nxn(2) )/2) + 1;
    xB = xA + vox.ct.nxn(2) - 1;
    yA = round(( size(tumorCTtmp,1) - vox.ct.nxn(1) )/2) + 1;
    yB = yA + vox.ct.nxn(1) - 1;
    tumorCT = tumorCTtmp(yA:yB,xA:xB,:);
else
    xA = round(( vox.ct.nxn(2) - size(tumorCTtmp,2) )/2) + 1;
    xB = xA + size(tumorCTtmp,2) - 1;
    yA = round(( vox.ct.nxn(1) - size(tumorCTtmp,1) )/2) + 1;
    yB = yA + size(tumorCTtmp,1) - 1;
    tumorCT(yA:yB,xA:xB,:) = tumorCTtmp;
end

rtsCT = (CT(:,:,zSlices)+1000)/1000;

end
