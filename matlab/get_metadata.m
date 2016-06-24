function metadata = get_metadata(names, description)
% GET_METADATA extracts the metadata for the variables of interest
% from the original varsHTML description.
%
% USAGE: metadata = get_metadata(names, description)
% where metadata is a cell array with the information, names are
% the variable names we wish to retrieve and description is the
% description according to the varsHTML variable.
%
% EXAMPLE: metadata = get_metadata(names, varsHTML)
%
% See also: steveOriginalReadme.
    
% preallocate metadata
metadata = cell(size(names));
n_desc = size(description, 1);

% preprocess descriptions
for desc_entry = 3:n_desc
    code = strsplit(description{desc_entry, 2}, '-');
    description{desc_entry, 2} = strcat(code{1}, '-');
    
    % Account for cases where there are multiple visits
    if isempty(description{desc_entry, 4})
        description{desc_entry, 4} = description{desc_entry - 1, 4};
    end
    
end

% generate metadata for the variables considered
for name_entry = 1:size(names, 1)
    
    % Search for a description match
    desc_entry = 1;
    while ~strcmp(description{desc_entry, 2}, names{name_entry}) && ...
            desc_entry < n_desc
        desc_entry = desc_entry + 1;
    end
    
    if desc_entry >= n_desc
        fprintf('!!! Error !!! Variable not found !\n');
        metadata{name_entry} = NaN;
    else    
        metadata{name_entry} = description{desc_entry, 4};
    end
end

end