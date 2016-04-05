function [FBP,OS,OSpsf] = tumorBuilderPreExist_v1_dynamic(planC,simX);
%"tumorBuild_v1"
%   Builds PET-like images with synthetic lesions added by user
%
% CRS, 08/01/2013
%
%Usage:
%   [FBP,OS,OSpsf] = tumorBuilderPreExist_v1(planC,simX)
%       planC = Contains plan with PET/CT data and a structure set for
%       defining the lesion.
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
%% Tumor Builder

global stateS planC dynIm;
indexS = planC{end};

simX
%% input parameters
PTscanNum = simX.PTscanNum;        % PET scan's CERR ID : should be automated
% PTscanNum = N;
CTscanNum = simX.CTscanNum;        % CT  scan's CERR ID : should be automated

% Tumor parameters
maxSUV = simX.maxSUV;               % Set Max SUV of the lesion
maxTRAST = simX.maxTRAST;           % Set Max contrast of the lesion in CT
USE_ADDITIVE  = simX.USE_ADDITIVE;  % Add the tumor to PET/CT backgrounds otherwise replaces
minRegionSize = simX.minRegionSize; % removes small stray contour masks

% Count Data
countScale = simX.dwellTime*simX.activityConc*simX.countSens; % Sets mean number of counts per active voxel
countScale = countScale * ( 1 + 4*(simX.overlap/100)^2 ); % corrects by adding slice overlap
% countsTotal = simX.countsTotal;  % Sets the noise level by mean number of counts per slice
SF = simX.SF;           % scatter fraction S/(T+S)
RF = simX.RF;           % randoms fraction R/(T+S+R)

% scanner charaterisitics
ringData = simX.RingData;     % the ring diameter of the scanner's data acquisition (810 mm GE D690)
% radBin  = simX.radBin;       % Sets inital radial data size match to FOV and ring diameter
tanBin  = simX.tanBin;       % Sets inital projetion data size (280 matched to GE DSTE)
psf     = simX.psf;          % Assumes a PSF for the system, uses same for correction

% image reconstruction definitions
% fovImage   = simX.fovImage        % the FOV of the image (future release)
simSize    = simX.simSize;         % Matrix size of reconstructed image
% zFilter -> Heavy[ 1 2 1]/4, Standard[1 3 1]/5, Light[1 4 1]/6, None[0 1 0]
zFilter    = simX.zFilter;         % post recon Z-axis filter 3-point smoothing
zFilter    = zFilter/sum(zFilter); % automatic nomalization
postFilter = simX.postFilter;      % sigma of post reconstruction filter
iterNUM    = simX.iterNUM;         % number of iterations
subNUM     = simX.subNUM;          % number of subsets

%LOAD_ITER=true;
LOAD_ITER = simX.LOAD_ITER;

FBP_OUT   = simX.FBP_OUT;
OS_OUT    = simX.OS_OUT;
OSpsf_OUT = simX.OSpsf_OUT;

% number of replicate data sets
nREP = simX.nREP;
%LOAD_REPS=true;
LOAD_REPS = simX.LOAD_REPS;
simX.Preexist='true';

%% Get PET/CT Data & Verify SUV
% PET
% PT = double(image);
PT = double(planC{indexS.scan}(PTscanNum).scanArray);
PTscanNum_old = PTscanNum;
dicomhd = planC{indexS.scan}(PTscanNum).scanInfo(1).DICOMHeaders;
try SUV = calc_suv(dicomhd,1); catch, SUV=1; end

SUV_flag = 0;
if (max(PT(:)) > 250)
    'Not in SUV'
    'Converting to SUV'
    ['SUV factor = ' num2str(SUV)]
    SUV_flag = 1;
    PT = PT*SUV;
%     getSimImages(PTscanNum,PT,'PET in SUV',1:size(PT,3),1,simX);drawnow
    PTscanNum = length(planC{indexS.scan});
end

% Get CT data
CT = double(planC{indexS.scan}(CTscanNum).scanArray)-1000;
CT(CT < -500) = -1000;

%% Get inital image and data attributes

