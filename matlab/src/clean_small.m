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
% DF 2080    'Frequency of tiredness in last 2 weeks'
% DF 2050    'Frequency of depressed mood in the last 2 weeks'
% DF 21001   'BMI'
% DF 20002   'Self-reported hypertension'
% DF 4079    'Diastolic blood pressure'
% DF 4080    'Systolic blood pressure'
% DF 2443    'Diabetes dignosed by a doctor'
% DF 1031    'Frequency of family visits'
% DF 6160    'Leasure/social activities'
% DF 4230    'Hearing on left ear'
% DF 4241    'Hearing on right ear'
% DF 2247    'Hearing difficulty'
% DF 2257    'Hearing difficulty with background noise'
% DF 20016   'Fluid intelligence score'
% DF 20023   'Reaction time'
% DF 400     'Pairs matching test'
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
small_vars_idps = raw_idps(filtered_subs, :);

n_subs = size(dirty, 1);

clearvars workspace
clearvars age

fprintf('--- Done! ---\n');

%% Load cleaning protocol
%----------------------------------------------------------
fprintf('--- Loading cleaning protocol (excel as csv) --- \n')

descr_var_mods = {'Oily fish intake',...
                  'Medication/supplementation - Cod',...
                  'Medication/supplementation - Vitamin B',...
                  'Medication/supplementation - Omega 3',...
                  'Medication/supplementation - B12',...
                  'Vitamin Supplements - Vitamin B',...
                  'Vitamin Supplements - Folic Acid',...
                  'Current tobacco smoking',...
                  'Past tobacco smoking',...
                  'Alcohol intake frequency',..
                  'Number of days/week walked 10+ minutes',...
                  'Number of days/week of moderate physical activity 10+ minutes',...
                  'Number of days/week of vigorous physical activity 10+ minutes',...
                  'Getting up in the morning',...
                  'Sleep Duration',...
                  'Frequency of tiredness in last 2 weeks',...
                  'Frequency of depressed mood in the last 2 weeks',...
                  'Body mass index (BMI)',...
                  'Self-reported hypertension',...
                  'Diastolic blood pressure',...
                  'Systolic blood pressure',...
                  'Diabetes dignosed by a doctor',...
                  'Frequency of family visits',...
                  'Leisure/social activities',...
                  'Hearing on left ear',...
                  'Hearing on right ear',...
                  'Hearing difficulty',...
                  'Hearing difficulty with background noise',...
                  'Fluid intelligence score',...
                  'Mean time to correctly identify matches',...
                  'Pairs matching test',...
                  'Prospective memory result',...
                  'Inflammation/immuno-response - Asthma',...
                  'Inflammation/immuno-response - Hayfever',...
                  'Cholesterol or blood pressure medication - Cholesterol',...
                  'Cholesterol or blood pressure medication - Blood', ....
                  'Age',...
                  'Education',...
                  'Social Economic Status',...
                  'Gender',...
                  'Married',...
                  'Inflammation/immuno-response - Asthma',...
                  'Inflammation/immuno-response - Hayfever',...
                  'Cholesterol or blood pressure medication - Cholesterol'...
                  'Cholesterol or blood pressure medication - Blood Pressure'...
                 };

names_vars_mods = [1329,...  %'Oily fish overall'
                   20003.1,... % 'Medication/supplementation - Cod'
                   20003.2,... % 'Medication/supplementation - Vit. B'
                   20003.3,... % 'Medication/supplementation - Omega3'
                   20003.4,... % 'Medication/supplementation - B12'
                   6155,...  % 'Vitamin Supplements - Vit. B'
                   6155,...  % 'Vitamin Supplements - Folic Acid'
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
                   20018,... % 'Prospective memory result'
                   33,...    %  'Age'
                   6138,...  %  'Education'
                   738,...   %  'Social Economic Status'
                   31,...    %  'Gender'
                   6141,...  %  'Relationship status'
                   6152.1,... % 'Inflammation/immuno-response - Asthma'
                   6152.2,... % 'Inflammation/immuno-response-Hayfever'
                   6153.1,... % 'Cholesterol or blood pressure medication'
                   6153.2];   % 'Cholesterol or blood pressure medication'

fprintf('--- Done! ---\n')

