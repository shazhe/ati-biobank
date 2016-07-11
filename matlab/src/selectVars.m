%% Select variables of interests for hypotheis-driven testing

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

%% Input the names of the variables
%  grouped in cellls acoording to types
%  1 Modifiable risk factors
%  2 Brain function
%  3 Confound/factors for interpretaion
%  4 misc

V_in{1}  =  [1329 2003 6155 1239 1249 1558 864 884 904 1170 1160 2080 2050 21001 ...
          20002 4079 4080 2443 1031 6160 2247 2257 ];

V_in{2} = [20016 20023 398 20018];

V_in{3} = [33 6138 738 31 6141 41202];

V_in{4} = [6152 6153];

Vin = horzcat(V_in{1}, V_in{2}, V_in{3}, V_in{4}); % 34 in total

[~, ~, idxin] = intersect(Vin, allnames); % This gives me only 24 variables, why?
Vkeep = dirty(:, idxin);