% Get reference PET voxel size in mm and data
vox.pet.xyz = [ 10*planC{indexS.scan}(PTscanNum).scanInfo(1).grid2Units ...
    10*planC{indexS.scan}(PTscanNum).scanInfo(1).grid1Units ...
    10*planC{indexS.scan}(PTscanNum).scanInfo(1).sliceThickness ];
vox.pet.vol = prod(vox.pet.xyz);
vox.pet.nxn = size(PT);
vox.pet.fov = vox.pet.nxn.*vox.pet.xyz;
vox.pet.rtz = [ 2*ceil(norm( vox.pet.nxn(1:2) - floor(( vox.pet.nxn(1:2)-1 )/2)-1)) + 3 ...
    tanBin vox.pet.nxn(3) ];

% Get reference CT voxel size in mm and data
vox.ct.xyz = [ 10*planC{indexS.scan}(CTscanNum).scanInfo(1).grid2Units ...
    10*planC{indexS.scan}(CTscanNum).scanInfo(1).grid1Units ...
    10*planC{indexS.scan}(CTscanNum).scanInfo(1).sliceThickness ];
vox.ct.vol = prod(vox.ct.xyz);
vox.ct.nxn = size(CT);
vox.ct.fov = vox.ct.nxn.*vox.ct.xyz;

% Get Simulation PET/CT voxel size in mm and data
radBin = floor(4*tanBin * asin( vox.pet.fov(1) / ringData )/pi - 1);
if (mod(radBin,2) == 0), radBin = radBin + 1 ; end
vox.petSim.xyz = vox.pet.xyz .* [ vox.pet.nxn(1:2)/radBin 1 ];
vox.petSim.vol = prod(vox.petSim.xyz);
vox.petSim.nxn = [radBin radBin vox.pet.nxn(3)];
vox.petSim.fov = vox.petSim.nxn.*vox.petSim.xyz;
vox.petSim.r   = 2*ceil(norm( vox.petSim.nxn(1:2) - floor(( vox.petSim.nxn(1:2)-1 )/2)-1)) + 3;
vox.petSim.tan = tanBin;
vox.petSim.rtz = [ 2*ceil(norm( vox.petSim.nxn(1:2) - floor(( vox.petSim.nxn(1:2)-1 )/2)-1)) + 3 ...
    tanBin vox.pet.nxn(3) ];

% Get Output Image PET voxel size in mm and data
vox.petOut.xyz = vox.pet.xyz .* [ vox.pet.nxn(1:2)/simSize 1 ];
vox.petOut.vol = prod(vox.petOut.xyz);
vox.petOut.nxn = [simSize simSize vox.pet.nxn(3)];
vox.petOut.fov = vox.petOut.nxn.*vox.petOut.xyz;
vox.petOut.rtz = [ 2*ceil(norm( vox.petOut.nxn(1:2) - floor(( vox.petOut.nxn(1:2)-1 )/2)-1)) + 3 ...
    tanBin vox.pet.nxn(3) ];

% %% Resample CT in z, IDA
% petslice = -vox.pet.xyz(3)*(vox.pet.nxn(3)-1)/2:vox.pet.xyz(3):vox.pet.xyz(3)*(vox.pet.nxn(3)-1)/2;
% ctslice = -vox.ct.xyz(3)*(vox.ct.nxn(3)-1)/2:vox.ct.xyz(3):vox.ct.xyz(3)*(vox.ct.nxn(3)-1)/2;
% for i = 1:size(CT,1)
%     for j = 1:size(CT,2)
%         CT_resamp(i,j,:) = interp1(ctslice',squeeze(CT(i,j,:)),petslice','cubic');
%     end
% end

%% Build Tumors
% Builds Tumors, gets relevant PET/CT data, and matches CT to PET
[tumorPT,tumorCT,rtsPT,rtsCT,zSlices] = getTumor(PT,PTscanNum,PTscanNum_old,CT,CTscanNum,vox,minRegionSize);
zSlice = length(zSlices);
vox.petSim.nxn(3) = length(zSlices); vox.petOut.nxn(3) = length(zSlices);
vox.petSim.rtz(3) = length(zSlices); vox.petOut.rtz(3) = length(zSlices);

