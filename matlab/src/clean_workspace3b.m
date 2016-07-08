%% CLEAN_WORKSPACE3B.m
% Load and clean up the raw data from workspace3b.mat

clear; clc;
addpaths;   % Adds the relevant paths

%% Load variables
fprintf('Loading variables... \n');
work3b = matfile('/vols/Data/HCP/BBUK/workspace3b.mat');

dirty = work3b.vars;                  % Variables before cleaning
allnames = get_id(work3b.varsVARS);   % Variable names
keep = work3b.varskeep;               % Keep all variables

clearvars work3b
fprintf('OK!\n');

%% Load cleaning protocol
fprintf('Loading cleaning protocol... \n')
[names, parent1, parent2, parval1, parval2, bbuk_levels, new_levels, processing] = load_actions();
fprintf('Loading OK!\n')

%% Create data cube of subjects x variables x visits
fprintf('Creating cube... \n');

%[data, u_names] = process_visits(dirty, keep, allnames, processing);
[data, u_names] = merge_visits2(dirty, keep, allnames, processing);

fprintf('Cube creation OK!\n');

%% De-nesting to remove missing data not missing
fprintf('De-nesting variables...\n');

fprintf(['Total number of NaNs *before* de-nesting: ', ...
         num2str(sum(isnan(data(:)))), '.\n']);

data = fill_nested(data, u_names, parent1, parent2, parval1, parval2, bbuk_levels, new_levels, processing);

fprintf(['Total number of NaNs *after* de-nesting: ', ...
         num2str(sum(isnan(data(:)))), '.\n']);

fprintf('De-nesting OK!\n');

%% Saving
fprintf('Saving... ');

save('cleaned3b.mat', ...
     'data', 'dirty', 'keep', 'names', 'u_names');
 
fprintf('Saving OK!\n')

fprintf('All done! :D \n')
