function x = change_encoding(x, y, z)
% CHANGE_ENCODING Changes the encoding of variable x from the
% values in y to the values in z
%
% USAGE: new_x = substitute(x, y, z)
%
% where:
%     x: is a N by M data matrix
%     y: is a K by 1 vector of the old nominal encodings (x values)
%     z: is a K by 1 matrix of the new nominal encodings (x values)
%
% See also: fill_nested, substitute.

    n_levels = length(y);
    
    % Check if any entry of z is in y
    not_in_sets = max(z) + max(y) + 1; % token that is neither on z
                                       % nor on y to guarantee
                                       % level id uniqueness.
    for entry  = 1:n_levels
	    if sum(z == y(entry)) > 0
		    x(x == y(entry)) = not_in_sets; % replace in x and y
		    y(entry) = not_in_sets;
		    not_in_sets = not_in_sets + 1; % update token
        end
    end
    
    % Perform the substitutitions
    for entry = 1:n_levels
	    x(x == y(entry)) = z(entry);
    end
    
end