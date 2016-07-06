function [new_data, new_names] = make_dummies(data, names, ...
                                              varname, n_levels)
% MAKE_DUMMIES function to make dummy variables to account for the
% nominal data fields.
%
% USAGE: [new_data, new_names] = make_dummies(data, names, ...
%                                             varname, n_levels)
%
% where:
%     data: matrix of N subjects by M variables
%     names: 
%     varname: name of the varible
%     nlevels: number of levels the nominal variable can assume
%
% See also: findvar, get_var.

    n_subs = size(data, 1);
    var = get_var(data, names, varname);
    
    % Make the dummy variables
    new_var = dummyvar(var);
    new_var = new_var(:, 1:end-1);
    
    % New variable names will be the same name as the original plus
    % the level indicated by the two first decimal places.
    % Fixme: This is not ideal as fixed point comparisons are not
    % exact, but one can multiply by 100 round to the nearest
    % integer and then compare exactly.
    new_var_names = varname + (1:n_levels - 1) * 1.E-2;
    
    % update data matrix and name array
    new_data = [data(:,names(names ~= varname)), new_var];
    new_name = [names(names ~= varname), new_var_names];
end