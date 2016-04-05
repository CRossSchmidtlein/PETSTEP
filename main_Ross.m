global planC

%% Extract parametric image (PIM).
% Extract all parameter images (K1, k2,...) from planC and store in 4D PIM image 
% where 4th dimension = parameter.
i0 = 3; %Start index of parameter images in planC. To be automated.
i  = 1; %Index counter.
clear pim
while findstr( planC{1,3}(i0+i-1).scanType,'PIM');
    pim(:,:,:,i) = planC{1,3}(i0+i-1).scanArray;
    i = i+1;
end

%% Create pristine 4D PET image from PIM.
image4D = createDynamicPETfromParametricImage_matrix('paramImage',pim,'model','2-tissue','frame',frame,'Ca',Ca);

%% Insert pristine 4D PET image into planC.
% function needed for this. Done manually for the planC used for testing.

%% Resample CT to match PET in z-direction.
% Dunno if this is needed? I did it manually cause I ran into some errors
% otherwise. Function for this maybe needed.

%% Initialize simX.
% Doesn't run any simulations, just sets the joint values of simX (most 
% values are the same for all frames).
ex_simParameters_test_initDynamic;

%% Loop over all frames of the pristine 4D image and simulate each frame with PETSTEP.
% Note: the simulated output is not stored in planC for now (commented out
% in "tumorBuilder---v1_dynamic.m". Nothing else is altered in the simulation code.
% The simulated data should be stored in planC, function needed. 
clear FBP4D OS4D OSpsf4D
for i = 1:size(image4D,4)
    planCImageIndex = i+7; %index of wanted frame array in planC. To be automated.
    [FBP4D(:,:,:,i),OS4D(:,:,:,i),OSpsf4D(:,:,:,i)] = ex_simParameters_test_dynamic( [frame(i) frame(i+1)], image4D(:,:,:,i), planCImageIndex );
end

%% Clear variables.
clear pim i0 i planCImageIndex
