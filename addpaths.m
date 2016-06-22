%% addpaths.M
% Script to add relevant paths to the present working directory
% Paths added in this script:
%    /usr/local/fmrib/fmt/
%    /usr/local/fsl/etc/matlab
%    ~steve/NETWORKS/FSLNets
%    ~steve/NETWORKS/FSLNetsPredict 
%    ~steve/matlab/glmnet
%    ~steve/matlab/FastICA_25
%    ~steve/matlab/FACS
fprintf('Loading relevant paths... ');

% fMRIB functios
addpath('/usr/local/fmrib/fmt/');
addpath('/usr/local/fsl/etc/matlab'); % FIXME: this doesn't work...
addpath('/home/fs0/steve/NETWORKS/FSLNets');
addpath('/home/fs0/steve/NETWORKS/FSLNetsPredict');
addpath('/home/fs0/steve/matlab/glmnet');
addpath('/home/fs0/steve/matlab/FastICA_25');
addpath('/home/fs0/steve/matlab/FACS'); % FIXME: this doesn't work...

fprintf('OK!\n');
