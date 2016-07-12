function varargout = create_test_data(varargin)
% CREATE_TEST_DATA Creates data for testing cases.
%
% This function creates a small dataset that resembles the formatting of
% the UK-Biobank dataset in workspace3b to allow local function testing
% (i.e. you can use this pseudo-dataset to test your functions locally
% without compromising the confidentiality of the true dataset).
%
% USAGE: [data, varsVARS] = create_test_data(n_vars, n_visits)
    
    if nargin < 1
        n_vars = 10;
        n_visits = 3;
        n_data = 20;
    else
        n_vars = varargin{1};
        n_visits = varargin{2};
        n_data = varargin{3};
    end
    
    var_ids = randi(100000, [1, n_vars]);
    var_rep = randi(n_visits, [1, n_vars]);
    
    % Initialisation
    varsVARS = {};
    vars = [];
    parent1 = [];
    parent2 = [];
    parval1 = [];
    parval2 = [];
    
    % Data generation
    nn = 1;  % lazy indexing
    for vv = 1:n_vars
        
        var_type = rand();  % decide variable type
        
        has_parent1 = randn() > 0.5;  % decide nesting
        has_parent2 = randn() > 0.7;
        if has_parent1
            parent_vars = randsample(var_ids, 2);
            pa1 = parent_vars(1);
            
            if has_parent2
                pa2 = parent_vars(2);
            else
                pa2 = 0;
            end
        else
            pa1 = 0;
            pa2 = 0;
            has_parent2 = 0;
        end
        
        parent1 = [parent1, has_parent1];
        parent2 = [parent2, has_parent2];
        parval1 = [parval1, pa1];
        parval2 = [parval2, pa2];
        
        for ii = 1:var_rep(vv)
            
            varsVars{nn} = [num2str(var_ids(vv)), '-', num2str(ii)];
            
            if var_type == 0
                new_data = randn(n_data, 1);
            else
                new_data = randi(10, [n_data, 1]);
            end
            
            vars = [vars, new_data];
            
            nn = nn + 1;
        end
        
    end
    
    % Output
    if nargout > 1
        varargout{1} = vars;
        varargout{2} = varsVARS;
        varargout{3} = parent1;
        varargout{4} = parent2;
        varargout{5} = parval1;
        varargout{6} = parval2;
    else
        save('pseudo.mat', 'vars', 'varsVARS', 'var_ids', ...
            'parent1', 'parent2', 'parval1', 'parval2');
    end
end