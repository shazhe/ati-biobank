function y = prep_missing(x)
% PREP_MISSING Substitutes the standard strings used in the csv
% file to indicate the missing value encodings by integer codes.
%
% USAGE: y = prep_missing(x)
%
% where:
%     x: is a N by 1 cell array of strings
%     y: is a K by 1 vector of integers
%
% See also: fix_encodings.

    n_x = length(x);
    y = zeros(n_x, 1);
    
    for entry = 1:n_x
        
        if strcmp(x{entry}, ...
                  'Continuous')
            y(entry) = 0;
            
        elseif strcmp(x{entry}, ...
                      'Binary')
            y(entry) = 1;
            
        elseif strcmp(x{entry}, ...
                      'Discrete')
            y(entry) = 2;
            
        elseif strcmp(x{entry}, ...
                      'Ordinal')
            y(entry) = 3;
            
        elseif strcmp(x{entry}, ...
                      'Nominal')
            y(entry) = 4;
        else
            Error = MException('prep_vartype:InvalidType',...
                               'Unkown x value %d.', ...
                               x{entry});
            throw(Error);
        end
        
    end
    
end
