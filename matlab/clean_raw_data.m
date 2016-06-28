%% CLEAN_RAW_DATA.m
% Load and clean up the raw data (not gaussianised nor
% deconfounded) and save it
%     --- still within the server --- 
% to unify the set we will be working on.

addpaths;   % Adds the relevant paths
loady;      % Loads the raw data file

% Create some aliases for interpretability
dirty = vars;                  % Variables before cleaning
names = varsVARS;              % Variable names
desc = varsHTML;               % Variable descriptions
subs = K;                      % Keep only pre-selected subjects
keep = varskeep;               % Keep all variables
raw = vars(K, keep);           % Get the raw variables w/o
                               % gaussianisation and deconfounding.

fprintf('Merging visits... ');
[merged, u_names] = merge_visits(raw, keep, names);
fprintf('OK!\n');

fprintf('Fixing missing data... ');
data = fix_missing(merged, 'median');
fprintf('OK!\n');

fprintf('Getting metadata... ');
[meta, no_desc] = get_metadata(u_names, desc);
fprintf('OK!\n');

% $$$ fprintf('Adding age and gender to the dataset');
% $$$ data = [data, age(K), sex(K), ];
% $$$ meta = {meta{:}, 'Integer', 'Categorical (single)'}';
% $$$ u_names = {u_names{:}, '34-', '31-'};
% $$$ fprintf('OK!\n')


fprintf('Saving... ');

%path = cd('/vols/Data/HCP/BBUK/');

save('cleanedRawDataset.mat', ...
     'data', 'merged', 'raw', 'keep', 'names', 'u_names', 'meta', ...
     'no_desc','dirty');


%cd(path);

fprintf('All done! :D \n')

clear; % Remove all non-important data

load_raw_clean;