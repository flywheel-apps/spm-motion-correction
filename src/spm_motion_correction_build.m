function spm_motion_correction_build(spm_path)
%
% EXAMPLE USAGE
%       matlab -nodesktop -r 'spm_motion_correction_build.m'

% Check that we are running a compatible matlab version (important for docker execution)
if (~contains(version, '9.7')) || (~contains(computer, 'GLNXA64'))
    error('You must compile this function using R2019b. You are using %s, %s', version, computer);
end

% Make sure we're in the right location
disp(mfilename('fullpath'));
compileDir = fileparts(mfilename('fullpath'));
if ~strcmpi(pwd, compileDir)
    error('You must run this code from %s', compileDir);
end

% Check for SPM on the path
if (~exist('spm_path', 'var') || ~exist(spm_path, 'dir'))
    spm_path = fileparts(which('spm'));
    if isempty(spm_path) || ~exist(spm_path, 'dir')
        error('SPM could not be found! Please add to your path or supply as input to this build command!');
    end
end

% Set paths
disp('Adding paths to build scope...');
restoredefaultpath;
addpath(genpath(spm_path));

% Compile
if ~exist('./bin', 'dir')
    mkdir('./bin')
end

disp('Running compile code...');

mcc('-v', '-R', '-nodisplay',...
    '-m', './spm_motion_correction.m',...
     '-a', spm('Dir'),...
     '-d', './bin');

disp('Done!');

