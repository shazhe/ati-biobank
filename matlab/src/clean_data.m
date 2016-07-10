%% CLEAN_WORKSPACE3B.m
% Load and clean up the raw data from workspace3b.mat

clear; clc;
addpaths;   % Adds the relevant paths

%% Load variables
%----------------------------------------------------------
fprintf('--- Loading variables (unprocessed) --- \n');

work3b = matfile('/vols/Data/HCP/BBUK/workspace3b.mat');
raw = work3b.vars;                   % Variables before cleaning
all_names = get_id(work3b.varsVARS);   % Variable names
subs2keep = work3b.K;                  % Subjects to be kept
clearvars work3b

dirty = raw(subs2keep, :);

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

%% Analyse all subjects and visits
%----------------------------------------------------------
fprintf('--- Creating data segreated by visits --- \n');
n_vars = length(names);  % names contains only unique entries
n_subs = size(dirty, 1);

data = ones(n_subs, n_vars, 5); % max number of visits = 5.
data = data .* NaN;

% Find all variables and their visits
for var = 1:n_vars
    loc = find(all_names == names(var));
    n_visits = length(loc);
    for visit = 1:n_visits
        data(:, var, visit) = dirty(:, loc(visit));
    end
end
fprintf('--- Done! ---\n')

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

%% Saving
%----------------------------------------------------------
fprintf('Saving... ');

save('cleaned3b.mat', ...
     'data', 'dirty', 'raw', 'all_names', 'names', 'vartype', 'subs2keep');
 
fprintf('Saving OK!\n')

fprintf('All done! :D \n')
