function [ T, mT ] = translateTumor( Tin, maskPT, randTumor )

% get tumor x-y-z cut planes
i = 1; while (sum(sum(Tin(:,i,:))) == 0), i = i + 1; end, minTuX = i;
j = 1; while (sum(sum(Tin(j,:,:))) == 0), j = j + 1; end, minTuY = j;
k = 1; while (sum(sum(Tin(:,:,k))) == 0), k = k + 1; end, minTuZ = k;

i = size(Tin,1); while (sum(sum(Tin(:,i,:))) == 0), i = i - 1; end, maxTuX = i;
j = size(Tin,2); while (sum(sum(Tin(j,:,:))) == 0), j = j - 1; end, maxTuY = j;
k = size(Tin,3); while (sum(sum(Tin(:,:,k))) == 0), k = k - 1; end, maxTuZ = k;

% get phantom x-y-z cut planes
i = 1; while (sum(sum(maskPT(:,i,:))) == 0), i = i + 1; end, minPtX = i;
j = 1; while (sum(sum(maskPT(j,:,:))) == 0), j = j + 1; end, minPtY = j;
k = 1; while (sum(sum(maskPT(:,:,k))) == 0), k = k + 1; end, minPtZ = k;

i = size(maskPT,1); while (sum(sum(maskPT(:,i,:))) == 0), i = i - 1; end, maxPtX = i;
j = size(maskPT,2); while (sum(sum(maskPT(j,:,:))) == 0), j = j - 1; end, maxPtY = j;
k = size(maskPT,3); while (sum(sum(maskPT(:,:,k))) == 0), k = k - 1; end, maxPtZ = k;

lowX = minPtX-minTuX; highX = maxPtX-maxTuX;
lowY = minPtY-minTuY; highY = maxPtY-maxTuY;
lowZ = minPtZ-minTuZ; highZ = maxPtZ-maxTuZ;


[minTuX minTuY minTuZ ; maxTuX maxTuY maxTuZ];
[minPtX minPtY minPtZ ; maxPtX maxPtY maxPtZ];
[minPtX-minTuX minPtY-minTuY minPtZ-minTuZ ; maxPtX-maxTuX maxPtY-maxTuY maxPtZ-maxTuZ];


% xTrans = random('unif',-floor(size(maskPT,2)/2-minPtX), ...
%     floor(maxPtX-size(maskPT,2)/2))
% yTrans = random('unif',-floor(size(maskPT,1)/2-minPtY), ...
%     floor(maxPtY-size(maskPT,1)/2))
% zTrans = random('unif',-floor(size(maskPT,3)/2-minPtZ), ...
%     floor(maxPtZ-size(maskPT,3)/2))
xTrans = random('unif',lowX,highX);
yTrans = random('unif',lowY,highY);
zTrans = random('unif',lowZ,highZ);
T = zeros(size(Tin));
for i = 1:size(T,3)
   T(:,:,i) = imtranslate(Tin(:,:,i),[xTrans yTrans],'cubic','OutputView','same');    
end
for i = 1:size(T,2)
   T(:,i,:) = imtranslate(squeeze(T(:,i,:)),[zTrans 0],'cubic','OutputView','same');    
end
T(T < randTumor.Thresh) = 0;
mT = T;
mT(mT > 0) = 1;

% zPos = ceil(size(T,3)/2+zTrans+1)
% imtool([mT(:,:,zPos)+maskPT(:,:,zPos) maskPT(:,:,zPos)],[])
% for i = 1:size(maskPT,3)
%     if (sum(sum(mT(:,:,i))) > 0)
%         i
%         imtool([mT(:,:,i) maskPT(:,:,i)],[])
%         pause
%     end
% end


end

