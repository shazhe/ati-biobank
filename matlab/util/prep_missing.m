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
                  'Missing: -1 and -3')
            y(entry) = 1;
            
        elseif strcmp(x{entry}, ...
                      'Missing: -1 and -3/ Less than one: -10')
            y(entry) = 2;
            
        elseif strcmp(x{entry}, ...
                      'Missing: -1 and -3/ Not applicable: -2')
            y(entry) = 3;
            
        elseif strcmp(x{entry}, ...
                      'Missing: -1 and -3/ Not applicable: 99')
            y(entry) = 4;
            
        elseif strcmp(x{entry}, ...
                      'Missing: 222 and 313')
            y(entry) = 5;
            
        elseif strcmp(x{entry}, ...
                      'Missing: 352')
            y(entry) = 6;
            
        elseif strcmp(x{entry}, ...
                      'Missing: 5 and negative values')
            y(entry) = 7;
            
        elseif strcmp(x{entry}, ...
                      'Missing: 6 and negative values')
            y(entry) = 8;
            
        elseif strcmp(x{entry}, ...
                      'Missing: 9')
            y(entry) = 9;
            
        elseif strcmp(x{entry}, ...
                      'Negative values are missing')
            y(entry) = 10;
            
        elseif strcmp(x{entry}, ...
                      'No missing values encoded')
            y(entry) = 11;

        else
            Error = MException('prep_missing:InvalidAction',...
                               'Unkown rule value %d.', ...
                               rule(entry));
            throw(Error);
        end
        
    end
    
end