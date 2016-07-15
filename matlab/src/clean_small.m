%% CLEAN_SMALL
% Load and generate Gwen's small matrix of selected variables
% according to the Modifiable_risk_factors_NEW.doc file.
%
% Note that this needs to be done on workspace4 which has variables that were not present in workspace3b.
%
%
% DF = Modifiable risk factor
% IDP = IDP
%
% Variables included in this analysis (all INSTANCE 2)
% Variable    Description
% DF 1329    'Oily fish overall'
% DF 20003   'Medication/supplementation'
% DF 6155    'Vitamin Supplements'
% DF 1239    'Current tobacco smoking'
% DF 1249    'Past tobacco smoking' (nested with 1239, when it is not 1)
% DF 1558    'Alcohol intake frequency'
% DF 864     'Number of days/week walked for 10+ mins'
% DF 884     'Number of days/week had moderate exercise for 10+ min'
% DF 904     'Number of days/week had vigorous exercise for 10+ min'
% DF 1170    'Getting up in the morning'
% DF 1160    'Sleep duration'
%***DF 2080    'Frequency of tiredness in last 2 weeks'
%***DF 2050    'Frequency of depressed mood in the last 2 weeks'
% DF 21001   'BMI'
% DF 20002   'Self-reported hypertension'
% DF 4079    'Diastolic blood pressure'
% DF 4080    'Systolic blood pressure'
% DF 2443    'Diabetes dignosed by a doctor'
%***DF 1031    'Frequency of family visits'
%***DF 6160    'Leasure/social activities'
%***DF 4230    'Hearing on left ear'
%***DF 4241    'Hearing on right ear'
% DF 2247    'Hearing difficulty'
% DF 2257    'Hearing difficulty with background noise'
% DF 20016   'Fluid intelligence score'
% DF 20023   'Reaction time'
%***DF 400     'Pairs matching test'
% DF 20018   'Prospective memory result'
%
% Confounds
%
% DF 33      'Age'
% DF 6138    'Education'
% DF 738     'Social Economic Status'
% DF 31      'Gender'
% DF 6141    'Relationship status'
% DF 41202   'Diagnosis' (removed)
% IDP 12     'Head motion'
% IDP 13     'Head motion'
% IDP 18     'Head size'
%
% Additional
%
% DF 6152    'Inflammation/immuno-response'
% DF 6153    'Cholesterol or blood pressure medication'

clear; clc;
addpaths;   % Adds the relevant paths

%% Load variables
%----------------------------------------------------------
fprintf('--- Loading variables (unprocessed) --- \n');

workspace = matfile('/vols/Data/HCP/BBUK/workspace4.mat');
raw = workspace.vars;                     % Variables before cleaning
mods_names = get_id(workspace.varsVARS);  % Variable names
subs2keep = workspace.K;                  % Subjects to be kept
raw_idps = workspace.NETdraw;                 % IDPs
idps_names = workspace.IDPnames;           % IDP names

% Reinclude age variable.
raw = [raw, workspace.age];
mods_names = [mods_names, 33];
dirty = raw(subs2keep, :);

filtered_subs = (sum(isnan(raw_idps), 2) == 0);

dirty = dirty(filtered_subs,:);
data_vars_idps = raw_idps(filtered_subs, :);

n_subs = size(dirty, 1);

clearvars workspace
clearvars age

fprintf('--- Done! ---\n');

%% Load cleaning protocol
%----------------------------------------------------------
fprintf('--- Loading cleaning protocol (excel as csv) --- \n')

descr_var_mods = {'Oily fish overall',...
                  'Medication/supplementation',...
                  'Vitamin Supplements',...
                  'Current tobacco smoking',...
                  'Past tobacco smoking',...
                  'Alcohol intake frequency',...
                  'Number of days/week walked for 10+ mins',...
                  'Number of days/week had moderate exercise for 10+ min',...
                  'Number of days/week had vigorous exercise for 10+ min',...
                  'Getting up in the morning',...
                  'Sleep duration',...
                  'Frequency of tiredness in last 2 weeks',...
                  'Frequency of depressed mood in the last 2 weeks',...
                  'BMI',...
                  'Self-reported hypertension',...
                  'Diastolic blood pressure',...
                  'Systolic blood pressure',...
                  'Diabetes dignosed by a doctor',...
                  'Frequency of family visits',...
                  'Leasure/social activities',...
                  'Hearing on left ear',...
                  'Hearing on right ear',...
                  'Hearing difficulty',...
                  'Hearing difficulty with background noise',...
                  'Fluid intelligence score',...
                  'Reaction time',...
                  'Pairs matching test',...
                  'Prospective memory result'...
                  };