% Builds tumor masks
maskPT = tumorPT; maskPT(maskPT > 0.05) = 1; maskPT(maskPT <= 0.05) = 0;
maskCT = tumorCT; maskCT(maskCT > 0) = 1;    maskCT(maskCT < 0) = 0;

% inserts tumor either additively or by voxel replecemnent
[refPT,refCT] = addTumor(tumorPT,tumorCT,maskPT,maskCT,rtsPT,rtsCT,maxSUV,maxTRAST,USE_ADDITIVE);

% inserts reference images into CERR
%getSimImages(CTscanNum,refCT,'CT + Tumor',zSlices,1,simX);  drawnow
%getSimImages(PTscanNum,refPT,'PET + Tumor',zSlices,1,simX); drawnow

%% Build simulated projection data
% build pristine data with count scaling
[FWPTpet,FWPTpetB,FWTUtrue,FWPTscatter,FWTUscatter,FWPTrandoms,FWTUrandoms,CTAC,wcc,countsREF] = ...
    buildSimTumorData(refPT,rtsPT,refCT,psf,vox,countScale,SF,RF);

% PSF kernel matched to output size
sigma = psf * vox.petOut.nxn(1) / vox.pet.fov(1);
sigMat = max( ceil(3*sigma) , 5 );
if (mod(sigMat,2) == 0), sigMat = sigMat + 1; end
PSF  = fspecial('gaussian', sigMat, sigma / ( 2*sqrt(2*log(2)) ) );
% Post smoothing kernel matched to output size
sigmaPost = postFilter * vox.petOut.nxn(1) / vox.pet.fov(1);
sigMatPost = max( ceil(3*sigmaPost) , 5 );
if (mod(sigMatPost,2) == 0), sigMatPost = sigMatPost + 1; end
POST = fspecial('gaussian', sigMatPost, sigmaPost / ( 2*sqrt(2*log(2)) ) );

%% Perform Recons
%
FBP = zeros([vox.petOut.nxn nREP]);
OS = zeros([vox.petOut.nxn iterNUM nREP]);
OSpsf = zeros([vox.petOut.nxn  iterNUM nREP]);

initPT = zeros( vox.petOut.nxn );
nn   = (vox.petOut.nxn(1)-1)/2;
x2   = linspace(-nn,nn,vox.petOut.nxn(1)).^2;
disk = x2(ones(vox.petOut.nxn(1),1),:) + x2(ones(1,vox.petOut.nxn(1)),:)' <= (vox.petOut.nxn(1)/2)^2;
for i = 1:vox.petOut.nxn(3)
    initPT(:,:,i) = disk.*imresize(rtsPT(:,:,i),[simSize simSize]);
end

for i = 1:nREP
    % add noise to projection data
    
    [nFWPTtotal,nFWPTtotalB,counts] = ...
        noiseTumorData(FWPTpet,FWPTpetB,FWTUtrue,FWPTscatter,FWTUscatter,FWPTrandoms,FWTUrandoms);
    counts.ID      = counts.NEC / prod( vox.petOut.nxn );
    
    % Recon Data
    
    if strcmp(FBP_OUT,'true')
        [FBP(:,:,:,i)] = ...
            fbpSimData( ...
            nFWPTtotal,FWPTscatter+FWPTrandoms+FWTUscatter+FWTUrandoms,CTAC, ...
            wcc,vox);
        % Tumor only xy and z filters
        subPT = FBP(:,:,:,i) - initPT;
        [subPT] = xyPostFilter(subPT,POST);
        [subPT] = zAxialFilter(subPT,zFilter);
        FBP(:,:,:,i) = initPT + subPT;
    end
    if strcmp(OS_OUT,'true')
        [OS(:,:,:,:,i)] = ...
            osemSimData( ...
            nFWPTtotal,FWPTscatter+FWPTrandoms+FWTUscatter+FWTUrandoms,CTAC,initPT, ...
            wcc,vox,iterNUM,subNUM);
        subPT = OS(:,:,:,:,i) - repmat(initPT,[1,1,1,iterNUM]);
        [subPT] = xyPostFilter(subPT,POST);
        [subPT] = zAxialFilter(subPT,zFilter);
        OS(:,:,:,:,i) = repmat(initPT,[1,1,1,iterNUM]) + subPT;
    end
    if strcmp(OSpsf_OUT,'true')
        [OSpsf(:,:,:,:,i)] = ...
            osemPSFSimData( ...
            nFWPTtotal,FWPTscatter+FWPTrandoms+FWTUscatter+FWTUrandoms,CTAC,initPT,PSF, ...
            wcc,vox,iterNUM,subNUM);
        subPT = OSpsf(:,:,:,:,i) - repmat(initPT,[1,1,1,iterNUM]);
        [subPT] = xyPostFilter(subPT,POST);
        [subPT] = zAxialFilter(subPT,zFilter);
        OSpsf(:,:,:,:,i) = repmat(initPT,[1,1,1,iterNUM]) + subPT;
    end
    
    [counts.total counts.true counts.scatter counts.randoms]/1E6
    
