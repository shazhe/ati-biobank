function data = fix_missing(data, method)
% FIX_MISSING Fixes missing data by imputation
%
%   USAGE:
%   fixed = fix_missing(data, method)
%
%   data = biobank gaussianised variables
%   method = string with the type of merging to be performed
%
%   EXAMPLE:
%   inputing the values missing in worspace3b.m data merged using
%   the mean of each row:
%
%   merged = fetch_all_vars(varsdraw, varskeep, varsVARS)
%   fixed = fix_missing(merged)
%
%   See also merge_visits, findvar.

    if nargin < 2
        method = 'mode';
    end
    [n_subjs, n_vars] = size(data);
    
    for var = 1:n_vars
        missing = isnan(data(:, var));
        
        if strcmp(method, 'mean')
            fixed_val = mean(data(~missing, var));
        elseif strcmp(method, 'mode')
            fixed_val = mode(data(~missing, var));
        else
            fprint(' !!! ERROR !!! Method not implemented!\n');
            break
        end
        data(missing, var) = fixed_val;
    end
end
