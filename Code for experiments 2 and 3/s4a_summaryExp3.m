clc
clear
close all

% Defines the folders.
bids_dir   = '../data/exp2and3';

% Defines the anatomies to check.
anas = { 'intact'; 'trimmed'; 'defaced' };


% Adds SPM12 to the path.
addpath ( sprintf ( '%s/osl/spm12', fileparts ( pwd ) ) );
spm defaults eeg

% Adds OSL to the path.
addpath ( sprintf ( '%s/osl/osl-core', fileparts ( pwd ) ) )
osl_startup
% osl_check_installation

% Adds the functions folder to the path.
addpath ( sprintf ( '%s/functions', pwd ) ); % To get modifications to rhino.m


% Lists the subjects.
files  = dir ( sprintf ( '%s/MEG/*.mat', bids_dir ) );
files  = { files.name };
subs   = unique ( strtok ( files (:), '_' ) );
nsub   = numel ( subs );

% Reserves memory for the subject errors.
errs   = cell ( nsub, 1 );
coerrs = cell ( nsub, 1 );

% Goes through each subject.
for sub = 1: numel ( subs )
    
    % Reserves memory for the meshes of this subject.
    meshes = cell ( numel ( anas ), 1 );
    
    % Goes through each anatomy.
    for ana = 1: numel ( anas )
        
        % Loads the MEG file.
        infile = sprintf ( '%s/MEG/%s_meg_%s_spm.mat', bids_dir, subs { sub }, anas { ana } );
        D      = spm_eeg_load ( infile );
        
        % Convert the inner skull mesh to a GIfTI structure.
        mesh   = gifti ( D.inv {1}.mesh.tess_iskull );
        
        % Stores the structure.
        meshes { ana } = mesh;
    end
    
    % Concatenates all the meshes.
    meshes = cat ( 1, meshes {:} );
    
    % Reserves memory for the errors.
    err    = cell ( numel ( anas ) - 1, 1 );
    coerr  = cell ( numel ( anas ) - 1, 1 );
    
    for ana = 2: numel ( anas )
        
        % Extracts the vertices from the original and modified meshes.
        vert1 = meshes (1).vertices;
        verti = meshes ( ana ).vertices;
        
        % Calculates the error between both meshes.
        dist  = sqrt ( sum ( ( verti - vert1 ) .^ 2, 2 ) );
        
        % Stores the error.
        err { ana - 1 } = dist;
        
        
        % Coregisters the original and modified meshes.
        [ M, ~ ] = rhino_icp ( vert1', verti', 10 );
        coverti = spm_eeg_inv_transform_points ( M, verti );
        
        % Calculates the error between the coregistered meshes.
        codist = sqrt ( sum ( ( coverti - vert1 ) .^ 2, 2 ) );
        
        % Stores the error.
        coerr { ana - 1 } = codist;
        
        
%         % Coregisters the original and modified meshes.
%         M = [ vert1 ones( 2562, 1 ) ]' / [ verti ones( 2562, 1 ) ]';
%         coverti = spm_eeg_inv_transform_points ( M, verti );
%         
%         % Calculates the error between the coregistered meshes.
%         codist = sqrt ( sum ( ( coverti2 - vert1 ) .^ 2, 2 ) );
        
%         % Stores the error.
%         coerr { ana - 1 } = codist;
    end
    
    % Concatenates the errors.
    err   = cat ( 2, err {:} );
    coerr = cat ( 2, coerr {:} );
    
    % Stores the errores.
    errs   { sub } = err;
    coerrs { sub } = coerr;
end

% Concatenates the errors for all the subjects.
errs   = cat ( 3, errs {:} );
coerrs = cat ( 3, coerrs {:} );

% Saves the parameters and errors.
save ( '-v6', 'iSkullErr.mat', 'subs', 'anas', 'errs', 'coerrs' )
