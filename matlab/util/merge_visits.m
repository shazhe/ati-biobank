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

    for i = 1:length(u_names)
	      datatemp = data(:, bb_names == u_names(i));
	if strcmp(method, 'last') 	   
          idxmat = repmat(1:size(datatemp,2), size(datatemp,1),1);
           namat = ~isnan(datatemp);
           lastVist = max(namat .* idxmat,[],2);

            for j = 1:length(lastVist) 
		if lastVist(j) < 1
		   merged(j,i) = NaN;
		else
		   merged(j,i) = datatemp(j,lastVist(j));
                 end
             end
	  elseif strcmp(method, 'mean')
                 merged(:,i) = nanmean(datatemp, 2);
          elseif strcmp(method, 'first')
	    merged(:,i) = datatemp(:,1);
          elseif strcmp(method, 'visit')
	    merged(:,i) = datatemp(:,end);
	    else
                        fprint([' !!! ERROR !!! Method not ' ...
                                'implemented!\n']);
          end
end
		    num_nans = sum(sum(isnan(merged)));
    if num_nans > 0 && displayNaN
        fprintf(['Total number of NaN entries: ', num2str(num_nans), ...
                 ' (= ', num2str(num_nans / numel(merged(:)) * 100), ')\n']);
    end

end
