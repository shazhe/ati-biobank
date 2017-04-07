function idx = get_indices(all_names, u_names)
% GET_INDICES Finds the indexes of u_names in all_names.
% u_names 
%
%   USAGE: idx = get_indices(all_names, u_names)
%
%   where:
%       all_names is the array with the all biobank variables
%       u_names is the array with the variables to look up
%       idx is the array of indices to look up
%
    n_u = length(u_names);
    n_a = length(all_names);

    idx = zeros(size(all_names));
    for ii = 1:n_u
        idx = idx + (all_names == u_names(ii));
    end

end