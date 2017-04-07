function loc = findvar(bb_id, var_names, keep)
% FINDVAR finds a variable given its Biobank identifier as
% described in the html file in
% /vols/Data/HCP/BBUK/SMS/old/ukb6225.thml
%
%    Usage: y = findvar(bb_id, var_names, keep)
%
%    where:
%        bb_id = biobank id number
%        var_names = cell from which we will extract the variable
%        keep = index of variables to keep
%        y = returned variables
%
%    EXAMPLE:
%        Finding sleep duration
%        SleepDuration = findvar(1160, name, keep)
%
%    See also steveOriginalReadme, get_var.

    var_ids = (var_names == bb_id);  % Find the variable
    [~, loc, ~] = intersect(keep, var_ids);     % Filter by keep
end