close all, clear all, imtool close all, clc
%% Build Tumor
FOV = 70;
Mat = 256;
MatZ = 10;

randTumor.vox.xy = FOV/Mat; % voxel XY size in cm
randTumor.vox.z = 0.327;    % voxel Z size in cm

randTumor.Nmean = 8;   % Number of Tumors
randTumor.Rmean.xy = 0.5/randTumor.vox.xy; % Mean distance in cm from Tumor 1
randTumor.Rmean.z = 0.5/randTumor.vox.z;   % Mean distance in cm from Tumor 1
randTumor.Smean.xy = .25/randTumor.vox.xy; % Mean spread in cm
randTumor.Smean.z = .25/randTumor.vox.z;   % Mean spread in cm
randTumor.SUVmean = 3; % Mean SUV of tumor
randTumor.Thresh = 1;  % Backgroud threshold

[T,mT] = tumorGen(randTumor);


for i = 1:length(x3)
    if (sum(nonzeros(T(:,:,i))) > 0)
        imtool(imresize(T(:,:,i),[512 512]),[])
    end
end
  %%
% for i = 1:length(x3)
%    figure,imshow(imresize(G(:,:,i),[512 512]),[]);
% end
% x = 0:.1:10;
% figure
% for a = 2:2
%     for b = 0.5:.5:8
%         g = 1/(b^a)/gamma(a)*x.^(a-1).*exp(-x/b);
%         plot(g),hold on
%         pause
%     end
% end