%% Extract all subjects and visits
%----------------------------------------------------------
fprintf('--- Extracting data --- \n');

fprintf('Extracting Modifiable Risk Factor Variables\n')

n_var_mods = length(names_vars_mods);
small_vars_mods = ones(n_subs, n_var_mods + 4);

% 1329  -  'Oily fish overall'
aux = dirty(:, mods_names == 1329);
small_vars_mods(:, 1) = aux(:, end); 

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

small_vars_mods(:, 2) = cod;
small_vars_mods(:, 3) = vitb;
small_vars_mods(:, 4) = omega3
small_vars_mods(:, 5) = b12;

% 6155  -  'Vitamin Supplements'
aux = dirty(:, mods_names == 6155);
vitb = sum(aux == 2, 2) > 0; % Vitamin B
folic = sum(aux == 6, 2) > 0; % Folic acid (B9)

small_vars_mods(:, 6) = vitb;
small_vars_mods(:, 7) = folic;

% 1239  -  'Current tobacco smoking'
aux = dirty(:, mods_names == 1239);
small_vars_mods(:, 8) = change_encoding(aux(:, end), [0,2,1], [0,1,2]);

% 1249  -  'Past tobacco smoking'
aux = dirty(:, mods_names == 1249);
small_vars_mods(:, 9) = change_encoding(aux(:, end), [2,1,3,4], [1,2,0,0]);

% 1558  -  'Alcohol intake frequency'
aux = dirty(:, mods_names == 1558);
small_vars_mods(:,10) = change_encoding(aux(:, end), [6,5,4,3,2,1], [0,1,2,3,4,5]);

% 864   -  'Number of days/week walked for 10+ mins'
aux = dirty(:, mods_names == 864);
small_vars_mods(:,11) = aux(:, end);

% 884   -  'Number of days/week had moderate exercise for 10+ min'
aux = dirty(:, mods_names == 884);
small_vars_mods(:,12) = aux(:, end);

% 904   -  'Number of days/week had vigorous exercise for 10+ min'
aux = dirty(:, mods_names == 904);
small_vars_mods(:,13) = aux(:, end);

% 1170  -  'Getting up in the morning'
aux = dirty(:, mods_names == 1170);
small_vars_mods(:,14) = aux(:, end);

% 1160  -  'Sleep duration'
aux = dirty(:, mods_names == 1160);
small_vars_mods(:,15) = aux(:, end);   

% 2080  -  'Frequency of tiredness in last 2 weeks'
aux = dirty(:, mods_names == 2080);
small_vars_mods(:,16) = aux(:, end);

% 2050  -  'Frequency of depressed mood in the last 2 weeks'
aux = dirty(:, mods_names == 2050);
small_vars_mods(:,17) = aux(:, end);

% 21001 -  'BMI'
aux = dirty(:, mods_names == 21001);
small_vars_mods(:,18) = aux(:, end);

% 20002 -  'Self-reported hypertension'
aux = dirty(:, mods_names == 20002);
hypten = sum(aux == 1065, 2) > 0;
small_vars_mods(:,19) = hypten;

% 4079  -  'Diastolic blood pressure'
aux = dirty(:, mods_names == 4079);
small_vars_mods(:,20) = aux(:, end);

% 4080  -  'Systolic blood pressure'
aux = dirty(:, mods_names == 4080);
small_vars_mods(:,21) = aux(:, end);

% 2443  -  'Diabetes dignosed by a doctor'
aux = dirty(:, mods_names == 2443);
diabetes = sum(aux, 2) > 0;
small_vars_mods(:,22) = diabetes;

% 1031  -  'Frequency of family visits'
aux = dirty(:, mods_names == 1031);
small_vars_mods(:,23) = change_encoding(aux(:, end), [1,2,3,4,5,6,7], [5,4,3,2,1,0,0]);

% 6160  -  'Leasure/social activities'
aux = dirty(:, mods_names == 6160);
small_vars_mods(:,24) = sum(aux > 0, 2) > 0;

% 4230  -  'Hearing on left ear'
aux = dirty(:, mods_names == 4230);
lo = aux(:, end) < -5.5;
mi = and(aux(:, end) >= -5.5, aux(:, end) < -3.5);
hi = aux(:, end) >= -3.5;
small_vars_mods(:,25) = 0 * lo + 1 * mi + 2 * hi; 

