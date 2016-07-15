%% CLEAN_BIG.M
% Load and clean up the raw data from workspace4.mat into a big matrix

clear; clc;
addpaths;   % Adds the relevant paths

%% Load variables
%----------------------------------------------------------
fprintf('--- Loading variables (unprocessed) --- \n');

workspace = matfile('/vols/Data/HCP/BBUK/workspace4.mat');
raw = workspace.vars;                     % Variables before cleaning
all_names = get_id(workspace.varsVARS);   % Variable names
subs2keep = workspace.K;                  % Subjects to be kept
raw_idps = workspace.NETdraw;             % IDPs
idp_names = workspace.IDPnames;           % IDP names
clearvars workspace

dirty = raw(subs2keep, :);
filtered_subs = (sum(isnan(raw_idps), 2) == 0);

idps = raw_idps(filtered_subs, :);
dirty = dirty(filtered_subs, :);

fprintf('--- Done! ---\n');

%% Load cleaning protocol
%----------------------------------------------------------
fprintf('--- Loading cleaning protocol (excel as csv) --- \n')
filename = 'bbuk-variables.csv';
file = fopen(filename);

% Read file
headers = textscan(file, '%s', 16, 'Delimiter', ','); % Remove headers
protocol = textscan(file, ...
                    '%d %s %d %s %d %d %s %s %s %s %d %s %s %s %s %d',...
                    'Delimiter', ',');% Get data
fclose(file);

% Separate protocol into intelligible variables
names = protocol{1};         % Integer
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
n_vars = length(names);  % names contains only unique entries
n_subs = size(dirty, 1);

data = ones(n_subs, n_vars, 5); % max number of visits = 5.
data = data .* NaN;

% Find all variables and their visits
last_visit = zeros(n_vars, 1);
for var = 1:n_vars
    loc = find(all_names == names(var));
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
    loc = find(all_names == names(var));
    n_visits = length(loc);

    if parent1(var) ~= 0 && parent2(var) ~= 0  && ... % has 2 parents
       sum(parent1(var) == names) ~=0 && sum(parent2(var) == names) ~= 0% parents weren't removed

        % get parent locations
        loc_par1 = find(names == parent1(var));
        loc_par2 = find(names == parent2(var));

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
    elseif parent1(var) ~= 0 && sum(names == parent1(var)) ~= 0 % only one parent, not removed       

        % get parent locations
        loc_par1 = find(names == parent1(var));

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
    loc = find(all_names == names(var));
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
fprintf('--- Merging ---\n');

merged_last = zeros(size(data, 1), size(data,2));

for var = 1:n_vars
    merged_last(:, var) = data(:, var, last_visit(var));
end

merged_mean = nanmean(data,3);

fprintf('--- Done! ---\n');

%% Saving
%----------------------------------------------------------
fprintf('--- Saving as Matlab file --- \n');

big_vars_mods = data(:, :, 1);
big_names_vars_mods = names;
big_vars_idps = idps;

save('../big-matrix/big_cleaned.mat', ...
     'big_vars_mods', 'big_names_vars_mods', 'big_vars_idps');

fprintf('--- Done! ---\n');

%% Writing to CSV
%----------------------------------------------------------
fprintf('--- Saving as csv files --- \n');

csvwrite('../big-matrix/big_visit1.csv', data(:,:,1));
csvwrite('../big-matrix/big_visit2.csv', data(:,:,2));
csvwrite('../big-matrix/big_visit3.csv', data(:,:,3));
csvwrite('../big-matrix/big_visit4.csv', data(:,:,4));
csvwrite('../big-matrix/big_visit5.csv', data(:,:,5));
csvwrite('../big-matrix/big_merged_last.csv', merged_last);
csvwrite('../big-matrix/big_merged_mean.csv', merged_mean);
csvwrite('../big-matrix/big_names.csv', names);
csvwrite('../big-matrix/big_idps.csv', idps);

fprintf('--- All done! :D ---\n')


fprintf('Metrics:\n');

fprintf(['Most entries (middle ground): ', ...
         num2str(sum(sum(isnan(data(:,:,1)))) / numel( data(:,:,1))), '\n']);
fprintf(['Collapsed (dirtiest): ', ...
         num2str(sum(isnan(merged_mean(:))) / numel(merged_mean) ), '\n']);
fprintf(['Last entry (cleanest): ',...
         num2str(sum(isnan(merged_last(:))) / numel(merged_last) ), '\n']);
