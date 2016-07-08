function z = reps(x, y)
% REPS Counts the number of repetitions of x in an array y
%
% USAGE: z = reps(x, y)
%
% where:
%    x: 1 x M integers to be checked in y
%    y: 1 x N integer vector
%    z: 1 x M integer of counts
%
% See also: substitute.
    
    n_x = length(x);
    n_y = length(y);
    z = zeros(size(x));
    
    for x_i = 1:n_x

        if isnan(x_i)
            idx = isnan(y);
        elseif isinf(x_i)
            idx = isinf(y);
        else
            n_y = size(y, 1);
            idx = repmat(x(x_i), n_y, 1) == y;
        end
        
        z(x_i) = sum(idx);
    end
end