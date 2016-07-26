%% CLEAN_BIG.M
% Load and clean up the raw data from workspace4.mat into a big matrix

clear; clc;
addpaths;   % Adds the relevant paths

%% Load variables
%----------------------------------------------------------
fprintf('--- Loading variables (unprocessed) --- \n');

workspace = matfile('/vols/Data/HCP/BBUK/workspace4.mat');
all_idps = load('/vols/Data/HCP/BBUK/workspace4.mat', 'ALL_IDPs');

all_idps = all_idps.ALL_IDPs;
raw_idps = [all_idps(:, 18:end),...
            workspace.NODEamps25,...
            workspace.NODEamps100,...
            workspace.NET25,...
            workspace.NET100];            % IDPs
clear all_idps;

raw = workspace.vars;                     % Variables before cleaning
all_codes = get_id(workspace.varsVARS);   % Variable names
subs2keep = workspace.K;                  % Subjects to be kept
idp_names = workspace.IDPnames;           % IDP names

filtered_subs = (sum(isnan(raw_idps), 2) == 0);

dirty = raw(filtered_subs,:);
age = workspace.age;  % Reinclude age variable.

idps = raw_idps(filtered_subs, :);
idp_names = idp_names(18:end);

clearvars workspace

fprintf('--- Done! ---\n');

%% Load cleaning protocol
%----------------------------------------------------------
fprintf('--- Loading cleaning protocol (excel as csv) --- \n')
filename = '../big-matrix/list-big-matrix.csv';
file = fopen(filename);

% Read file
headers = textscan(file, '%s', 16, 'Delimiter', ','); % Remove headers
protocol = textscan(file, ...
                    '%d %s %d %s %d %d %s %s %s %s %d %s %s %s %s %d',...
                    'Delimiter', ',');% Get data
fclose(file);

% Separate protocol into intelligible variables
codes = protocol{1};         % Integer
names = protocol{2};         % String
vartype = protocol{4};       % String
parent1 = protocol{5};       % Integer
parent2 = protocol{6};       % Integer
parval1 = protocol{7};       % String with hash-separated values
parval2 = protocol{8};       % String with hash-separated values
missing_fix = protocol{10};  % String
bbuk_levels = protocol{12};  % String with hash-separated values
new_levels = protocol{13};   % String with hash-separated values
processing = protocol{14};   % String
remove = protocol{16};       % Integer

% Pre-process hash-separated strings
parval1 = hsv2cell(parval1);
parval2 = hsv2cell(parval2);
bbuk_levels = hsv2cell(bbuk_levels);
new_levels = hsv2cell(new_levels);

% Convert string into integers codes
vartype = prep_vartype(vartype);
missing_fix = prep_missing(missing_fix);
processing = prep_processing(processing);

% Keep only variables we don't want to remove
keep = find(~remove);

codes = codes(keep);
names = names(keep);
vartype = vartype(keep);
parent1 = parent1(keep);
parent2 = parent2(keep);
parval1 = parval1(keep);
parval2 = parval2(keep);
missing_fix = missing_fix(keep);
bbuk_levels = bbuk_levels(keep); 
new_levels = new_levels(keep);
processing = processing(keep);

fprintf('--- Done! ---\n')

%% Extract all subjects and visits
%----------------------------------------------------------
fprintf('--- Creating data segreated by visits --- \n');
n_vars = length(codes);  % names contains only unique entries
n_subs = size(dirty, 1);

data = ones(n_subs, n_vars, 5); % max number of visits = 5.
data = data .* NaN;

% Find all variables and their visits
last_visit = zeros(n_vars, 1);
for var = 1:n_vars
    loc = find(all_codes == codes(var));
    n_visits = length(loc);
    last_visit(var) = n_visits;
    for visit = 1:n_visits
        data(:, var, visit) = dirty(:, loc(visit));
    end
end
fprintf('--- Done! ---\n')


