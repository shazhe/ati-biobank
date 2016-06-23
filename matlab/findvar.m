function loc = findvar(bb_id, data, idx)
% FINDVAR finds a variable given its Biobank identifier as
% described in the html file in
% /vols/Data/HCP/BBUK/SMS/old/ukb6225.thml
%
%    Usage: y = findvar(bb_id, data, idx)
%
%    bb_id = biobank id string
%    data = dataset from which we will extract the variable
%    idx = index of variables to keep
%    y = returned variables
%
%    Example: Finding sleep duration
%    SleepDuration = findvar('1160-', varskeep)
%
%    See also steveOriginalReadme.

var_ids = nets_cellfind(data, bb_idx);  % Find the variable IDs
[~, loc, ~] = intersect(idx, var_ids);  % intersection
end