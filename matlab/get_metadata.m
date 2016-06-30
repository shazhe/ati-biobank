function [metadata, missing] = get_metadata(names, description)
% GET_METADATA extracts the metadata for the variables of interest
% from the original varsHTML description.
%
% USAGE: [metadata, missing] = get_metadata(names, description)
%
% where:
%     metadata is a cell array with the variable information
%     missing is the array with the entries of names that have no
%             available metadata in description
%     names is the array with the id number of the variables we
%           want to retrieve metadata
%     description is the variable metadata following to the
%                 varsHTML formatting.
%
% EXAMPLE: [metadata, missing] = get_metadata(names, varsHTML)
%
% See also: steveOriginalReadme.
    
% preallocate metadata
metadata = cell(size(names));
n_desc = size(description, 1);

% preprocess descriptions
for desc_entry = 3:n_desc
    code = strsplit(description{desc_entry, 2}, '-');
    description{desc_entry, 2} = str2num(code{1});
    
    % Account for cases where there are multiple visits
    if isempty(description{desc_entry, 4})
        description{desc_entry, 4} = description{desc_entry - 1, 4};
    end
    
end

% generate metadata for the variables considered
missing = [];
for name_entry = 1:size(names, 1)
    
    % Search for a description match
    desc_entry = 3;
    while description{desc_entry, 2} ~= names(name_entry) && ...
            desc_entry < n_desc
        desc_entry = desc_entry + 1;
    end
        
    if desc_entry >= n_desc
        fprintf('!!! Warning - Variable not found !\n');
        missing = [missing, name_entry];
    else    
        metadata{name_entry} = description{desc_entry, 4};
    end
end

end