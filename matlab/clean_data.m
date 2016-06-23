%% CLEAN_DATA.m
% Load and clean up the data, then save it
%     --- still within the server --- 
% to unify the set we will be working on.

addpaths;   % Adds the relevant paths
loady;      % Loads the raw data file

% Create some aliases for interpretability
names = varsVARS;
vars = varskeep;
raw = varsdraw;

fprintf('Merging visits... ');
merged = merge_visits(raw, vars, names);
fprintf('OK!\n');

fprintf('Fixing missing data... ');
data = fix_missing(merged);
fprintf('OK!\n');

fprintf('Saving... ');
save('/vols/Data/HCP/BBUK/cleanedDataset.mat', ...
     'data', 'raw', 'vars', 'names');

fprintf('All done! :D \n')
clean;