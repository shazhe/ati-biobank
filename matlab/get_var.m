function var = get_var(mat, names, varname)
% GET_VAR Gets the variable corresponding to a column of matrix of
% data
    for col = 1:length(names)
        code = strsplit(names{col}, '-');
        if strcmp(code{1}, varname)
            break
        end
    end
    
    var = mat(:, col);
end