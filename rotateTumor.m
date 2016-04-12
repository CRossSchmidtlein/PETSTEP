function [ T, mT ] = rotateTumor( T , randTumor )

theta = random('unif',0,180);
for i = 1:size(T,3)
    T(:,:,i) = imrotate(T(:,:,i),theta,'bicubic','crop');
end
phi = random('unif',-90,90);
for i = 1:size(T,2)
    T(:,i,:) = imrotate(squeeze(T(:,i,:)),phi,'bicubic','crop');
end
T(T < randTumor.Thresh) = 0;
mT = T;
mT(mT > 0) = 1;

end

