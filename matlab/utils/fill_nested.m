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
        if rule(entry) == 1 % Only gaussianise

            info = join_parents(par1(var), par2(var), val1(var), val2(var));

            data(:, var) = substitute(data(:, var), ...
                                      data(:, parent(var)), ...
                                      NaN);

            % Change levels if needed
            data(:, var) = change_encoding(data(:, var));
            
            % Gaussianise
            data(:, var) = inormal(data(:, var));
            
        elseif rule(entry) == 2 % Remove
            data = data(:,1:n_vars ~= var);
            
        elseif rule(entry) == 3 % Set Missing to 0 and gaussianise
            data(:, var) = substitute(data(:, var), ...
                                      zeros(size(data(:, var))), ...
                                      NaN);
        else
            Error = MException('fill_nested:InvalidAction',...
                               'Unkown rule value %d.', ...
                               rule(var));
            throw(Error);
        end
    end
end
