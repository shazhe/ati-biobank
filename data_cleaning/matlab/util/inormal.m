function Z = inormal(varargin)
% Applies a rank-based inverse normal transformation.
% 
% Usage: Z = inormal(X)
%            inormal(X,c)
%            inormal(X,method)
%            inormal(X,...,quanti)
%
% X      : Original data. Can be a vector or an array.
% c      : Constant to be used in the transformation.
%          Default c=3/8 (Blom).
% method : Method to choose c. Accepted values are:
%              'Blom'   (c=3/8),
%              'Tukey'  (c=1/3),
%              'Bliss', (c=1/2)  and
%              'Waerden' or 'SOLAR' (c=0). 
%          Default is Blom.
% Z      : Transformed data.
% quanti : All data guaranteed to be quantitative and
%          without NaN?
%          This can be a true/false. If true, the function
%          runs much faster if X is an array.
%          Default is false.
% 
% References:
% * Van der Waerden BL. Order tests for the two-sample
%   problem and their power. Proc Koninklijke Nederlandse
%   Akademie van Wetenschappen. Ser A. 1952; 55:453-458
% * Blom G. Statistical estimates and transformed
%   beta-variables. Wiley, New York, 1958.
% * Tukey JW. The future of data analysis.
%   Ann Math Stat. 1962; 33:1-67.
% * Bliss CI. Statistics in biology. McGraw-Hill,
%   New York, 1967.
% * Beasley TM, Erickson S, Allison DB. Rank-based inverse
%   normal transformations are increasingly used, but are
%   they merited? Behav Genet. 2009; 39(5):580-95.
%
% _____________________________________
% Anderson M. Winkler
% Yale University / Institute of Living
% Aug/2011 (first version)
% Jun/2014 (this version)
% http://brainder.org


% Accept inputs & defaults
c0 = 3/8;  % Default (Blom, 1958)
quanti = false;
if nargin == 1,
    c = c0;
elseif nargin > 1 && ischar(varargin{2}),
    switch lower(varargin{2}),
        case 'blom'
            c = 3/8;
        case 'tukey'
            c = 1/2;
        case 'bliss'
            c = 1/2;
        case 'waerden'
            c = 0;
        case 'solar'
            c = 0; % SOLAR is the same as Van der Waerden
        otherwise
            error('Method %s unknown. Use either ''Blom'', ''Tukey'', ''Bliss'', ''Waerden'' or ''SOLAR''.',varargin{2});
    end
elseif nargin > 1 && isscalar(varargin{2}),
    c = varargin{2};  % For a user-specified value for c
end
if nargin == 3,
    quanti = varargin{3};
    if isempty(varargin{2}),
        c = c0;
    end
end
X = varargin{1};

% If the trait is quantitative, avoid the loop
if quanti,
    % Get the rank for each value
    [~,iX] = sort(X);
    [~,ri] = sort(iX);
    
    % Do the actual transformation
    p = (ri-c)/(size(X,1)-2*c+1);
    Z = sqrt(2)*erfinv(2*p-1);
    
else
    Z = nan(size(X));
    for x = 1:size(X,2),
        
        % Remove NaNs
        XX = X(:,x);
        ynan = isnan(XX);
        XX = XX(~ynan);
        
        % Get the rank for each value
        [~,iX] = sort(XX);
        [~,ri] = sort(iX);
        
        % Do the actual transformation
        p = (ri-c)/(size(XX,1)-2*c+1);
        Y = sqrt(2)*erfinv(2*p-1);
        
        % Check for repeated values
        U = unique(XX);
        U = U(sum(bsxfun(@eq,XX,U'),1) > 1);
        for u = 1:numel(U),
            Y(XX == U(u)) = mean(Y(XX == U(u)));
        end
        
        % Put the NaNs back
        Z(~ynan,x) = Y;
    end
end



