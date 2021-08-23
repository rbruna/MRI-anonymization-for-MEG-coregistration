clc
clear
close all

% Defines the folders.
bwd      = '../data/exp2and3';

% Lists the subjects.
subs     = 1: 324;


% Adds NIfTI tools to the path.
addpath ( sprintf ( '%s/toolboxes/nifti', fileparts ( pwd ) ) );

% Adds the functions folder to the path (modifications to reslice_nii).
addpath ( sprintf ( '%s/functions', pwd ) );


% Goes through each subject.
for sub = subs
    
    % Reslices, if existing, the original image.
    sub_dir = sprintf ( '%s/MRI_intact/sub-Sub%04d', bwd, sub );
    if exist ( sub_dir, 'dir' )
        infile  = sprintf ( '%s/sub-Sub%04d_ses-meg1_T1w_intact.nii.gz', sub_dir, sub );
        outfile = sprintf ( '%s/rsub-Sub%04d_ses-meg1_T1w_intact.nii.gz', sub_dir, sub );
        reslice_nii ( infile, outfile );
    end
    
    % Reslices, if existing, the trimmed image.
    sub_dir = sprintf('%s/MRI_trimmed/sub-Sub%04d',bwd,sub);
    if exist ( sub_dir, 'dir' )
        infile  = sprintf ( '%s/sub-Sub%04d_ses-meg1_T1w_trimmed.nii.gz', sub_dir, sub );
        outfile = sprintf ( '%s/rsub-Sub%04d_ses-meg1_T1w_trimmed.nii.gz', sub_dir, sub );
        reslice_nii ( infile, outfile );
%         delete ( infile )
    end
    
    % Reslices, if existing, the defaced image.
    sub_dir = sprintf('%s/MRI_defaced/sub-Sub%04d',bwd,sub);
    if exist ( sub_dir, 'dir' )
        infile  = sprintf ( '%s/sub-Sub%04d_ses-meg1_T1w_defaced.nii.gz', sub_dir, sub );
        outfile = sprintf ( '%s/rsub-Sub%04d_ses-meg1_T1w_defaced.nii.gz', sub_dir, sub );
        reslice_nii ( infile, outfile );
%         delete ( infile )
    end
end
