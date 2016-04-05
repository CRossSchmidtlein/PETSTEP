function Cpet = generateTACsFromParameters_theoryMatrix(t,dt,Ca,param,modelName)
%%-------------------------------------------------------------------------
% Generates a response TAC corresponding to a chosen compartment model from a vector 
% of kinetic parameters, a given frame vector and input function. 
% 
% USAGE  :  Cpet = generateTACsFromParam(frame,Ca,C0,param,modelName)
% 
% INPUT  :  t          vector of mid frame times, size [(f-1)x1],unit (s).
%                      t = [t1, t2,...].
%           dt         frame duration of t (single value), unit (s).
%           Ca         vector with AIF values corresponding to frame mid times,
%                      size [(f-1)x1], unit (au).
%           param      vector with model parameter values, size [1xp], unit rate constants (1/s). 
%                      E.g. for the 1-tissue model: param=[K1 k2 Va] and for the 2-tissue: 
%                      param=[K1 k2 k3 k4 Va]. Va optional.
%           modelName  string with name of desired model, E.g. '2-tissue'.
% 
% OUTPUT :  Cpet       vector of response tissue TAC, size [(1-f)x1], unit (au) (same as Ca).
% 
% f = number of frames.
% n = number of compartments in tissue.
% p = number of model parameters.
%--------------------------------------------------------------------------

%% Determine some dimensions and construct parameter matrix according to chosen model
switch modelName
    case '1-tissue'
        modelParamNo = [2 3]; %2 or 3 kinetic parameters (without or with blood spill in/out term)
    case '2-tissue'
        modelParamNo = [4 5]; %4 or 5 kinetic parameters (without or with blood spill in/out term)
end
% 
%% Check that all dimensions are correct according to chosen compartment model
if ~ismember( size(param,2), modelParamNo ); 
    fprintf('\nError! Wrong number of parameters. Should be %d or %d for %s.\nExiting...\n',modelParamNo(1),modelParamNo(2),modelName);
    Cpet = [];
    return; 
end

%% Blood spillover term
if size(param,2) == modelParamNo(1) %No blood term
    Va = 0;
else %Blood term
    Va = param(:,end)';
end

%% Theoretical solution
fprintf('Calculating theoretical Cpet... ')
switch modelName
    case '1-tissue'
        term1           = bsxfun( @times, -param(:,2),t );
        C_temp          = bsxfun(@times, param(:,1), exp( term1 ) );
%         C                   = conv( C_temp, Ca_interp );
    case '2-tissue'
        alpha(:,1)      = 0.5*( param(:,2)+param(:,3)+param(:,4) - sqrt( (param(:,2)+param(:,3)+param(:,4)).^2 - 4*param(:,2).*param(:,4) ) );
        alpha(:,2)      = 0.5*( param(:,2)+param(:,3)+param(:,4) + sqrt( (param(:,2)+param(:,3)+param(:,4)).^2 - 4*param(:,2).*param(:,4) ) );
        term1           = bsxfun( @times, -alpha(:,1),t );
        e1              = bsxfun(@times, param(:,1)./( alpha(:,2)-alpha(:,1) ) .* ( param(:,3)+param(:,4)-alpha(:,1) ), exp(term1) );
        clear term1
        term2           = bsxfun( @times, -alpha(:,2),t );
        e2              = bsxfun(@times, param(:,1)./( alpha(:,2)-alpha(:,1) ) .* ( alpha(:,2)-param(:,3)-param(:,4) ), exp(term2) );
        clear term2
        C_temp          = e1 + e2;
%         C_temp        = param(:,1)./( alpha(:,2)-alpha(:,1) ) .* ( ( param(:,3)+param(:,4)-alpha(:,1) ).*exp( -alpha(:,1).*T ) + ...
%                        ( alpha(:,2)-param(:,3)-param(:,4) ).*exp( -alpha(:,2).*T ) );
end
fprintf('Done!\n')
clear e1 e2

% Remove NaN values
C_temp(isnan(C_temp)) = 0;

% Convolve with blood: multiplication in Fourier domain
fprintf('Convolving Cpet with Ca... ')
fftC                    = fft(C_temp',[],1);
fftCa                   = fft(Ca,[],1);
Cpet_noblood            = dt*real( ifft( bsxfun(@times,fftC,fftCa) ) );
clear fftC fftCa
fprintf('Done!\n')

%% Consider blood in tissue, Cpet = (1-Va)*C + Va*Ca
fprintf('Adding blood spillover... ')
Cpet                    = bsxfun(@times, Cpet_noblood, 1-Va) + bsxfun(@times,Va,repmat(Ca,[1,size(Cpet_noblood,2)]));
fprintf('Done!\n')
    