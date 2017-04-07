function p_data = remove_confs(data, subjects, features, confounds)
% REMOVE_CONFS removes confounding variables by iterativelly
% fitting and removing effect.
%
% USAGE: p_data = remove_confs(data, subjects, features, confounds)
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
% See also: inormal, pinv.

     f_data = data(subjects, features); % filtered data
     p_data = filtered; % processed data

     % process all variables
     for cc = 1:length(features)
         % Filter out NaNs from processed data
         no_nans = ~isnan(p_data(:, cc));
    
         % Remove the means from confound values
         conf = demean(confounds(no_nans));
    
         % Get the confounding effect on other variables by projection
         conf_effect = conf * (pinv(conf) * f_data(no_nans, cc));
    
         % Remove the effect from the database and whiten the noise
         p_data(no_nans, cc) = nets_normalise(f_data(no_nans, cc) - ...
                                              conf_effect);
     end

end