function [refPT,refCT] = addTumor(tumorPT,tumorCT,maskPT,maskCT,rtsPT,rtsCT,maxSUV,maxTRAST,USE_ADDITIVE)
%"addTumor"
%   addes sooothed synthetic lesions into PET and CT images
%
% CRS, 08/01/2013
%
%Usage: 
%   [refPT,refCT] = addTumor(tumorPT,tumorCT,maskPT,maskCT,rtsPT,rtsCT,maxSUV,maxTRAST,USE_ADDITIVE)
%       tumorPT      = smoothed PET lesion
%       tumorCT      = smoothed CT lesion
%       maskPT       = PET lesion mask
%       maskCT       =  CT lesion mask
%       rtsPT        = reference PET image
%       rtsCT        = reference  CT image
%       maxSUV       = maximu tumor SUV
%       maxTRAST     = maximum tumor CT contrat
%       USE_ADDITIVE = use additive or replacement for tumoor insertion
%
% Copyright 2010, Joseph O. Deasy, on behalf of the CERR development team.
% 
% This file is part of The Computational Environment for Radiotherapy Research (CERR).
% 
% CERR development has been led by:  Aditya Apte, Divya Khullar, James Alaly, and Joseph O. Deasy.
% 
% CERR has been financially supported by the US National Institutes of Health under multiple grants.
% 
% CERR is distributed under the terms of the Lesser GNU Public License. 
% 
%     This version of CERR is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
% CERR is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
% See the GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with CERR.  If not, see <http://www.gnu.org/licenses/>.%
%
%% Add Tumor
maxSUV = max(tumorPT(:));
%maxTRAST = max(tumorCT(:));
mu_water_511keV = 0.096;
mu_bone_511keV  = 0.172;
mu_water_80keV = 0.184;
mu_bone_80keV  = 0.428;

if (max(tumorPT(:)) == 0)
    
    refPT = rtsPT;
    refCT = rtsCT;
    
else
    
    if (USE_ADDITIVE)
        meanPT = mean(nonzeros(maskPT.*rtsPT));
        tumorPT = tumorPT*(maxSUV-meanPT)/max(tumorPT(:));
        refPT = rtsPT + tumorPT;
    else
        meanPT = mean(nonzeros(maskPT.*rtsPT));
        tumorPT = tumorPT*(maxSUV-meanPT)/max(tumorPT(:));
        refPT = rtsPT.*(1-maskPT) + (tumorPT+meanPT.*maskPT);
    end
    
    if (USE_ADDITIVE)
        meanCT = mean(nonzeros(maskCT.*rtsCT));
        for i = 1:size(rtsCT,3)
            tumorCT = tumorCT*(maxTRAST-meanCT)/max(tumorCT(:));
        end
        refCT = rtsCT + tumorCT;
    else
        meanCT = mean(nonzeros(maskCT.*rtsCT));
        tumorCT = tumorCT*(maxTRAST-meanCT)/max(tumorCT(:));
        refCT = rtsCT.*(1-maskCT) + (tumorCT+meanCT.*maskCT);
    end
    
end

indx = find(refCT <= 1);
refCT(indx) = mu_water_511keV*refCT(indx);
indx = find(refCT > 1);
refCT(indx) = mu_water_511keV + (refCT(indx)-1)*mu_bone_80keV* ...
    (mu_bone_511keV - mu_water_511keV) / (mu_bone_80keV - mu_water_80keV);
refCT(refCT < 0) = 0;

end
