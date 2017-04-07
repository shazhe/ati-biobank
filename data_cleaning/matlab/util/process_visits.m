function cube = process_visits(data, u_names, bb_names, processing)
% PROCESS_VISITS Merges the different visits into a single index.
%
%   USAGE: merged = process_visits(data, keep, bb_names, processing)
%
%   where:
%       data is the dataset with all visits
%       keep is the index vector of the variables to analyse
%       bb_names is the array with the biobank variable numerical ids
%       processing is the array of processing to avoid problems
%       when variables are to be removed
%
%   See also: merge_visits (deprecated).

    % basic information
    n_subs = size(data, 1);
    n_vars = length(bb_names);

    % find unique names
    n_names = length(u_names);

    % find number of name repetitions
    n_visits = reps(u_names, bb_names);
    max_visits = max(n_visits(processing ~= 2)); % all but the ones
                                                 % to be removed.
    % allocate data cube
    cube = zeros(n_subs, n_names, max_visits);

    % fill in data cube
    for id = 1:n_names
        cube(:, id, 1:n_visits(id)) = data(:, bb_names == u_names(id));
    end

end
