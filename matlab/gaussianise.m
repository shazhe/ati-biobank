function p_data = gaussianise(data, subjects, features, confounds)
% GAUSSIANISE removes confounding variables through the
% Gaussianisation process, see [1].
%
% USAGE: p_data = gaussianise(data, subjects, features, confounds)
%
% Here we first apply the inverse-normal transformation to the data
% for then iteratively removing the effects of the confounders from
% the main data. This proceeds in fast-ICA fashion.
%
% where:
%   * data is the data matrix of all subjects x all variables
%   * subjects is a boolean vector of the subjects we will consider
%   (and restrict to) in our analysis.
%   * features is a boolean vector of the observed variables we
%   will consider (and restrict to) in our analysis.
%   * confounds is a vector of the confounds we wish to remove from
%   our data.
%
% References:
% [1] Chen, S. S. S., & Gopinath, R. A. (2001). Gaussianization. In
% T. K. Leen, T. G. Dietterich, & V. Tresp (Eds.), Advances in
% Neural Information Processing Systems 13 (pp. 423–429). MIT
% Press.
%
% See also: inorma, pinv.

f_data = inormal(data(subjects, features)); % filtered data
p_data = filtered; % processed data

% process all variables
for cc = 1:length(features)
    % Filter out NaNs from processed data
    no_nans = ~isnan(p_data(:, cc));

    % Remove the means from confound values
    conf = demean(confounds(no_nans));
    
    % Get the confounding effect on other variables by projection
    conf_effect = conf * (pinv(conf) * f_data(no_nans, cc));
    
    % Remove the effect from the database
    p_data(no_nans, cc) = nets_normalise(f_data(no_nans, cc) - ...
                                         conf_effect);
end

end