function y = prep_processing(x)
% PREP_PROCESSING Substitutes the standard strings used in the csv
% file to indicate the processing by integer codes.
%
% USAGE: y = prep_processing(x)
%
% where:
%     x: is a N by 1 cell array of strings
%     y: is a K by 1 vector of integers
%
% See also: fix_encodings, fill_nested.

    n_x = length(x);
    y = zeros(n_x, 1);
    
    for entry = 1:n_x

        if strcmp(x{entry}, ...
                  'Only gaussianise')
            y(entry) = 1;
                
        elseif strcmp(x{entry}, ...
                      'Remove')
            y(entry) = 2;
                
        elseif strcmp(x{entry}, ...
                      'Set Missing to 0 and gaussianise')
            y(entry) = 3;
        else
            Error = MException('fill_nested:InvalidAction',...
                               'Unkown rule value %d.', ...
                               rule(var));
            throw(Error);
        end
    end
   
end