function data = fix_encodings(data, rule)
% FIX_ENCODINGS Fix and standardise parent variable encodings so
% that msising values are listed always as NaN according to the
% substitution rule provided.
%
% USAGE: data = fix_encodings(data, rule)
% 
% where:
%     data: is a N subjects x  M variables data matrix.
%     rule: is a 1 x M vector with the encoded treatment following
%
% See also: fill_nested, prep_missing
    
    n_data = size(data, 1);
    
    for entry = 1:n_x
        
        if rule(entry) == 1 % 'Missing: -1 and -3'
            data(data == -1) = NaN;
            data(data == -3) = NaN;
            
        elseif rule(entry) == 2 % 'Missing: -1 and -3/ Less than one: -10'
            data(data == -1) = NaN;
            data(data == -3) = NaN;
            data(data == -10) = 0;
            
        elseif rule(entry) == 3 % 'Missing: -1 and -3/ Not applicable: -2'
            data(data == -2) = Inf;
            data(data == -1) = NaN;
            data(data == -3) = NaN;
            
        elseif rule(entry) == 4 % 'Missing: -1 and -3/ Not applicable: 99'
            data(data == 99) = Inf;
            data(data == -1) = NaN;
            data(data == -3) = NaN;
            
        elseif rule(entry) == 5 % 'Missing: 222 and 313'
            data(data == 222) = NaN;
            data(data == 313) = NaN;
            
        elseif rule(entry) == 6 %  'Missing: 352'
            data(data == 352) = NaN;
            
        elseif rule(entry) == 7 % 'Missing: 5 and negative values'
            data(data == 5) = NaN;
            data(data <  0) = NaN;
            
        elseif rule(entry) == 8 % 'Missing: 6 and negative values'
            data(data == 6) = NaN;
            data(data <  0) = NaN;
            
        elseif rule(entry) == 9 % 'Missing: 9'
            data(data == 9) = NaN;
            
        elseif rule(entry) == 10 % 'Negative values are missing'
            data(data < 0) = NaN;
            
        elseif rule(entry) == 11 % 'No missing values encoded'
            data(data < 0) = NaN;
            
        else
            Error = MException('fill_nested:InvalidAction',...
                               'Unkown rule value %d.', ...
                               rule(var));
            throw(Error);
        end
        
    end

end