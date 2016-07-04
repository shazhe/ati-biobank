function varargout = load_actions(filename)
% LOAD_ACTIONS Loads the CSV file with the actions and
% pre-processes instructions to make an excel file.

if nargin < 1
    filename = 'bbuk-variables.csv';
end

file = fopen(filename);

% Remove headers
headers = textscan(file, '%s', 16, 'Delimiter', ',');

% Get data
raw_data = textscan(file, ...
                    '%d %s %d %s %d %d %s %s %s %s %d %s %s %s %s %s',...
                    'Delimiter', ',');
% Remove file
fclose(file);

% Separate raw_data into intelligible variables
names = raw_data{1};         % Integer
parent1 = raw_data{5};       % Integer
parent2 = raw_data{6};       % Integer
parent1_vals = raw_data{7};  % String with hash-separated values
parent2_vals = raw_data{8};  % String with hash-separated values
missing_fix = raw_data{10};  % String
bbuk_levels = raw_data{12};  % String with hash-separated values
new_levels = raw_data{13};   % String with hash-separated values
processing = raw_data{14};   % String

% Pre-process hash-separated strings
parent1_vals = hsv2cell(parent1_vals);
parent2_vals = hsv2cell(parent2_vals);
bbuk_levels = hsv2cell(bbuk_levels);
new_levels = hsv2cell(new_levels);

% Pre-process strings
missing_fix = prep_missing(missing_fix);
processing = prep_processing(processing);

% Outputting
varargout{1} = names;
varargout{2} = parent1;
varargout{3} = parent2;
varargout{4} = parent1_vals;
varargout{5} = parent2_vals;
varargout{6} = bbuk_levels;
varargout{7} = new_levels;
varargout{8} = processing;

end
