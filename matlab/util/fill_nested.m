function [data, names] = fill_nested(varargin)
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

    % Retrieve input parameters
    data = varargin{1};
    u_names = varargin{2};
    parent1 = varargin{3};
    parent2 = varargin{4};
    parval1 = varargin{5};
    parval2 = varargin{6};
    bbuk_levels = varargin{7};
    new_levels = varargin{8};
    processing = varargin{9};
    
    [n_subs, n_vars, n_visits] = size(data);
    
    for var = 1:n_vars
        if processing(var) == 1 % Only gaussianise
            
            % Get parent information
            if parent1(var) ~= 0 && parent2(var) ~= 0
                data = inherit(data, var, u_names, ...
                               parent1(var), parent2(var), ...
                               parval1{var}, parval2{var});
            end
            
            % Change levels if needed
            data(:, var, :) = change_encoding(data(:, var, :), ...
                                              bbuk_levels{var},...
                                              new_levels{var});
            
        elseif processing(var) == 2 % Remove
            
            % Remove variable
            idx = 1:n_vars ~= var;
            data = data(:,idx, :);
            u_names = u_names(idx);
            
            n_vars = n_vars - 1;
            
        elseif processing(var) == 3 % Set Missing to 0 and gaussianise
            
            % Get parent information
            if parent1(var) ~= 0 && parent2(var) ~= 0
                data = inherit(data, var, u_names, ...
                               parent1(var), parent2(var), ...
                               parval1{var}, parval2{var});
            end
            % Change levels if needed
            data(:, var, :) = change_encoding(data(:, var, :), ...
                                              bbuk_levels{var},...
                                              new_levels{var});
            % Set missing to zero
            aux = data(:, var, :);
            aux(isnan(aux)) = 0;
            data(:, var, :) = aux;
        else
            Error = MException('fill_nested:InvalidAction',...
                               'Unkown processing value %d.', ...
                               processing(var));
            throw(Error);
        end
    end
end
