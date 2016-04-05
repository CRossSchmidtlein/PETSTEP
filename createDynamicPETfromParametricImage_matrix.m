function dynamicImage = createDynamicPETfromParametricImage_matrix(varargin)
%%-------------------------------------------------------------------------
% Creates a 4D dynamic image of a 3D cell with kinetic parameters (parametric
% image), a given blood input function and frame vector.
% 
% USAGE  :   createDynamicPETfromParametricImage('paramImage',paramImage,...
%                                                'model','2-tissue',...
%                                                'Ca',[c_1 c_2...c_f-1],...
%                                                'frame',[f_1 f_2...f_f])
% 
% INPUT  :   paramImage    Parametric image (3D cell),one parameter set per voxel in unit (1/s)
%                          paramImage{x,y,z} = [K1 k2 ...].
%            model         Desired kinetic model, e.g. '1-tissue' or '2-tissue'.
%            frame         Frame start and ends in unit (s)
%                          frame = [fx1].
%                          [frameStart1; frameStart2=frameEnd1; frameStart3=frameEnd2;...].
%            Ca            Blood input function to model, unit (Bq/cc)
%                          Ca = [(f-1)x1].
% f = no of frames.
% 
% OUTPUT :   dynamicImage  4D matrix with dynamic image (3D image with a 4th time dimension).
%--------------------------------------------------------------------------

%% Check that all arguments have a value
if mod(numel(varargin),2)
    fprintf('Uneven number (%d) of arguments + values: All arguments do not have a value.\nExiting...\n',numel(varargin));
    dynamicImage = [];
    return;
end

%% Read all function arguments
for i=1:2:numel(varargin)-1
    switch varargin{i}
        case 'paramImage'
            paramImage = varargin{i+1}; % 3D cell with one parameter set per voxel.
                                        % paramImage{x,y,z} = [K1 k2 ...].
        case 'frame'
            frame = varargin{i+1};      % Frame start and ends in unit (s).
                                        % frame = [fx1], f = no of frames.
                                        % [frameStart1; frameStart2=frameEnd1; frameStart3=frameEnd2; ...]. 
        case 'Ca'
            Ca = varargin{i+1};         % Input function to the kinetic model, in unit (Bq/cc). 
                                        % Ca = [(f-1)x1], f = no of frames.
        case 'model'
            modelName = varargin{i+1};  % Kinetic model chosen, e.g. '2-tissue'
        otherwise
            fprintf('Unknown argument ''%s''.\nExiting...\n',varargin{i});
            dynamicImage = []; 
            return;
    end
end

%% Number of kinetic parameters in parametric image (assume same in all voxels) and sizes
% noP     = size( paramImage{1},2 ); %no of parameters
% sizePIM = size(paramImage);
noP     = size( paramImage,4 ); %no of parameters
sizePIM = size(paramImage(:,:,:,1)); 
if (numel(sizePIM) <= 2); sizePIM(3) = 1; end

%% Check kinetic model and that number of parameters is valid for chosen model 
switch modelName
    case '1-tissue'
        modelParamNo = [2 3]; %2 or 3 parameters (without or with blood spillover term)
    case '2-tissue'
        modelParamNo = [4 5]; %4 or 5 parameters (without or with blood spillover term)
    otherwise
        fprintf('Unknown model ''%s''.\nExiting...\n',modelName);
        dynamicImage = [];
        return;
end

%% Check that all dimensions are correct according to chosen compartment model
if ~ismember( noP, modelParamNo ); 
    fprintf('The parametric image contains %d kinetic parameters/voxel. The chosen model ''%s'' should have %d or %d.\nExiting...\n',noP,modelName,modelParamNo(1),modelParamNo(2));
    dynamicImage = [];
    return; 
end

%% Start timing
mainClock = tic;

%% Time properties of input function
midFrame    = frame(1:end-1) + diff(frame)/2;
frameLength = diff(frame);

%% Interpolate to even, closely spaced time vector 
interpMethod = 'linear';
if min(frameLength) < 0.1 %(s)
    dt = min(frameLength); %(s)
else
    dt = 0.1; %(s)
end
t_interp                    = (frame(1):dt:frame(end))'; %(s)
Ca_interp                   = interp1( midFrame, Ca, t_interp, interpMethod); 
Ca_interp(isnan(Ca_interp)) = 0;

%% Calculate TACs based on parameter sets
% Only calculate TACs for unique PIM voxels (parameter sets) to save time and memory
[paramImageUnique,~,uniqueIndex]   = unique( single( reshape(paramImage,[prod(sizePIM),noP]) ),'rows'); % All unique parameter sets, stacked.
% [paramImageUnique,~,uniqueIndex]   = unique( single(cell2mat(paramImage(:))),'rows'); % All unique parameter sets, stacked.
clear paramImage

% Time and/or memory saved by only doing unique voxels, not all voxels
fprintf( 'Total no of PIM voxels                    : %d\n', prod(sizePIM));
fprintf( 'No of unique voxels to calculate TACs for : %d\n',size(paramImageUnique,1) );
fprintf( 'Matrix size (memory/time) save factor     : %.3f%%\n\n',100*(1-size(paramImageUnique,1)/prod(sizePIM)) );

% Calculate TACs from kinetic parameters, using the resampled time vector
Cpet_interp         = generateTACsFromParameters_theoryMatrix( repmat(t_interp',[size(paramImageUnique,1),1]),dt,...
                                                               Ca_interp,paramImageUnique,modelName );
clear paramImageUnique

% Interpolate TACs back to desired frame
Cpet                = interp1(t_interp,Cpet_interp,midFrame,interpMethod);
clear Cpet_interp
fprintf('\n');

%% Plug calculated TACs into correct voxels of dynamic image. Reshape dynamic image to 
% same 3D size as parametric image, but also with 4th time dimension
fprintf('Reshaping dynamic image according to PIM... ')
dynamicImage = reshape( Cpet(:,uniqueIndex)',[sizePIM numel(Ca)] );
fprintf('Done!\n')
clear Cpet

%% End timing
toc(mainClock)

end