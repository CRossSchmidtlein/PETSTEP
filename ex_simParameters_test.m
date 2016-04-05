%% Simulation parameters
global stateS planC;

% Object or Pre-Existing Image
IS_OBJ = false;

% input parameters
simX.PTscanNum = 1;      % PET scan's CERR ID : should be automated
simX.CTscanNum = 2;      % CT  scan's CERR ID : should be automated

% Tumor parameters
simX.maxSUV        = 10;     % Set Max SUV of the lesion
simX.maxTRAST      = 1.15;   % Set Max contrast of the lesion in CT
simX.USE_ADDITIVE  = false;  % Add the tumor to PET/CT backgrounds otherwise replaces
simX.minRegionSize = 3;     % removes small stray contour masks

% count data
simX.dwellTime    = 180;  % Acqusition time for all bed positions (s)
simX.activityConc = 5;    % Mean background activity concentration (kBq/cc) 
simX.countSens    = 7.5;  % 3D sesnitivity (counts/kBq/s) (10.5 matched to GE DSTE)
simX.overlap      = 0.5;  % 0.234 % Amount of dwell single overlap in scanner (assumes both ends)
simX.SF = 0.25;           % scatter fraction S/(T+S)
simX.RF = 0.08;           % randoms fraction R/(T+S+R)

% scanner charaterisitics
simX.RingData = 810;    % the diameter of the scanner ring (ex 810 mm GE D690)
simX.tanBin   = 288;    % Sets inital projetion data size (280 matched to GE DSTE)
simX.psf      = 5.1;    % Assumes a PSF for the system, uses same for correction

% image reconstruction definitions
simX.simSize    = 128;     % matrix size of reconstructed image
% simX.fovImage   = 300;     % the FOV of the image (future release)
simX.zFilter    = [1 4 1]; % post recon Z-axis filter 3-point smoothing
                           % Heavy[ 1 2 1]/4, Standard[1 4 1]/5, Light[1 8 1]/6, None[0 1 0]
simX.postFilter =  6.4;    % sigma of post reconstruction filter
simX.iterNUM    =    3;    % number of iterations
simX.subNUM     =   16;    % number of subsets
simX.LOAD_ITER  = false;    % load individual iterations

simX.FBP_OUT   = true;
simX.OS_OUT    = true;
simX.OSpsf_OUT = true;

% number of replicate data sets
simX.nREP = 1;
simX.LOAD_REPS = false;    % load individual replicate sets

% Test for allowable subset number
subsetBAL = simX.tanBin / simX.subNUM;
if (subsetBAL-floor(subsetBAL) ~= 0)
    fprintf('ERROR: projection angles not divisible by subsets\n');
    fprintf('\tProjections = %3d, \tSubsets = %2d, \t Number of angle bins = %3.2f\n',tanBin,subNum,subTanBin);
    return;
else
    if (IS_OBJ)
      [FBP1,OS1,OSpsf1] = tumorBuilderObject_v1(planC,simX);
    else
      [FBP2,OS2,OSpsf2] = tumorBuilderPreExist_v1(planC,simX);
    end
end