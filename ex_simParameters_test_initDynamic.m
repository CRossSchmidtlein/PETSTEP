%% Simulation parameters
function ex_simParameters_test_initDynamic

global stateS planC simX;

% input parameters
simX.CTscanNum = 1;      % CT  scan's CERR ID : should be automated

% Tumor parameters
simX.maxSUV        = 7;     % Set Max SUV of the lesion
simX.maxTRAST      = 12.5; % Set Max contrast of the lesion in CT
simX.USE_ADDITIVE  = false;     % Add the tumor to PET/CT backgrounds otherwise replaces
simX.minRegionSize = 3;     % removes small stray contour masks
simX.blurT         = 4.9;   % tumor psf

% count data
simX.countSens    = 6.5;  % 3D sensitivity (counts/kBq/s) (10.5 matched to GE DSTE)
simX.overlap      = 23    % Amount of dwell single overlap in scanner (assumes both ends)
simX.SF = 0.35;           % scatter fraction S/(T+S)
simX.RF = 0.08;           % randoms fraction R/(T+S+R)

% scanner charaterisitics
simX.RingData = 810;    % the diameter of the scanner ring (ex 810 mm GE D690)
simX.tanBin   = 280;    % Sets inital projetion data size (280 matched to GE DSTE)
simX.psf      = 4.9;    % Assumes a PSF for the system, uses same for correction

% image reconstruction definitions
simX.simSize    = 128;     % matrix size of reconstructed image
% simX.fovImage   = 300;     % the FOV of the image (future release)
simX.zFilter    = [1 4 1]; % post recon Z-axis filter 3-point smoothing
                           % Heavy[ 1 2 1]/4, Standard[1 3 1]/5, Light[1 4 1]/6, None[0 1 0]
simX.postFilter =  6.4;     % sigma of post reconstruction filter
simX.iterNUM    =    3;     % number of iterations
simX.subNUM     =   14;     % number of subsets
simX.LOAD_ITER  = true;    % load individual iterations

simX.FBP_OUT   = 'true';
simX.OS_OUT    = 'false';
simX.OSpsf_OUT = 'false';

% number of replicate data sets
simX.nREP = 1;
simX.LOAD_REPS = false;    % load individual replicate sets

end