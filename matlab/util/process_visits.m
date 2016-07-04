function [cube, u_names] = process_visits(data, names, keep, method)
% MERGE_VISITS Merges the different visits into a single index.
%
%   USAGE: merged = process_visits(data, keep, bb_names, method)
%
%   where:
%       data is the dataset with all visits
%       names is the array with the biobank variable numerical ids
%       method is a string with the type of merging to be performed
%
%   See also: merge_visits (deprecated).

    % basic information
    n_subs = size(data);
    n_vars = size(keep);

    % find unique names
    u_names = unique(names(keep), 'stable');
    n_names = size(u_names);

    % find number of name repetitions
    n_visits = reps(u_names, names(keep));

    % allocate data cube
    cube = zeros(n_subs, n_names, max(n_visits)) * NaN;

    % fill in data cube
    for id = 1:n_names
        cube(:, id, 1:n_visits(id)) = data(:, u_name(id) == names);
    end

end