descr_conf_mods = {'Age',...
                   'Education',...
                   'Social Economic Status',...
                   'Gender',...
                   'Relationship status',...    %'Diagnosis'...
                   };

descr_conf_idps = {'Head motion',...
                   'Head motion',...
                   'Head size'...
                   };

descr_add_mods = {'Inflammation/immuno-response',...
                  'Cholesterol or blood pressure medication'...
                  };

names_vars_mods = [1329,...  %'Oily fish overall'
                  20003,... % 'Medication/supplementation'
                  6155,...  % 'Vitamin Supplements'
                  1239,...  % 'Current tobacco smoking'
                  1249,...  % 'Past tobacco smoking'
                  1558,...  % 'Alcohol intake frequency'
                  864,...   % 'Number of days/week walked for 10+ mins'
                  884,...   % 'Number of days/week had moderate exercise for 10+ min'
                  904,...   % 'Number of days/week had vigorous exercise for 10+ min'
                  1170,...  % 'Getting up in the morning'
                  1160,...  % 'Sleep duration'
                  2080,...  % 'Frequency of tiredness in last 2 weeks'
                  2050,...  % 'Frequency of depressed mood in the last 2 weeks'
                  21001,... % 'BMI'
                  20002,... % 'Self-reported hypertension'
                  4079,...  % 'Diastolic blood pressure'
                  4080,...  % 'Systolic blood pressure'
                  2443,...  % 'Diabetes dignosed by a doctor'
                  1031,...  % 'Frequency of family visits'
                  6160,...  % 'Leasure/social activities'
                  4230,...  % 'Hearing on left ear'
                  4241,...  % 'Hearing on right ear'
                  2247,...  % 'Hearing difficulty'
                  2257,...  % 'Hearing difficulty with background noise'
                  20016,... % 'Fluid intelligence score'
                  20023,... % 'Reaction time'
                  400,...   % 'Pairs matching test'
                  20018];   % 'Prospective memory result'

names_conf_mods = [33,...    %  'Age'
                   6138,...  %  'Education'
                   738,...   %  'Social Economic Status'
                   31,...    %  'Gender'
                   6141];% ,... %  'Relationship status'    41202];   %  'Diagnosis'

names_conf_idps = [12,... %   'Head motion'
                   13,... %   'Head motion'
                   18];   %   'Head size'

names_adds_mods = [6152,... % 'Inflammation/immuno-response'
                  6153];   % 'Cholesterol or blood pressure medication'

fprintf('--- Done! ---\n')

%% Extract all subjects and visits
%----------------------------------------------------------
fprintf('--- Extracting data --- \n');

fprintf('Extracting Modifiable Risk Factor Variables\n')

n_var_mods = length(names_vars_mods);
data_vars_mods = ones(n_subs, n_var_mods + 3);

% 1329  -  'Oily fish overall'
aux = dirty(:, mods_names == 1329);
data_vars_mods(:, 1) = aux(:, end); 

% 20003 -  'Medication/supplementation'
aux = dirty(:, mods_names == 20003);
cod = sum(aux == 1140909674, 2) > 0;
vitb = sum(aux == 1140871024, 2) > 0;
omega3 = sum(aux == 1193, 2) > 0;
b12 = (sum(aux == 1140858452, 2) + ... % hepacon B12 injection
       sum(aux == 1140870570, 2) + ... % vitamin B12 preparation
       sum(aux == 1140876608, 2) + ... % Feroglobin B12 syrup
       sum(aux == 1140910494, 2) + ... % B12 Hydroxocobalamin prep
       sum(aux == 1140912228, 2)) > 0; % B12 Cyanocobalamin prep

data_vars_mods(:, 2:5) = [cod, vitb, omega3, b12];
names_vars_mods = [names_vars_mods(1), ...
                  names_vars_mods(2) + 0.1, ... % Cod
                  names_vars_mods(2) + 0.2, ... % VitB
                  names_vars_mods(2) + 0.3, ... % Omega3
                  names_vars_mods(2) + 0.4, ... % B12
                  names_vars_mods(3:end) ];

% 6155  -  'Vitamin Supplements'
aux = dirty(:, mods_names == 6155);
vitb_and_b9 = (sum(aux == 2, 2) > 0 + ... % Vitamin b
               sum(aux == 6, 2) > 0) > 0; % Folic acid (B9)

data_vars_mods(:, 6) = vitb_and_b9;

% 1239  -  'Current tobacco smoking'
aux = dirty(:, mods_names == 1239);
data_vars_mods(:, 7) = change_encoding(aux(:, end), [0,2,1], [0,1,2]);

% 1249  -  'Past tobacco smoking'
aux = dirty(:, mods_names == 1249);
data_vars_mods(:, 8) = change_encoding(aux(:, end), [2,1,3,4], [1,2,0,0]);