end

%% Below is commented by IDA to prevent storing of simulated data in planC since it messes things up
%--------------------------------------------------------------------------
% % Insert simulated images into CERR
% if strcmp(LOAD_REPS,'true')
%     for i = 1:nREP
%         fbpName = ['FBP Tumor R' num2str(i)];
%         if (max(FBP(:)) > 0), getSimImages(PTscanNum,FBP(:,:,:,i),fbpName,zSlices,1,siblurTmX);drawnow; end
%         if strcmp(LOAD_ITER,'true')
%             for j = 1:iterNUM
%                 osName = ['OS-EM Tumor I' num2str(j) 'xS' num2str(subNUM) ' R' num2str(i)];
%                 ospsfName = ['OS-EM w/ PSF Tumor I' num2str(j) 'xS' num2str(subNUM) ' R' num2str(i)];
%                 if (max(OS(:)) > 0),getSimImages(PTscanNum,OS(:,:,:,j,i),osName,zSlices,1,simX);drawnow; end
%                 if (max(OSpsf(:)) > 0),getSimImages(PTscanNum,OSpsf(:,:,:,j,i),ospsfName,zSlices,1,simX);drawnow; end
%             end
%         else
%             osName = ['OS-EM Tumor I' num2str(iterNUM) 'xS' num2str(subNUM) ' R' num2str(i)];
%             ospsfName = ['OS-EM w/ PSF Tumor I' num2str(iterNUM) 'xS' num2str(subNUM) ' R' num2str(i)];
%             if (max(OS(:)) > 0),getSimImages(PTscanNum,OS(:,:,:,end,i),osName,zSlices,1,simX);drawnow; end
%             if (max(OSpsf(:)) > 0),getSimImages(PTscanNum,OSpsf(:,:,:,end,i),ospsfName,zSlices,1,simX);drawnow; end
%         end
%     end
% else
%     fbpName = ['FBP Tumor R1'];
%     if (max(FBP(:)) > 0), getSimImages(PTscanNum,FBP(:,:,:,1),fbpName,zSlices,1,simX);drawnow; end
%     if strcmp(LOAD_ITER,'true')
%         for j = 1:iterNUM
%             osName = ['OS-EM Tumor I' num2str(j) 'xS' num2str(subNUM) ' R1'];
%             ospsfName = ['OS-EM w/ PSF Tumor I' num2str(j) 'xS' num2str(subNUM) ' R1'];
%             if (max(OS(:)) > 0),getSimImages(PTscanNum,OS(:,:,:,j,1),osName,zSlices,1,simX);drawnow; end
%             if (max(OSpsf(:)) > 0),getSimImages(PTscanNum,OSpsf(:,:,:,j,1),ospsfName,zSlices,1,simX);drawnow; end
%         end
%     else
%         osName = ['OS-EM Tumor I' num2str(iterNUM) 'xS' num2str(subNUM) ' R1'];
%         ospsfName = ['OS-EM w/ PSF Tumor I' num2str(iterNUM) 'xS' num2str(subNUM) ' R1'];
%         if (max(OS(:)) > 0),getSimImages(PTscanNum,OS(:,:,:,end,1),osName,zSlices,1,simX);drawnow; end
%         if (max(OSpsf(:)) > 0),getSimImages(PTscanNum,OSpsf(:,:,:,end,1),ospsfName,zSlices,1,simX);drawnow; end
%     end
% end

return
%% External stopping rule
% future work...