%% CLEAN_WORKSPACE3B.m
% Load and clean up the raw data from workspace3b.mat

clear; clc;
addpaths;   % Adds the relevant paths

%% Load variables
fprintf('Loading variables... \n');
work3b = matfile('/vols/Data/HCP/BBUK/workspace3b.mat');

dirty = work3b.vars;                  % Variables before cleaning
allnames = get_id(work3b.varsVARS);      % Variable names
keep = work3b.varskeep;               % Keep all variables

clearvars work3b
fprintf('OK!\n');

%% Load cleaning protocol
fprintf('Loading cleaning protocol... \n')
[names, parent1, parent2, parent1_vals, parent2_vals, bbuk_levels, new_levels, processing] = load_actions();
fprintf('OK!\n')

%% Create data cube of subjects x variables x visits
fprintf('Creating cube... \n');

[data, u_names] = process_visits(dirty, keep, allnames);

fprintf('OK!\n');

%% De-nesting to remove missing data not missing
fprintf('De-nesting variables...\n');

keyboard;
data = fill_nested(data, u_names, names, parent1, parent2, parent1_vals, parent2_vals, bbuk_levels, new_levels, processing);

fprintf('OK!\n');

%% Saving
fprintf('Saving... ');

save('cleaned3b.mat', ...
     'data', 'dirty', 'raw', 'keep', 'names', 'u_names');
 
fprintf(' OK!\n')

fprintf('All done! :D \n')
