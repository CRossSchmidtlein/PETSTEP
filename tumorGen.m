function [T,mT] = tumorGen(randTumor);

% Build Subtumor Distribution Parameters
randTumor.Nsub = poissrnd(randTumor.Nmean);
if randTumor.Nsub == 0
    randTumor.Nsub = 1;
end

fprintf('Number of tumors: %d\n',randTumor.Nsub)

randTumor.r(1).x = 0;
randTumor.r(1).y = 0;
randTumor.r(1).z = 0;

randTumor.rot(1).theta = random('unif',0,pi());
randTumor.rot(1).phi   = random('unif',-pi()/2,pi()/2);

randTumor.s(1).x = random('norm',randTumor.Smean.xy,randTumor.Smean.xy/2);
randTumor.s(1).y = random('norm',randTumor.Smean.xy,randTumor.Smean.xy/2);
randTumor.s(1).z = random('norm',randTumor.Smean.z,randTumor.Smean.z/2);
while (max([randTumor.s(1).x randTumor.s(1).y randTumor.s(1).z]) > ...
        5*min([randTumor.s(1).x randTumor.s(1).y randTumor.s(1).z]))
    randTumor.s(1).x = random('norm',randTumor.Smean.xy,randTumor.Smean.xy/2);
    randTumor.s(1).y = random('norm',randTumor.Smean.xy,randTumor.Smean.xy/2);
    randTumor.s(1).z = random('norm',randTumor.Smean.z,randTumor.Smean.z/2);
end
fprintf('Number(%d): R(%6.2f,%6.2f,%6.2f) S(%6.2f,%6.2f,%6.2f) \n', ...
    1,randTumor.r(1).x,randTumor.r(1).y,randTumor.r(1).z, ...
    randTumor.s(1).x,randTumor.s(1).y,randTumor.s(1).z)

for i = 2:randTumor.Nsub
    randTumor.r(i).x = random('norm',0,randTumor.Rmean.xy);
    randTumor.r(i).y = random('norm',0,randTumor.Rmean.xy);
    randTumor.r(i).z = random('norm',0,randTumor.Rmean.z);
    
    randTumor.rot(i).theta = random('unif',0,pi());
    randTumor.rot(i).phi   = random('unif',-pi()/2,pi()/2);

    randTumor.s(i).x = random('norm',randTumor.Smean.xy,randTumor.Smean.xy/2);
    randTumor.s(i).y = random('norm',randTumor.Smean.xy,randTumor.Smean.xy/2);
    randTumor.s(i).z = random('norm',randTumor.Smean.z,randTumor.Smean.z/2);
    while (max([randTumor.s(i).x randTumor.s(i).y randTumor.s(i).z]) > ...
            5*min([randTumor.s(i).x randTumor.s(i).y randTumor.s(i).z]))
        randTumor.s(i).x = random('norm',randTumor.Smean.xy,randTumor.Smean.xy/2);
        randTumor.s(i).y = random('norm',randTumor.Smean.xy,randTumor.Smean.xy/2);
        randTumor.s(i).z = random('norm',randTumor.Smean.z,randTumor.Smean.z/2);
    end
    
    randTumor.SUV(i) = random('gamma',randTumor.SUVmean,randTumor.SUVmean/1.5);
    fprintf('Number(%d): R(%6.2f,%6.2f,%6.2f) S(%6.2f,%6.2f,%6.2f) \n', ...
        i,randTumor.r(i).x,randTumor.r(i).y,randTumor.r(i).z, ...
        randTumor.s(i).x,randTumor.s(i).y,randTumor.s(i).z)
end


%% Build Mesh
x1 = -350+700/randTumor.vox.Mat:700/randTumor.vox.Mat:350;
x2 = -350+700/randTumor.vox.Mat:700/randTumor.vox.Mat:350;
x3 = -floor(randTumor.vox.MatZ/2)*3.27:3.27:floor(randTumor.vox.MatZ/2)*3.27;

[X1,X2,X3] = meshgrid(x1,x2,x3);
T = 0;
for i = 1:randTumor.Nsub
    MU = [randTumor.r(i).x randTumor.r(i).y randTumor.r(i).z];
    SIGMA = [randTumor.s(i).x^2 0 0 ; ...
             0 randTumor.s(i).y^2 0 ; ...
             0 0 randTumor.s(i).z^2];
    theta = randTumor.rot(i).theta;
    phi = randTumor.rot(i).phi;
    ROTx = [1 0 0 ; 0 cos(theta) sin(theta) ; 0 -sin(theta) cos(theta)];
    ROTz = [cos(phi) sin(phi) 0 ; -sin(phi) cos(phi) 0 ; 0 0 1];
    SIGMArot = ROTz*ROTx*SIGMA*(ROTz*ROTx)';
    F(:,i) = mvnpdf([X1(:) X2(:) X3(:)],MU,SIGMArot);
    F(:,i) = randTumor.SUV(i)*F(:,i)./max(F(:,i));
    
    tmpF = reshape(F(:,i),length(x1),length(x2),length(x3));
    T = T + tmpF;
end
fprintf('Max SUV: %6.2f \n', max(T(:)))
T(T < randTumor.Thresh) = 0;
mT = T;
mT(mT < 0) = 1;

end