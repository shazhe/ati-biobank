function plot2file(varargin)
% Plots straight to file

%% Input processing (setting to default when not supplied).
if nargin >= 1
    var = varargin{1};
else
    Error = MException('plot2file:NotEnoughInputs',...
                       'No variable was supplied for plotting.\n');
    throw(Error);
end

if nargin >= 2
    plotfun = varargin{2};
else
    plotfun = 'plot';
end

if nargin >= 3
    filename = varargin{3};
else
    filename = 'plot';
end

if nargin >= 4
    extension = varargin{4};
else
    extension = 'png';
end

%% Main code
f = figure('visible', 'off');
eval([plotfun, '(var);']);
saveas(f, filename, extension);

end