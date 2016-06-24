function merged = merge_visits(data, keep, bb_names, method)
% MERGE_VISITS Merges the different visits into a signle index.
%
%   USAGE:
%   merged = merge_visits(data, keep, bb_names, method)
%
%   data = biobank gaussianised variables
%   keep = index vector of desired variable
%   bb_names = cell array with the biobank variable names
%   method = string with the type of merging to be performed
%
%   EXAMPLE:
%   using workspace3b.mat file, to get all gaussianised data merged
%   using the mean:
%   merged = fetch_all_vars(varsdraw, varskeep, varsVARS)
%
%   See also findvar, fix_missing.

if nargin < 4
    method = 'mean';              % default merging through the mean
end

n_names = length(keep);          % number of variable names
n_subjs = size(data,1);          % number of subjects in the data
merged = zeros(n_subjs, n_names);% preallocate database

% Loop through all available names
for name_entry = 1:n_names
    % get the variable name irrespective of the visits
    var_name = strsplit(bb_names{keep(name_entry)}, '-');
    var_name = strcat(var_name{1}, '-');
    
    % get the locations for the variable var_name
    loc = findvar(var_name, bb_names, keep);
    
    % Loop through subjects
    for subject = 1:n_subjs
        % get all raw entries.
        raw_entries = data(subject, loc);
        
        % remove NaNs from the raw entries
        raw_entries = raw_entries(~isnan(raw_entries));
        
        % Apply the merging function
        if ~isempty(raw_entries)
            % There are valid entries to consolidate
            if method == 'mean'           
                merged(subject, name_entry) = mean(raw_entries);
            elseif method == 'last'
                merged(subject, name_entry) = raw_entries(end);
            else
                fprint(' !!! ERROR !!! Method not implemented!\n');
            end
        else
            % No valid entry, thus keep it at NaN
            merged(subject, name_entry) = NaN;
        end
    end
    
end

end
