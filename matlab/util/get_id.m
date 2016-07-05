function ids = get_id(bb_names)
% GET_ID Retrieves the numerical ids of a list of biobank
% variables in string format.
%
% USAGE: ids = get_var_id(bb_names)
%
% where:
%    ids is the numerical id list for the biobank variables
%    bb_names is the cell array containing the biobank variable
%    names
%
% See also: findvar.

    n_bb_names = length(bb_names);
    ids = zeros(1, n_bb_names);

    for entry = 1:n_bb_names
        var_name = strsplit(bb_names{entry}, '-');
        ids(entry) = str2num(var_name{1});
    end
    
end