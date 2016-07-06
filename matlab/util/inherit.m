function data = inherit(varargin)
% INHERIT Gets the relational data from both parents and 
% combines it into a vector for the cases it is not missing.
%
% USAGE: data = join_parents(data, parent1, parent2,...
%                            values1, values2)
% 
% where:
%     data: a N by 1 vector of the condensed information from
%           both parents.
%     parent1: N by 1 vector of the observed 1st parent values.
%     parent2: N by 1 vector of the observed 2nd parent values.
%     values1: values considered for the 1st parent. 
%     values1: values considered for the 2nd parent. 
%
% See also: fill_nested.

    % inputs
    data = varargin{1};
    var = varargin{2};
    u_names = varargin{3};
    par1 = varargin{4};
    par2 = varargin{5};
    val1 = varargin{6};
    val2 = varargin{7};

    [n_subs, n_vars, n_visits] = size(data);
    n_val1 = length(val1);
    n_val2 = length(val2);

    % Extract the parents when available
    if par1 == 0
        par1_data = NaN .* ones(n_subs, 1);
    else
        par1_data = data(:, u_names == par1, :);
    end
      
    if par2 == 0
        par2_data = NaN .* ones(n_subs, 1);
    else
        par2_data = data(:, u_names == par2, :);
    end

    % Inheriting by keeping appropriate indexes
    idx_par1 = zeros(n_subs, 1);
    for entry = 1:n_val1
    	idx_par1 = or(idx_par1, par1 == val1(entry));
    end

    idx_par2 = zeros(n_subs, 1);
    for entry = 1:n_val2
        idx_par2 = or(idx_par2, par2 == val2(entry));
    end

    idx = and(idx_par1, idx_par2);
    
    % Substitute into the data
    data(idx, var, :) = ...
        substitute(data(idx, var, :), ...
                   zeros(n_subs, n_vars, n_visits), ...
                   NaN);
end
