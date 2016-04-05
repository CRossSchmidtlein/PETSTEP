function getSimImages(refScanNum,newImage,newImageName,zSlices,UpDate)
%"getSimImages"
%   Inserts PET and CT images w/ tumors into CERR
%
% APA, CRS, 08/01/2013
%
%Usage: 
%   getSimImages(refScanNum,newImage,newImageName,zRange,UpDate)
%       refScanNum   = reference images for insertion
%       newImage     = images to be inerted
%       newImageName = name of image set
%       zSlices      =  image slice range
%       UpDate       = updates viewer
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
%% Adds images to CERR
global stateS planC;
indexS = planC{end};

[xVals, yVals, zVals] = getScanXYZVals(planC{indexS.scan}(refScanNum));
newXgrid = linspace(min(xVals),max(xVals),size(newImage,1));
newYgrid = linspace(min(yVals),max(yVals),size(newImage,2));
newZgrid = linspace(min(zVals(zSlices)),max(zVals(zSlices)),numel(zSlices));

newScanNum = length(planC{indexS.scan}) + 1;
newScanS = initializeCERR('scan');
newScanS(1).scanArray = newImage;
newScanS(1).scanType  = newImageName;
newScanS(1).scanUID = createUID('scan');
newScanS(1).transM = planC{indexS.scan}(refScanNum).transM;
scanInfoS = planC{indexS.scan}(refScanNum).scanInfo(1);
scanInfoS.grid1Units = abs(newYgrid(1)-newYgrid(2));
scanInfoS.grid2Units = abs(newXgrid(1)-newXgrid(2));
scanInfoS.scanFileName = '';
scanInfoS.DICOMHeaders = '';
scanInfoS.sliceThickness =  abs(newZgrid(1)-newZgrid(2));
scanInfoS.voxelThickness =  abs(newZgrid(1)-newZgrid(2));
scanInfoS.sizeOfDimension1 = size(newImage,1);
scanInfoS.sizeOfDimension2 = size(newImage,2);
% removes CT offset for PT and mu images
if ( (max(newImage(:)) < 300) && (min(newImage(:)) > -800) )
    scanInfoS.CTOffset = 0;
end

for sInfoNum = 1:length(newZgrid)
    scanInfoNewS = scanInfoS;
    scanInfoNewS.zValue = newZgrid(sInfoNum);
    newScanS(1).scanInfo(sInfoNum) = scanInfoNewS;
end
planC{indexS.scan} = dissimilarInsert(planC{indexS.scan},newScanS,newScanNum);
planC = setUniformizedData(planC);

% Save scan statistics for fast image rendering
colorMapIndex = get(stateS.handle.BaseCMap,'value');
for scanNum = 1:length(planC{indexS.scan})
    scanUID = ['c',repSpaceHyp(planC{indexS.scan}(scanNum).scanUID(max(1,end-61):end))];
    stateS.scanStats.minScanVal.(scanUID) = single(min(planC{indexS.scan}(scanNum).scanArray(:)));
    stateS.scanStats.maxScanVal.(scanUID) = single(max(planC{indexS.scan}(scanNum).scanArray(:)));
    stateS.scanStats.CTLevel.(scanUID) = str2double(get(stateS.handle.CTLevel,'String'));
    stateS.scanStats.CTWidth.(scanUID) = str2double(get(stateS.handle.CTWidth,'String'));
    stateS.scanStats.windowPresets.(scanUID) = 1;
    stateS.scanStats.Colormap.(scanUID) = stateS.optS.scanColorMap(colorMapIndex).name;
end



%switch to new scan, with a short pause to let the dialogue clear.
if (UpDate == 1)
    pause(.1);
    sliceCallBack('selectScan', num2str(newScanNum));
end
