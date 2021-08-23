clc
clear
close all

% Defines the folders.
bids_dir = '../data/exp2and3';


% Assumes all types of T1 are coreg (takes fiducials from intact only)

% TODO:
% go through plots again with nose points
% check headpoints-scalp error for fids only?
% Need refMRI for SPM-Rhino comparison?

% sub-Sub0307_ses-meg1_T1w.nii - low positioning, but coreg seems ok,so keep

% Subjects with 3 high fid error
%    Sub0266 - hpi coreg seems ok, but just slips in pitch direction?
%    Sub0157 - nose squashed in MRI, so rhino surface poor - remove?
%    Sub0054 - MRI ok, but scalp coreg poor?


% Adds SPM12 to the path.
addpath ( sprintf ( '%s/osl/spm12', fileparts ( pwd ) ) );
spm defaults eeg

% Adds OSL to the path.
addpath ( sprintf ( '%s/osl/osl-core', fileparts ( pwd ) ) )
osl_startup
% osl_check_installation

% Adds the functions folder to the path (modifications to RHINO).
addpath ( sprintf ( '%s/functions', pwd ) );


% Lists the subjects.
subs   = dir ( fullfile ( bids_dir, 'MRI_intact', 'sub-Sub*' ) ); 
subs   = char ( subs.name );
nsub   = size ( subs, 1 );

% Initializes the error cell arrays.
fid_error = cell ( nsub, 1 );
% rhino_err = cell ( nsub, 1 );
% ctx_dist  = cell ( nsub, 1 );

% Goes through each subject.
for isub = 1: nsub
    
    % Gets the current subject.
    sub = subs ( isub, : );
    
    fprintf ( 1, 'Working with subject %s.\n', sub );
    
    % Gets the voxel-to-real-word transformation fromt he original image.
    T1file = sprintf ( '%s/MRI_intact/%s/%s_ses-meg1_T1w_intact.nii.gz', bids_dir, sub, sub );
    T1file = gunzip ( T1file );
    T1file = T1file {1};
    V      = spm_vol ( T1file );
    delete ( T1file );
    
    % Reads the fiducials in voxel space.
    fids   = spm_jsonread ( sprintf ( '%s/MRI_intact/%s/%s_ses-meg1_T1w.json',bids_dir, sub, sub ) );
    nasion = fids.AnatomicalLandmarkCoordinates.Nasion;
    lpa    = fids.AnatomicalLandmarkCoordinates.LPA;
    rpa    = fids.AnatomicalLandmarkCoordinates.RPA;
    
    % Converts the fiducials into real-world coordinates.
    nasion = ( V.mat ( 1: 3, 1: 3 ) * nasion + V.mat ( 1: 3, 4 ) )';
    lpa    = ( V.mat ( 1: 3, 1: 3 ) * lpa    + V.mat ( 1: 3, 4 ) )';
    rpa    = ( V.mat ( 1: 3, 1: 3 ) * rpa    + V.mat ( 1: 3, 4 ) )';
    
    % Builds a fiducials structure for the MRI.
    mrifid           = [];
    mrifid.fid.label = { 'Nasion'; 'LPA'; 'RPA' };
    mrifid.fid.pnt   = [ nasion; lpa; rpa ];
    
    
    % Initializes the errors.
    fid_error{isub} = nan ( 2, 1 ); 
    
    
    % Gets the original MEG data.
    D = spm_eeg_load ( sprintf ( '%s/MEG/%s_meg.mat', bids_dir, sub ) );
    
    % Gets the MEG head shape and fiducial definition.
    megfid = D.fiducials;
    
    
    % Estimates the coregistration error.
    coerr = zeros ( length ( megfid.fid.label ), 3 );
    for f = 1: length ( megfid.fid.label )
        ff = strcmp ( mrifid.fid.label {f}, megfid.fid.label );
        coerr ( f,: ) = megfid.fid.pnt ( f, : ) - mrifid.fid.pnt ( ff, : );
    end
    
    fid_error {isub} ( 1, 1 ) = mean ( sqrt ( sum ( coerr .^ 2, 2 ) ), 1 );
    
    
    % Makes a copy of the MEG data.
    S = load ( fullfile ( D.path, D.fname ) );
    D = S.D;
    D.fname = sprintf( '%s_fid.mat', D.fname ( 1: end - 4 ) );
    save ( fullfile ( D.path, D.fname ), 'D' );
    D = spm_eeg_load ( fullfile ( D.path, D.fname ) );
    
    
    % Coregisters using only the fiducials.
    S              = [];
    S.D            = D;
    S.sourcefid    = megfid;
    S.targetfid    = mrifid;
    S.useheadshape = 0;
    S.template     = 0;
    M1             = spm_eeg_inv_datareg ( S );
    
    % Gets the position of the MRI fiducials after coregistration.
    corfid = ft_transform_headshape ( inv ( M1 ), mrifid );
    
    % Adds a dummy mesh.
    D.inv {1}.mesh                = spm_eeg_inv_mesh;
    
    % Saves the coregistration.
    D.inv {1}.datareg(1).sensors  = D.sensors ( 'MEG' );
    D.inv {1}.datareg(1).fid_eeg  = megfid;
    D.inv {1}.datareg(1).fid_mri  = corfid;
    D.inv {1}.datareg(1).toMNI    = M1;
    D.inv {1}.datareg(1).fromMNI  = inv ( M1 );
    D.inv {1}.datareg(1).modality = 'MEG';
    D.save;
    % spm_eeg_inv_checkdatareg ( D )
    
    
    % Estimates the coregistration error.
    coerr = zeros ( length ( megfid.fid.label ), 3 );
    for f = 1: length ( megfid.fid.label )
        ff = strcmp ( corfid.fid.label {f}, megfid.fid.label );
        coerr ( f,: ) = megfid.fid.pnt ( f, : ) - corfid.fid.pnt ( ff, : );
    end
    
    fid_error {isub} ( 2, 1 ) = mean ( sqrt ( sum ( coerr .^ 2, 2 ) ), 1 );
    
%     figure
%     hold on
%     plot3(D.inv{1}.datareg.fid_eeg.pnt(:,1),D.inv{1}.datareg.fid_eeg.pnt(:,2),D.inv{1}.datareg.fid_eeg.pnt(:,3),'k.')
%     for f = 1:length(D.inv{1}.datareg.fid_eeg.fid.label)
%         plot3(D.inv{1}.datareg.fid_eeg.fid.pnt(f,1),D.inv{1}.datareg.fid_eeg.fid.pnt(f,2),D.inv{1}.datareg.fid_eeg.fid.pnt(f,3),'ro');
%         plot3(D.inv{1}.datareg.fid_mri.fid.pnt(f,1),D.inv{1}.datareg.fid_mri.fid.pnt(f,2),D.inv{1}.datareg.fid_mri.fid.pnt(f,3),'bx');
%     end
%     axis equal vis3d
%     rotate3d
end

% Saves the result.
save ( 'FidErr_FidsOnly', 'fid_error', 'subs' );
