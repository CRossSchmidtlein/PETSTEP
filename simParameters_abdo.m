%% Simulation parameters
global planC;

% Object or Pre-Existing Image
IS_OBJ = true;

% input parameters
simX.PTscanNum = 1;      % PET scan's CERR ID : should be automated
simX.CTscanNum = 2;      % CT  scan's CERR ID : should be automated

% Tumor parameters
simX.maxSUV = 7;        % Set Max SUV of the lesion
simX.maxTRAST = 0.125;   % Set Max contrast of the lesion in CT
simX.USE_ADDITIVE = 0;   % Add the tumor to PET/CT backgrounds otherwise replaces
simX.minRegionSize = 3;  % removes small stray contour masks

% count data
simX.countsTotal = 4E6;  % Sets the noise level by mean number of counts per slice
simX.SF = 0.4;           % scatter fraction S/(T+S)
simX.RF = 0.4;           % randoms fraction R/(T+S+R)

% scanner and image charaterisitics
simX.radBin = 329;       % Sets inital radial data size (329 matched to GE DSTE)
simX.tanBin = 280;       % Sets inital projetion data size (280 matched to GE DSTE)
simX.psf    =   4;       % Assumes a PSF for the system, uses same for correction

simX.simSize    = 256;   % Size of reconstructed image
simX.postFilter =   4;   % sigma of post reconstruction filter
simX.iterNUM    =   4;   % number of iterations
simX.subNUM     =  14;   % number of subsets

simX.OUT_PUT = 0;        % 0 = FBP, MLEM w/o & w/ PSF, 1 = FBP, 2 = MLEM, 3 = MLEM w/PSF
                         % 4 = 1+3, 5 = 2+3, 6 =  1+2, 0 = otherwise
                    
% number of replicate data sets
simX.nREP = 2;

% Test for allowable subset number
subsetBAL = simX.tanBin/simX.subNUM;
if (subsetBAL-floor(subsetBAL) ~= 0)
    fprintf('ERROR: projection angles not divisible by subsets\n');
    fprintf('\tProjections = %3d, \tSubsets = %2d, \t Number of angle bins = %3.2f\n',tanBin,subNum,subTanBin);
    return;
else
    if (IS_OBJ)
        [FBP,OS,OSpsf] = tumorBuilderObject_v1(planC,simX);
    else
        [FBP,OS,OSpsf] = tumorBuilderPreExist_v1(planC,simX);
    end
end