% 4241  -  'Hearing on right ear'
aux = dirty(:, mods_names == 4241);
lo = aux(:, end) < -5.5;
mi = and(aux(:, end) >= -5.5, aux(:, end) < -3.5);
hi = aux(:, end) >= -3.5;
small_vars_mods(:,26) = 0 * lo + 1 * mi + 2 * hi;   

% 2247  -  'Hearing difficulty'
aux = dirty(:, mods_names == 2247);
aux = aux(:, end);
aux(find(aux == 99)) = 1;
small_vars_mods(:,27) = aux;

% 2257  -  'Hearing difficulty with background noise'
aux = dirty(:, mods_names == 2257);
aux = aux(:, end);
aux(find(aux == 99)) = 1;
small_vars_mods(:,28) =  aux;

% 20016 -  'Fluid intelligence score'
aux = dirty(:, mods_names == 20016);
small_vars_mods(:,29) =  aux(:, end);

% 20023 -  'Reaction time'
aux = dirty(:, mods_names == 20023);
small_vars_mods(:,30) = aux(:, end);

% 400   -  'Pairs matching test'
aux = dirty(:, mods_names == 400);
small_vars_mods(:,31) = aux(:, end - 1);

% 20018 -  'Prospective memory result'
aux = dirty(:, mods_names == 20018);
small_vars_mods(:,32) = aux(:, end);

% 6152.1  'Inflammation/immuno-response - Asthma'
aux = dirty(:, mods_names == 6152);
asthma = sum(aux == 8, 2) > 0;
small_vars_mods(:, 33) = asthma;

% 6152.1  'Inflammation/immuno-response - Hayfever'
hayfever = sum(aux == 9, 2) > 0;
small_vars_mods(:, 34) = hayfever;

% 6153.1  'Cholesterol or blood pressure medication'
aux = dirty(:, mods_names == 6153);
cholesterol = sum(aux == 1, 2) > 0;
small_vars_mods(:, 35) = cholesterol;

% 6153.2  'Cholesterol or blood pressure medication'
aux = dirty(:, mods_names == 6153);
blood = sum(aux == 2, 2) > 0;
small_vars_mods(:, 36) = blood;

% 33      'Age'
aux = dirty(:, mods_names == 33);
small_vars_mods(:, 37) = aux;

% 6138    'Education'
aux = dirty(:, mods_names == 6138);
small_vars_mods(:, 38) = aux(:, 1);

% 738     'Social Economic Status'
aux = dirty(:, mods_names == 738);
small_vars_mods(:, 39) = aux(:, end);

% 31      'Gender'
aux = dirty(:, mods_names == 31);
small_vars_mods(:, 40) = aux;

% 6141    'Marital status'
aux = dirty(:, mods_names == 6141);
small_vars_mods(:, 41) = sum(aux == 1, 2) > 0;

fprintf('--- Done! ---\n');

%% Saving
%----------------------------------------------------------
fprintf('--- Saving as Matlab file --- \n');

small_names_var_mods = names_var_mods;
small_names_var_idps = names_idps;
save('../small-matrix/small_cleaned.mat', ...
     'small_vars_mods',...
     'small_vars_idps',...
     'small_names_var_mods', ...
     'small_names_var_idps');

fprintf('--- Done! ---\n');

%% Writing to CSV
%----------------------------------------------------------
fprintf('--- Saving as csv files --- \n');

csvwrite('../small-matrix/small_vars_mods.csv', small_vars_mods);
csvwrite('../small-matrix/small_vars_idps.csv', small_vars_idps);
csvwrite('../small-matrix/small_names_vars_mods.csv', ...
         small_names_vars_mods);
csvwrite('../small-matrix/small_names_vars_idps.csv', ...
         small_names_vars_idps);


small_vars_all = [small_vars_mods, small_vars_idps]; 

fid  = fopen('../small-matrix/small_clean_all.csv', 'w')
for ii = 1:length(descr_var_mods)
    fprintf(fid, '%s, ' descr_var_mods{ii});
end
csvwrite('../small-matrix/small_clean_all.csv', small_vars_all, '-append');
    
fprintf('--- All done! :D ---\n')