function loc = findvar(bb_id, var_names, keep)
% FINDVAR finds a variable given its Biobank identifier as
% described in the html file in
% /vols/Data/HCP/BBUK/SMS/old/ukb6225.thml
%
%    Usage: y = findvar(bb_id, var_names, keep)
%
%    bb_id = biobank id string
%    var_names = cell from which we will extract the variable
%    keep = index of variables to keep
%    y = returned variables
%
%    EXAMPLE:
%    Finding sleep duration
%    SleepDuration = findvar('1160-',varsVARS, varskeep)
%
%    See also steveOriginalReadme.

var_ids = nets_cellfind(var_names, bb_id);  % Find the variable
[~, loc, ~] = intersect(keep, var_ids);     % Filter by keep
end