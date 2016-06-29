function [var, col] = get_var(data, names, varname)
% GET_VAR Gets the variable corresponding to a column of matrix of
% data
%
% USAGE: var = get_var(data, names, varname)
%
% where:
%     data is the data matrix
%     name is the variable id number vector
%     varname is the variable id to be looked up
%
% See also: findvar.
    
    for col = 1:length(names)
        if strcmp(names(col), varname)
            break
        end
    end
    
    var = data(:, col);
end