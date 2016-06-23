function p_data = merge_visits(data, keep, bb_names, mfunc)
% MERGE_VISITS Merges the different visits into a signle index.
%
%   USAGE: p_data = fetch_all_vars(data, subjects, keep, bb_names, mfunc)
%   data = biobank gaussianised variables
%   keep = index vector of desired variable
%   bb_names = cell array with the biobank variable names
%   mfunc = string with the type of merging to be performed
%
%   EXAMPLE:
%   using workspace3b.mat file, to get all gaussianised data merged
%   using the mean:
%   p_data = fetch_all_vars(varsdraw, varskeep, varsVARS)
%
%   See also findvar.

if nargin < 4
    mfunc = 'mean';              % default merging through the mean

n_names = length(bb_names);      % number of variable names
n_subjs = size(data,1);          % number of subjects in the data
p_data = zeros(n_subjs, n_names);% preallocate database

% Loop through all available names
for name_entry = 1:n_names
    % get the variable name irrespective of the visits
    var_name = strsplit(bb_names{name_entry}, '-');
    
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
            if mfunc == 'mean'           
                p_data(subject, name_entry) = mean(raw_entries);
            elseif m_func == 'last'
                p_data(subject, name_entry) = raw_entries(end);
            end
        else
            % No valid entry, thus keep it at NaN
            p_data(subject, name_entry) = NaN;
        end
    end
    
end

end