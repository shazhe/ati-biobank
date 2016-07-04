function [merged, u_names]= merge_visits(data, keep, bb_names, ...
                                         method, displayNaN)
% MERGE_VISITS Merges the different visits into a single index.
%
%   USAGE: merged = merge_visits(data, keep, bb_names, method)
%
%   where:
%       data is the dataset with all visits
%       keep is the index vector of the variables to analyse (leave
%            empty, i.e. [], for keeping all variables)
%       bb_names is the array with the biobank variable numerical ids
%       method is a string with the type of merging to be performed
%       displayNaN is a boolean indicating whether to display the
%                  number of NaN entries after merging.
%
%   See also findvar, fix_missing.

    if isempty(keep)
        keep = unique(bb_names, 'stable');
    end

    if nargin < 5
        displayNaN = true;              % display output.
    end

    n_bb_names = length(keep);       % number of variable names
    n_subjs = size(data,1);          % number of subjects in the data

    % pre-process names
    indices = zeros(size(bb_names));
    for entry = 1:length(keep)
        % only keep relevant indexes
        indices = or(indices, bb_names == bb_names(keep(entry)));
    end
    
    % get unique items
    u_names = unique(bb_names(indices), 'stable');
    n_names = length(u_names);
    num_nans = 0;
    % Loop through all available names
    for name_entry = u_names
        % Loop through subjects
        for subject = 1:n_subjs
            
            raw_entries = data(subject, bb_names == u_name);
            
            if strcmp(method, 'visit') % last visit w/ nans
                
                merged(subject, name_entry) = raw_entries(end);
                
            else
                % Methods that remove nans
                raw_entries = raw_entries(~isnan(raw_entries));
                
                if ~isempty(raw_entries)
                    if strcmp(method, 'mean')           
                        merged(subject, name_entry) = ...
                            mean(raw_entries);
                        
                    elseif strcmp(method, 'last')
                        merged(subject, name_entry) = ...
                            raw_entries(end);
                        
                    elseif strcmp(method, 'first')
                        merged(subject, name_entry) = ...
                            raw_entries(1);
                        
                    else
                        fprint([' !!! ERROR !!! Method not ' ...
                                'implemented!\n']);
                    end
                else
                    % No valid entry, thus keep it at NaN
                    merged(subject, name_entry) = NaN;
                end
            end
            
            if isnan(merged(subject, name_entry))
                num_nans = num_nans + 1;
            end
            
        end
    end

    if num_nans > 0 && displayNaN
        fprintf(['Total number of NaN entries: ', num2str(num_nans), ...
                 ' (= ', num2str(num_nans / numel(merged(:)) * 100), ')\n']);
    end

end
