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
    %var = varargin{2};
    par1 = varargin{2};
    par2 = varargin{3};
    vals1 = varargin{4};
    vals2 = varargin{5};

    n_subs = length(parent1);
    n_val1 = length(vals1);
    n_val2 = length(vals2);

    % Deal with variables without parents
    if par1 == 0 % empty vector
        par1 = NaN * ones(n_subs, 1);
    else
        par1 = data(name(par1));
    end
      
    if par2 == 0 % empty vector
        par2 = NaN * ones(n_subs, 1);
    else
        par2 = data(name(par2));
    end

    % Inheriting by keeping appropriate indexes
    
    info = ones(n_subs, 1) * NaN;

    idx_par1 = zeros(n_subs, 1);
    for entry = 1:n_val1
    	idx_par1 = or(idx_par1, par1 == vals1(entry));
    end

    idx_par2 = zeros(n_subs, 1);
    for entry = 1:n_val2
        idx_par2 = or(idx_par2, par2 == vals2(entry));
    end

    idx_info = and(idx_par1, idx_par2);

    info(~idx_info) = 0;
    
    % Substitute into the data
    
    data(:, :, var) = substitute(data(:, :, var), ...
                                 data(:, :, parent(var)), ...
                                 NaN);	  
end