%% Special missing values encoding
fprintf('--- Accounting for different ways to encode missing data ---\n')
for var = 1:n_vars
    for vis = 1:last_visit(var)            
        aux = data(:, var, vis);
        if processing(var) == 1     
            aux(aux == -1) = NaN;
            aux(aux == -3) = NaN;
        elseif processing(var) == 2
            aux(aux == -1) = NaN;
            aux(aux == -3) = NaN;
            aux(aux == -10) = NaN;
        elseif processing(var) == 3
            aux(aux == -1) = NaN;
            aux(aux == -2) = NaN;
            aux(aux == -3) = NaN;
        elseif processing(var) == 4
            aux(aux == -1) = NaN;
            aux(aux == -3) = NaN;
            aux(aux == 99) = NaN;
        elseif processing(var) == 5
            aux(aux == 222) = NaN;
            aux(aux == 313) = NaN;
        elseif processing(var) == 6
            aux(aux == 352) = NaN;
        elseif processing(var) == 7
            aux(aux == 5) = NaN;
            aux(aux < 0) = NaN;
        elseif processing(var) == 8
            aux(aux == 6) = NaN;
            aux(aux < 0) = NaN;
        elseif processing(var) == 9
            aux(aux == 9) = NaN;
        elseif processing(var) == 10
            aux(aux < 0) = NaN;
        elseif processing(var) == 11
            continue
        end
        data(:, var, vis) = aux;
    end
end

fprintf('--- Done! ---\n');

%% De-nest and to remove missing data not missing
%----------------------------------------------------------
fprintf('--- Imputation step by de-nesting variables  ---\n');

fprintf(['Total number of NaNs *before* de-nesting: ', ...
         num2str(sum(isnan(data(:)))), '.\n']);

