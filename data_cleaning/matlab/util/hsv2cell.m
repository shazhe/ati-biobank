function y = hsv2cell(x)
% HSV2CELL Splits a hash-separeted cell array into a cell aray of
% vectors.
%
% USAGE: y = hsv2cell(x)
%
% where:
%     x: is a N by 1 cell array of hash-separeted strings of integers
%     y: is a K by 1 cell array of integer vectors
%
% See also: load_actions.

    n_x = length(x);
    y = cell(n_x, 1);
    
    for entry = 1:n_x
        if ischar(x{entry})
            % if only one character then cast directly
            y{entry} = [int32(str2num(x{entry}))];
        else
            % split the string ...
            split = strsplit(x{entry});
            n_levels = length(splitted);
            
            % ... and cast each individual item
            aux = zeros(n_levels, 1);
            for num = 1:n_levels
                aux(num) = int32(str2num(split{num}));
            end
            
            y{entry} = aux;
        end
    end
    
end