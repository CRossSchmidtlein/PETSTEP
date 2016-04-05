%% Simulation parameters
function [FBP,OS,OSpsf] = ex_simParameters_test_dynamic(frame,image,N)

global stateS planC simX;

% Object or Pre-Existing Image
IS_OBJ            = true;

simX.PTscanNum    = N; %Index of desired PT frame
simX.dwellTime    = diff(frame);  % Acqusition time for all bed positions = specific frame length(s)
simX.activityConc = mean(image(image>0))/1000; % Mean background activity concentration (kBq/cc) 

% Test for allowable subset number
subsetBAL         = simX.tanBin / simX.subNUM;
if (subsetBAL-floor(subsetBAL) ~= 0)
    fprintf('ERROR: projection angles not divisible by subsets\n');
    fprintf('\tProjections = %3d, \tSubsets = %2d, \t Number of angle bins = %3.2f\n',tanBin,subNum,subTanBin);
    return;
% end
else
    if (IS_OBJ)
      [FBP1,OS1,OSpsf1] = tumorBuilderObject_v1_dynamic(planC,simX);
      FBP   = FBP1(:,:,:,end);
      OS    = OS1(:,:,:,end);
      OSpsf = OSpsf1(:,:,:,end);
    else
      [FBP2,OS2,OSpsf2] = tumorBuilderPreExist_v1_dynamic(planC,simX);
      FBP   = FBP2(:,:,:,end);
      OS    = OS2(:,:,:,end);
      OSpsf = OSpsf2(:,:,:,end);
    end
end

end