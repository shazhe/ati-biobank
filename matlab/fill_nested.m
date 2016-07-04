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
        if rule(entry) == 1 % 
            data(:, var) = data(:, names == 30010) / ...
                data(:, names == 30000);
            
        elseif rule(entry) == 2
            data(:, var) = substitute(data(:, var), ...
                                      data(:, parent(var)), ...
                                      NaN);
            % Change levels if needed
            
            % Gaussianise
            data(:, var) = inormal(data(:, var));
            
        elseif rule(entry) == 3
            
        elseif rule(entry) == 4
        elseif rule(entry) == 5
            Error = MException('fill_nested:InvalidAction',...
                               'Unkown rule value %d.', ...
                               rule(var));
            throw(Error);
              case 1 % Simple copy from parent value
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
            end
        end
    end
end