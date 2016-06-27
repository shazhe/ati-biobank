%% CLEAN_RAW_DATA.m
% Load and clean up the raw, not deconfounded data, then save it
%     --- still within the server --- 
% to unify the set we will be working on.

addpaths;   % Adds the relevant paths
loady;      % Loads the raw data file

% Create some aliases for interpretability
names = varsVARS;
keep = varskeep;
raw = vars(K, varskeep); % no gaussianisation
desc = varsHTML;

fprintf('Merging visits... ');
[merged, u_names] = merge_visits(raw, keep, names);
fprintf('OK!\n');

fprintf('Fixing missing data... ');
data = fix_missing(merged);
fprintf('OK!\n');

fprintf('Getting metadata... ');
[meta, no_desc] = get_metadata(u_names, desc);
fprintf('OK!\n');

fprintf('Adding age and gender to the dataset');
data = [data, age, sex];
meta = {meta{:}, 'Integer', 'Categorical (single)'}';
u_names = {u_names{:}, '34-', '31-'};
fprintf('OK!\n')


fprintf('Saving... ');

%path = cd('/vols/Data/HCP/BBUK/');

save('cleanedRawDataset.mat', ...
     'data', 'merged', 'raw', 'keep', 'names', 'u_names', 'meta', ...
     'no_desc');


%cd(path);

fprintf('All done! :D \n')

clear; % Remove all non-important data

load_raw_clean;