close all, clear all, imtool close all, clc, rng('shuffle')
%% Build Tumor
randTumor.vox.FOV = 700;
randTumor.vox.Mat = 128;
randTumor.vox.MatZ = 82;

randTumor.vox.xy = randTumor.vox.FOV/randTumor.vox.Mat; % voxel XY size in cm
randTumor.vox.z = 3.27;    % voxel Z size in cm

randTumor.Nmean = 8;   % Number of Tumors
randTumor.Rmean.xy = 50/randTumor.vox.xy; % Mean distance in cm from Tumor 1
randTumor.Rmean.z = 50/randTumor.vox.z;   % Mean distance in cm from Tumor 1
randTumor.Smean.xy = 25/randTumor.vox.xy; % Mean spread in cm
randTumor.Smean.z = 25/randTumor.vox.z;   % Mean spread in cm
randTumor.SUVmean = 3; % Mean SUV of tumor
randTumor.Thresh = 1;  % Backgroud threshold

[ Tref, mTref ] = tumorGen(randTumor);
[ Trot, mTrot ] = rotateTumor( Tref , randTumor);

%% Randomly translate tumor
nn   = (randTumor.vox.Mat-1)/2;
x2   = linspace(-nn,nn,randTumor.vox.Mat).^2;
disk = x2(ones(randTumor.vox.Mat,1),:) + ...
    x2(ones(1,randTumor.vox.Mat),:)' ...
    <= (randTumor.vox.Mat/3)^2;
maskPT = double(repmat(disk, [ 1 1 randTumor.vox.MatZ+1]));

maskPT(maskPT > 0.1) = 1;    
maskPT(maskPT <= 0.1) = 0;
for i = 1:randTumor.vox.MatZ
    maskPT(:,:,i) = double(imfill(maskPT(:,:,i),'holes'));
end

flag = 1;
while (flag ~= 0)
    [ T, mT ] = translateTumor( Trot, maskPT, randTumor );
    if (sum(mT(:)) == 0)
        flag = 1;
    else
    tmpT = mT + maskPT;
    tmpT(tmpT > 0) = 1;
    flag = sum(tmpT(:)-maskPT(:));
    end
    fprintf('Sum of residual = %d\n',flag)
end


%%
for i = 1:size(T,3)
    if (sum(nonzeros(T(:,:,i))) > 0)
        imtool(imresize(T(:,:,i)+maskPT(:,:,i),[512 512]),[0 max(T(:))])
    end
end



