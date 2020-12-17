function spm_motion_correction(config_file_path, nifti, output_dir)
%{
    spm_motion_correction([config_file_path], [nifti], [output_dir])

Perform Motion Correction with standalone SPM version
https://www.fil.ion.ucl.ac.uk/spm/software/spm12/

Co-registration to first frame

Example matlab script which uses MCR

*ExtFPList -> SPM command
*Path/to/folder -> Not the file itself
* regex -> ^MCAver.nii$ for instance
*Inf -> SPM command to list all the frames within a nifti file

Example Usage:
   spm_motion_correction([], '/Users/Shared/scratch/APPS/SPM_MOTION_CORR/22163_16_1.nii.gz');

%}


%% Set path variables and read config file

disp('Initialized...');

% Load configuration file json
if exist('config_file_path', 'var') && exist(config_file_path, 'file')
    raw_config = jsondecode(fileread(config_file_path));
else
    raw_config = {};
end


% Handle nifti file
if ~exist('nifti', 'var') || ~exist(nifti, 'file')
    if isempty(raw_config)
        error('No NIfTI path was passed in and %s does not exist!', (config_file_path));
    else
        nifti = raw_config.inputs.nifti.location.path;
    end
end


% Check  for output directory
if ~exist('output_dir', 'var') && ~isempty(raw_config)
    output_dir = fullfile(fileparts(config_file_path), 'output');
elseif ~exist('output_dir', 'var')
    output_dir = fullfile(fileparts(nifti), 'output');
end

if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end

% GUNZIP compressed NIfTI files (which SPM does not support)
if contains(nifti, '.nii.gz')
    gunzip(nifti, output_dir);
else
    copyfile(nifti, output_dir)
end



%% Run the thing

spm('defaults','fmri');
spm_jobman('initcfg');
niiframes = spm_select('ExtFPList', output_dir , '.*nii$', Inf);
matlabbatch{1}.spm.spatial.realign.estwrite.data = {cellstr(niiframes)};
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.quality = 0.9;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.sep = 4;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.fwhm = 5;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.rtm = 1;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.interp = 2;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.weight = '';
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.which = [0 1];
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.interp = 4;
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.mask = 1;
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.prefix = 'r';
spm_jobman('run', matlabbatch);



disp('Complete!');


end
