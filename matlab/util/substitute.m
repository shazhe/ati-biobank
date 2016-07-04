function x = substitute(x, y, z)
% SUBSTITUTE Substitutes the entries in x that are have value z
% with the corresponding entries of y. Different from usual
% equivalence operator, this function is able to handle inf and nan
% tokens.
%
% USAGE: new_x = substitute(x, y, z)
%
% where:
%     x: is a N by M matrix with unwanted values
%     y: is a N by M matrix with values to be copied into x
%     z: x entries with value z will be replaced by the respective
%     entries in y.
%
% EXAMPLE:
%     Replace the NaN values in x by the corresponding values in y
%     fixed_x = substitute(x, y, NaN);
%
% See also: fix_encodings.

    % Find indices
    if isnan(z)
	    idx = isnan(x);
    elseif isinf(z)
	    idx = isinf(x);
    else
	    idx = x == z;
    end

    % Apply the substitution
    x(idx) = y(idx);
end