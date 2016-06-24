%% CLEAN_DATA.m
% Load and clean up the data, then save it
%     --- still within the server --- 
% to unify the set we will be working on.

addpaths;   % Adds the relevant paths
loady;      % Loads the raw data file

% Create some aliases for interpretability
names = varsVARS;
keep = varskeep;
raw = varsdraw;

fprintf('Merging visits... ');
merged = merge_visits(raw, keep, names);
fprintf('OK!\n');

fprintf('Fixing missing data... ');
data = fix_missing(merged);
fprintf('OK!\n');

fprintf('Saving... ');

%path = cd('/vols/Data/HCP/BBUK/');

save('cleanedDataset.mat', 'data', 'merged', 'raw', 'keep', 'names');

%cd(path);

fprintf('All done! :D \n')

clear; % Remove all non-important data

load_unique;