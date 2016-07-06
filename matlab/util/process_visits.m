function [cube, u_names] = process_visits(data, keep, bb_names)
% PROCESS_VISITS Merges the different visits into a single index.
% MERGE_VISITS Merges the different visits into a single index.
%
%   USAGE: merged = process_visits(data, keep, bb_names)
%
%   where:
%       data is the dataset with all visits
%       keep is the index vector of the variables to analyse
%       bb_names is the array with the biobank variable numerical ids
%       names is the array with the biobank variable numerical ids
%       method is a string with the type of merging to be performed
%       displayNaN is a boolean indicating whether to display the
%                  number of NaN entries after merging.
%
%   See also: merge_visits (deprecated).

    % basic information
    n_subs = size(data, 1);
    n_vars = size(keep, 2);

    % find unique names
    u_names = unique(bb_names(keep), 'stable');
    n_names = size(u_names, 2);

    % find number of name repetitions
    n_visits = reps(u_names, bb_names(keep));

    % allocate data cube
    cube = zeros(n_subs, n_names, max(n_visits)) .* NaN;

    % fill in data cube
    for id = 1:n_names
        cube(:, id, 1:n_visits(id)) = data(:, u_name(id) == names);
    end

end
