function data = fill_nested(data, parent, rule, params)
% FILL_NESTED Fills in the missing data due to nested queries in
% the biobank (that is, missing data in variables that only occur
% when you supply a specific answer in a parent question).
%
% USAGE: data = fill_nested(data, parents, rule, params)
% 
% where:
%     data: is a N subjects x  M variables data matrix.
%     parent: is a 1 x M vector indicating the parents of a given
%              variable (0 if root parent).
%     rule: is a 1 x M vector with the encoded treatment following
%     params: is a M x 1 additional parameter cell array for each
%     variable (empty when no action should be taken).
%
% See also: fix_encodings.

    [n_subs, n_vars] = size(data);
    
    for var = 1:n_vars
	    if parent(var) ~= 0 % if not a root node
		    switch rule(var)
		        case 1 % Simple copy from parent value
		            data(:, var) = substitute(data(:, var), ...
		                                      data(:, parent(var)), ...
		                                      NaN);
		        case 2 % Two parent variables
		        
		            % TODO: This function needs fixing.
		            
		            % Get parent data
		            pa1 = data(:, params{var, 1});
		            pa2 = data(:, params{var, 2});
		            
		            % Get values allowed
		            val_pa_1 = params{var, 3};
		            val_pa_2 = params{var, 4};
		            
		            % Find cases where influence was not respected
		            data(:, var) = substitute(data(:, var), ...
		                                      data(:, parent(var)), ...
		                                      NaN);
		        otherwise % Unknow rule case
		            Error = MException('fill_nested:InvalidAction',...
		                               'Unkown rule value %d.', ...
		                               rule(var));
		            throw(Error);
            end
        end
    end
end