for var = 1:n_vars
    loc = find(all_codes == codes(var));
    n_visits = length(loc);

    if parent1(var) ~= 0 && parent2(var) ~= 0  && ... % has 2 parents
       sum(parent1(var) == codes) ~=0 && sum(parent2(var) == codes) ~= 0% parents weren't removed

        % get parent locations
        loc_par1 = find(codes == parent1(var));
        loc_par2 = find(codes == parent2(var));

        % check all entries that are nan in the current variable
        for visit = 1:n_visits

            % get parent values that make the entry not NaN
            vals1 = parval1{loc_par1};
            vals2 = parval2{loc_par2};

            nan_vals = find(isnan(data(:, var, visit)));

            % check for all entries that are nan in the nested variable if 
            % the 1st parent variable meets the criteria that prompts the nested
            % question.
            par1_sub = zeros(length(nan_vals), 1);
            for ii = 1:length(vals1)
                 par1_sub = or(par1_sub, ...
                               data(nan_vals, loc_par1, visit) == vals1(ii));
            end

            % check for all entries that are nan in the nested variable if 
            % the 2nd parent variable meets the criteria that prompts the nested
            % question.
            par2_sub = zeros(length(nan_vals), 1);
            for ii = 1:length(vals2)
                 par2_sub = or(par2_sub, ...
                               data(nan_vals, loc_par1, visit) == vals2(ii));
            end

            % Now filter the indexes of the subjects that met the critia for the
            % first question with the second question (and keep only the ones
            % that satisfy both 1st and 2nd criteria.
            sub_idx = and(par1_sub, par2_sub);

            % Now set the value of these variables to zero.
            data(nan_vals(sub_idx == 1), var, visit) = 0;
        end
    elseif parent1(var) ~= 0 && sum(codes == parent1(var)) ~= 0 % only one parent, not removed       

        % get parent locations
        loc_par1 = find(codes == parent1(var));

        % check all entries that are nan in the current variable
        for visit = 1:n_visits

            % get parent values that make the entry not NaN
            vals1 = parval1{loc_par1};

            nan_vals = find(isnan(data(:, var, visit)));

            % check for all entries that are nan in the nested variable if 
            % the 1st parent variable meets the criteria that prompts the nested
            % question.
            par1_sub = zeros(length(nan_vals), 1);
            for ii = 1:length(vals1)
                 par1_sub = or(par1_sub, ...
                               data(nan_vals, loc_par1, visit) == vals1(ii));
            end

            % Now set the value of these variables to zero.
            data(nan_vals(par1_sub == 1), var, visit) = 0;
        end
    end
end

fprintf(['Total number of NaNs *after* de-nesting: ', ...
         num2str(sum(isnan(data(:)))), '.\n']);

fprintf('--- Done! ---\n');

%% Change the variable encodings
%----------------------------------------------------------
fprintf('--- Changing the variable encodings to the ones in the csv  ---\n');

for var = 1:n_vars
    loc = find(all_codes == codes(var));
    n_visits = length(loc);
    
    if processing(var) == 3 % code for change values

        % get new_levels
        new_encodings = new_levels{var};
        old_encodings = bbuk_levels{var};

        % check all entries that are nan in the current variable
        for visit = 1:n_visits
            % Now set the value of these variables to zero.
            data(:, var, visit) = change_encoding(data(:, var, visit), ...
                                                  old_encodings, ...
                                                  new_encodings);
        end
    end
end

fprintf('--- Done! ---\n');

% Merging
%fprintf('--- Merging ---\n');
%
%merged_last = zeros(size(data, 1), size(data,2));
%
%for var = 1:n_vars
%    merged_last(:, var) = data(:, var, last_visit(var));
%end
%
%merged_mean = nanmean(data,3);
%
%fprintf('--- Done! ---\n');

%% Imputting
%----------------------------------------------------------
fprintf('--- Imputting "confounds" and missing entries --- \n');

big_vars_mods = data(:, :, 1);
big_names_vars_mods = names;
big_codes_vars_mods = codes;
big_names_vars_idps = idp_names;
big_vars_idps = idps;

% 33      'Age'
big_names_vars_mods = {big_names_vars_mods{:}, 'Age'};
big_codes_vars_mods = [big_codes_vars_mods; 33];
big_vars_mods = [big_vars_mods, age(filtered_subs)];

% 6138    'Education'
big_names_vars_mods = {big_names_vars_mods{:}, 'Education'};
big_codes_vars_mods = [big_codes_vars_mods; 6138];
aux = dirty(:, all_codes == 6138);
big_vars_mods = [big_vars_mods, aux(:, 1)];

% 738     'Social Economic Status'
big_names_vars_mods = {big_names_vars_mods{:}, 'Social Economic Status'};
big_codes_vars_mods = [big_codes_vars_mods; 738];
aux = dirty(:, all_codes == 738);
big_vars_mods = [big_vars_mods, aux(:, end)];

% 31      'Gender'
big_names_vars_mods = {big_names_vars_mods{:}, 'Gender'};
big_codes_vars_mods = [big_codes_vars_mods; 31];
aux = dirty(:, all_codes == 31);
big_vars_mods = [big_vars_mods, aux];

% 6141    'Marital status'
big_names_vars_mods = {big_names_vars_mods{:}, 'Married'};
big_codes_vars_mods = [big_codes_vars_mods; 6141];
aux = dirty(:, all_codes == 6141);
big_vars_mods = [big_vars_mods,  sum(aux == 1, 2) > 0;];

% 6152.1  'Inflammation/immuno-response - Asthma'
big_names_vars_mods = {big_names_vars_mods{:}, ...
                       'Inflammation/immuno-response - Asthma'};
big_codes_vars_mods = [big_codes_vars_mods; 6152.1];
aux = dirty(:, all_codes == 6152);
asthma = sum(aux == 8, 2) > 0;
big_vars_mods = [big_vars_mods, asthma];

% 6152.1  'Inflammation/immuno-response - Hayfever'
big_names_vars_mods = {big_names_vars_mods{:}, ...
                       'Inflammation/immuno-response - Hayfever'};
big_codes_vars_mods = [big_codes_vars_mods; 6152.2];
aux = dirty(:, all_codes == 6152);
hayfever = sum(aux == 9, 2) > 0;
big_vars_mods = [big_vars_mods, hayfever];

% 6153.1  'Cholesterol or blood pressure medication'
big_names_vars_mods = {big_names_vars_mods{:}, ...
                 'Cholesterol or blood pressure medication - Cholesterol'};
big_codes_vars_mods = [big_codes_vars_mods; 6153.1];
aux = dirty(:, all_codes == 6153);
cholesterol = sum(aux == 1, 2) > 0;
big_vars_mods = [big_vars_mods, cholesterol];

% 6153.2  'Cholesterol or blood pressure medication'
big_names_vars_mods = {big_names_vars_mods{:}, ...
                       'Cholesterol or blood pressure medication - Blood'};
big_codes_vars_mods = [big_codes_vars_mods; 6153.2];
aux = dirty(:, all_codes == 6153);
blood = sum(aux == 2, 2) > 0;
big_vars_mods = [big_vars_mods, blood];

% Missing data
big_vars_mods_filled = big_vars_mods;
for var = 1:size(big_vars_mods, 2)
  aux = big_vars_mods_filled(:, var);
  big_vars_mods_filled(find(isnan(aux)), var) = nanmedian(aux);
end

%% Saving
%----------------------------------------------------------
fprintf('--- Saving as Matlab file --- \n');
big_vars_all = [big_vars_mods, big_vars_idps]; 
big_filled_all = [big_vars_mods_filled, big_vars_idps];

save('../big-matrix/big_filled.mat', ...
     'big_vars_mods',...
     'big_vars_mods_filled',...
     'big_vars_idps',...
     'big_names_vars_mods', ...
     'big_names_vars_idps', ...
     'big_filled_all', ...
     'big_codes_vars_mods');

fprintf('--- Done! ---\n');

%% Writing to CSV
%----------------------------------------------------------
fprintf('--- Saving as csv files --- \n');

csvwrite('../big-matrix/big_vars_mods.csv', big_vars_mods);
csvwrite('../big-matrix/big_filled_vars_mods.csv', big_vars_mods_filled);
csvwrite('../big-matrix/big_vars_idps.csv', big_vars_idps);

fid  = fopen('../big-matrix/big_clean_all.csv', 'w');
for ii = 1:length(big_names_vars_mods)
    fprintf(fid, '%s, ', big_names_vars_mods{ii});
end
for ii = 1:length(big_names_vars_idps)
    fprintf(fid, '%s, ', big_names_vars_idps{ii});
end
fprintf(fid, '\n');
fclose(fid);

dlmwrite('../big-matrix/big_clean_all.csv', big_vars_all, '-append');
    


fid  = fopen('../big-matrix/big_filled_all.csv', 'w');
for ii = 1:length(big_names_vars_mods)
    fprintf(fid, '%s, ', big_names_vars_mods{ii});
end
for ii = 1:length(big_names_vars_idps) - 1
    fprintf(fid, '%s, ', big_names_vars_idps{ii});
end
fprintf(fid, '%s\n', big_names_vars_idps{ii + 1});
fclose(fid);
dlmwrite('../big-matrix/big_filled_all.csv', big_filled_all, '-append');

 
% fprintf('Metrics:\n');
% 
% fprintf(['Most entries (middle ground): ', ...
%          num2str(sum(sum(isnan(data(:,:,1)))) / numel( data(:,:,1))), '\n']);
% fprintf(['Collapsed (dirtiest): ', ...
%          num2str(sum(isnan(merged_mean(:))) / numel(merged_mean) ), '\n']);
% fprintf(['Last entry (cleanest): ',...
%          num2str(sum(isnan(merged_last(:))) / numel(merged_last) ), '\n']);


fprintf('--- All done! :D ---\n')