% 1558  -  'Alcohol intake frequency'
aux = dirty(:, mods_names == 1558);
data_vars_mods(:, 9) = change_encoding(aux(:, end), [6,5,4,3,2,1], [0,1,2,3,4,5]);

% 864   -  'Number of days/week walked for 10+ mins'
aux = dirty(:, mods_names == 864);
data_vars_mods(:,10) = aux(:, end);

% 884   -  'Number of days/week had moderate exercise for 10+ min'
aux = dirty(:, mods_names == 884);
data_vars_mods(:,11) = aux(:, end);

% 904   -  'Number of days/week had vigorous exercise for 10+ min'
aux = dirty(:, mods_names == 904);
data_vars_mods(:,12) = aux(:, end);

% 1170  -  'Getting up in the morning'
aux = dirty(:, mods_names == 1170);
data_vars_mods(:,13) = aux(:, end);

% 1160  -  'Sleep duration'
aux = dirty(:, mods_names == 1160);
data_vars_mods(:,14) = aux(:, end);   

% 2080  -  'Frequency of tiredness in last 2 weeks'
aux = dirty(:, mods_names == 2080);
data_vars_mods(:,15) = aux(:, end);

% 2050  -  'Frequency of depressed mood in the last 2 weeks'
aux = dirty(:, mods_names == 2050);
data_vars_mods(:,16) = aux(:, end);

% 21001 -  'BMI'
aux = dirty(:, mods_names == 21001);
data_vars_mods(:,17) = aux(:, end);

% 20002 -  'Self-reported hypertension'
aux = dirty(:, mods_names == 20002);
hypten = sum(aux == 1065, 2) > 0;
data_vars_mods(:,18) = hypten;

% 4079  -  'Diastolic blood pressure'
aux = dirty(:, mods_names == 4079);
data_vars_mods(:,19) = aux(:, end);

% 4080  -  'Systolic blood pressure'
aux = dirty(:, mods_names == 4080);
data_vars_mods(:,20) = aux(:, end);

% 2443  -  'Diabetes dignosed by a doctor'
aux = dirty(:, mods_names == 2443);
diabetes = sum(aux, 2) > 0;
data_vars_mods(:,21) = diabetes;

% 1031  -  'Frequency of family visits'
aux = dirty(:, mods_names == 1031);
data_vars_mods(:,22) = change_encoding(aux(:, end), [1,2,3,4,5,6,7], [5,4,3,2,1,0,0]);

% 6160  -  'Leasure/social activities'
aux = dirty(:, mods_names == 6160);
data_vars_mods(:,23) = sum(aux > 0, 2) > 0;

% 4230  -  'Hearing on left ear'
aux = dirty(:, mods_names == 4230);
lo = aux(:, end) < -5.5;
mi = and(aux(:, end) >= -5.5, aux(:, end) < -3.5);
hi = aux(:, end) >= -3.5;
data_vars_mods(:,24) = 0 * lo + 1 * mi + 2 * hi; 

% 4241  -  'Hearing on right ear'
aux = dirty(:, mods_names == 4241);
lo = aux(:, end) < -5.5;
mi = and(aux(:, end) >= -5.5, aux(:, end) < -3.5);
hi = aux(:, end) >= -3.5;
data_vars_mods(:,25) = 0 * lo + 1 * mi + 2 * hi;   

% 2247  -  'Hearing difficulty'
aux = dirty(:, mods_names == 2247);
aux = aux(:, end);
aux(find(aux == 99)) = 1;
data_vars_mods(:,26) = aux;

% 2257  -  'Hearing difficulty with background noise'
aux = dirty(:, mods_names == 2257);
aux = aux(:, end);
aux(find(aux == 99)) = 1;
data_vars_mods(:,27) =  aux;

% 20016 -  'Fluid intelligence score'
aux = dirty(:, mods_names == 20016);
data_vars_mods(:,28) =  aux(:, end);

% 20023 -  'Reaction time'
aux = dirty(:, mods_names == 20023);
data_vars_mods(:,29) = aux(:, end);

% 400   -  'Pairs matching test' ****
aux = dirty(:, mods_names == 400);
data_vars_mods(:,30) = aux(:, end - 1);

% 20018 -  'Prospective memory result'
aux = dirty(:, mods_names == 20018);
data_vars_mods(:,31) = aux(:, end);


fprintf('Extracting Modifiable Risk Factor Confounds\n')

n_conf_mods = length(names_conf_mods);
data_conf_mods = zeros(n_subs, n_conf_mods);

% 33      'Age'
aux = dirty(:, mods_names == 33);
data_conf_mods(:, 1) = aux;

