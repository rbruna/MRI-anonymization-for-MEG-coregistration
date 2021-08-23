clc
clear
close all

% Defines the folders.
raw_dir  = '../data/raw';
bids_dir = '../data/BioFind/bids/meg';
out_dir  = '../data/exp2and3';


% Lists the subjects in the BioFIND database.
subs     = 1: 324;

% Subjects from BioFIND database to exclude:
% * sub-Sub0023_ses-meg1_T1w.nii
%   Dental artifact, coreg just about ok, but remove for VBM.
% * sub-Sub0197_ses-meg1_T1w.nii
%   Dental artifact, coreg affected and remove for VBM.
% * sub-Sub0248
%   Large fid-only error: LPA/RPA much more lateral in megfids.
% * sub-Sub0157
%   Too faint MRI: skull extraction completely fails.
% * sub-Sub0048
%   Inhomogeniety at top of image: scalp extraction failing.
excludes = [  23 197 248 157  48 ];
subs     = setdiff ( subs, excludes );

% Adds SPM12 to the path.
addpath ( sprintf ( '%s/spm12', fileparts ( pwd ) ) );
spm defaults eeg


% Goes through each subject.
for sub = subs
    
    % Checks if the subject exists.
    infile = sprintf ( '%s/MRI/sub-Sub%04d_ses-meg1_T1w.nii.gz', raw_dir, sub );
    if ~exist ( infile, 'file' ), continue, end
    
    
    % Gets the MEG file.
    infile = sprintf ( '%s/sub-Sub%04d/ses-meg1/ffdspmeeg.mat', megs_dir, sub );
    D = spm_eeg_load ( infile );
    if isfield ( D, 'inv' ), D = rmfield ( D, 'inv' ); end
    
    % Copies the MEG file.
    S = [];
    S.D = D;
    S.outfile = sprintf ( '%s/MEG/sub-Sub%04d_meg', out_dir, sub );
    D = spm_eeg_copy ( S );
    
    % Keeps only the first sample.
    S = [];
    S.D = D;
    S.timewin = [ 0 0 ];
    S.prefix = 'c';
    D = spm_eeg_crop ( S );
    
    % Overwrites the data.
    D.move ( sprintf ( '%s/MEG/sub-Sub%04d_meg', out_dir, sub ) );
    
    
    % Creates the BIDS tree for the intact image and the fiducials.
    sub_dir = sprintf ( '%s/MRI_intact/sub-Sub%04d', out_dir, sub );
    if ~exist ( sub_dir, 'dir'), mkdir ( sub_dir ), end
    
    % Copies the fiducials.
    infile  = sprintf ( '%s/sub-Sub%04d/ses-meg1/anat/sub-Sub%04d_ses-meg1_T1w.json', bids_dir, sub, sub );
    outfile = sprintf ( '%s/sub-Sub%04d_ses-meg1_T1w.json', sub_dir, sub );
    copyfile ( infile, outfile )
    
    % Copies the intact image.
    infile  = sprintf ( '%s/MRI/sub-Sub%04d_ses-meg1_T1w.nii.gz', raw_dir, sub );
    outfile = sprintf ( '%s/sub-Sub%04d_ses-meg1_T1w_intact.nii.gz', sub_dir, sub );
    copyfile ( infile, outfile )
    
    
    % Creates the BIDS tree for the trimmed image.
    sub_dir = sprintf ( '%s/MRI_trimmed/sub-Sub%04d', out_dir, sub );
    if ~exist ( sub_dir, 'dir'), mkdir ( sub_dir ), end
    
    % Copies the trimmed image.
    infile  = sprintf ( '%s/MRI-trimmed/sub-Sub%04d_ses-meg1_T1w.nii.gz', raw_dir, sub );
    outfile = sprintf ( '%s/sub-Sub%04d_ses-meg1_T1w_trimmed.nii.gz', sub_dir, sub );
    copyfile ( infile, outfile )
    
    
    % Creates the BIDS tree for the defaced image.
    sub_dir = sprintf ( '%s/MRI_defaced/sub-Sub%04d',out_dir,sub);
    if ~exist ( sub_dir, 'dir'), mkdir ( sub_dir ), end
    
    % Copies the defaced image.
    infile  = sprintf ( '%s/MRI-defaced/sub-Sub%04d_ses-meg1_T1w.nii.gz', raw_dir, sub );
    outfile = sprintf ( '%s/sub-Sub%04d_ses-meg1_T1w_defaced.nii.gz', sub_dir, sub );
    copyfile ( infile, outfile )
end
