function merged = merge_visits2(data, method, displayNaN)
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

if nargin < 3
        displayNaN = true;              % display output.
end

if strcmp(method, 'mean')
    merged = nanmean(data, 3);
elseif strcmp(method, 'first')
    merged = data(:,:, 1);
elseif strcmp(method, 'visit')
    merged = data(:,:, end);
elseif strcmp(method, 'last')
    nnamat = ~isnan(data);
    nnamat(:,:,1) = 1;
    for i = 1: size(data,1)
        for j = 1:size(data,2)
            merged(i,j)= data(i, j, find(nnamat(i, j, :), 1, 'last'));
        end
    end
else
    fprint([' !!! ERROR !!! Method not implemented!\n']);
end

  num_nans = sum(sum(isnan(merged)));

  if num_nans > 0 && displayNaN
      fprintf(['Total number of NaN entries: ', num2str(num_nans), ...
                 ' (= ', num2str(num_nans / numel(merged(:)) * 100), ')\n']);
    end

end