% 6138    'Education'
aux = dirty(:, mods_names == 6138);
data_conf_mods(:, 2) = aux(:, 1);

% 738     'Social Economic Status'
aux = dirty(:, mods_names == 738);
data_conf_mods(:, 3) = aux(:, end);

% 31      'Gender'
aux = dirty(:, mods_names == 31);
data_conf_mods(:, 4) = aux;

% 6141    'Marital status'
aux = dirty(:, mods_names == 6141);
data_conf_mods(:, 5) = sum(aux == 1, 2) > 0;

% 41202   'Diagnosis'
% data_conf_mods(:, 6) = dirty(:, mods_names == 41202);


fprintf('Extracting IDP Confounds\n')

n_conf_idps = length(names_conf_idps);
data_conf_idps = zeros(n_subs, n_conf_idps);

% 12    'Head motion'
data_conf_idps(:, 1) = data_vars_idps(:, 12);
% 13    'Head motion'
data_conf_idps(:, 2) = data_vars_idps(:, 13);
% 18    'Head size'
data_conf_idps(:, 3) = data_vars_idps(:, 18);

fprintf('Extracting Additional Modifiable Risk Factors\n')

n_add_mods = length(names_adds_mods);
data_adds_mods = zeros(n_subs, n_add_mods);

% 6152  'Inflammation/immuno-response'
aux = dirty(:, mods_names == 6152);

% Dummies
% 5 Blood clot in the leg (DVT)
clot_leg = sum(aux == 5, 2) > 0;
% 7 Blood clot in the lung
clot_lung = sum(aux == 7, 2) > 0;
% 6 Emphysema/chronic bronchitis
ephysema = sum(aux == 6, 2) > 0;
% 8 Asthma
asthma = sum(aux == 8, 2) > 0;
% 9 Hayfever, allergic rhinitis or eczema
hayfever = sum(aux == 9, 2) > 0;

data_adds_mods(:, 1:5) = [clot_leg, clot_lung, ephysema, asthma, hayfever];

names_adds_mods = [names_adds_mods(1) + 0.1, ...
                  names_adds_mods(1) + 0.2, ...
                  names_adds_mods(1) + 0.3, ...
                  names_adds_mods(1) + 0.4, ...
                  names_adds_mods(1) + 0.5, ...
                  names_adds_mods(2)];

% 6153  'Cholesterol or blood pressure medication'
aux = dirty(:, mods_names == 6153);

% Dummies
% 1 Cholesterol lowering medication
cholesterol = sum(aux == 1, 2) > 0;
% 2 Blood pressure medication
blood = sum(aux == 2, 2) > 0;
% 3 Insulin
insulin = sum(aux == 3, 2) > 0;
% 4 Hormone replacement therapy
hormone = sum(aux == 4, 2) > 0;
% 5 Oral contraceptive pill or minipill
pill = sum(aux == 5, 2) > 0;

data_adds_mods(:, 6:10) = [cholesterol, blood, insulin, hormone, pill];

names_adds_mods = [names_adds_mods(1:5), ...
                  names_adds_mods(6) + 0.1, ...
                  names_adds_mods(6) + 0.2, ...
                  names_adds_mods(6) + 0.3, ...
                  names_adds_mods(6) + 0.4, ...
                  names_adds_mods(6) + 0.5];

fprintf('--- Done! ---\n');

%% Saving
%----------------------------------------------------------
fprintf('--- Saving as Matlab file --- \n');

save('../small-matrix/small_cleaned.mat', ...
     'data_vars_mods',...
     'data_vars_idps',...
     'data_conf_mods',...
     'data_conf_idps',...
     'data_adds_mods',...
     'names_vars_mods',...
     'names_conf_mods',...
     'names_conf_idps',...
     'names_adds_mods');

fprintf('--- Done! ---\n');

%% Writing to CSV
%----------------------------------------------------------
fprintf('--- Saving as csv files --- \n');

csvwrite('../small-matrix/small_vars_mods.csv', data_vars_mods);
csvwrite('../small-matrix/small_vars_idps.csv', data_vars_idps);
csvwrite('../small-matrix/small_conf_mods.csv', data_conf_mods);
csvwrite('../small-matrix/small_conf_idps.csv', data_conf_idps);
csvwrite('../small-matrix/small_adds_mods.csv', data_adds_mods);
csvwrite('../small-matrix/small_names_vars_mods.csv', names_vars_mods);
csvwrite('../small-matrix/small_names_conf_mods.csv', names_conf_mods);
csvwrite('../small-matrix/small_names_conf_idps.csv', names_conf_idps);
csvwrite('../small-matrix/small_names_adds_mods.csv', names_adds_mods);

fprintf('--- All done! :D ---\n')