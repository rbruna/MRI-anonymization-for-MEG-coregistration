clc
clear
close all

anas = { 'intact'; 'trimmed'; 'defaced' };

% Gets the error using only the fiducials.
load ( 'FidErr_FidsOnly' )

% Extracts the error.
fid_error = cat ( 3, fid_error {:} );
fid_error = permute ( fid_error, [ 3 2 1 ] );
err_orig  = fid_error ( :, 1, 1 );
err_fids  = fid_error ( :, :, 2 );

% Checks that no subject increased its error after coregistration.
if any ( err_fids > err_orig )
    warning ( 'Error increased with coregistration!' )
end



% Gets the error using RHINO, but with no nose.
load ( 'FidErr_rhino' )

% Extracts the error.
fid_error = cat ( 3, fid_error {:} );
fid_error = permute ( fid_error, [ 3 2 1 ] );
err_rh    = fid_error ( :, :, 2 );


% Gets the error using RHINO with no nose.
load ( 'FidErr_rhino_nonose' )

% Extracts the error.
fid_error = cat ( 3, fid_error {:} );
fid_error = permute ( fid_error, [ 3 2 1 ] );
err_rhnn  = fid_error ( :, :, 2 );

% Gets the error using SPM.
load ( 'FidErr_spm' )

% Extracts the error.
fid_error = cat ( 3, fid_error {:} );
fid_error = permute ( fid_error, [ 3 2 1 ] );
err_spm   = fid_error ( :, :, 2 );

% Gets the error using SPM with no nose.
load ( 'FidErr_spm_nonose' )

% Extracts the error.
fid_error = cat ( 3, fid_error {:} );
fid_error = permute ( fid_error, [ 3 2 1 ] );
err_spmnn = fid_error ( :, :, 2 );



% Defines the pairs of images.
pairs = nchoosek ( 1: numel ( anas ), 2 );


% Calculates the statistics for RHINO with nose.
fprintf ( 1, 'Coregistration using RHINO.\n' )

% Goes through each anatomy.
for ana = 1: size ( anas, 1 )
    
    % Prints the median value.
    fprintf ( 1, '  Median error for anatomy %s: %.2f mm.\n', anas { ana }, median ( err_rh ( :, ana ) ) )
end

% Goes through each pair.
for pair = 1: size ( pairs, 1 )
    
    % Compares the two images.
    p = signrank ( err_rh ( :, pairs ( pair, 1 ) ), err_rh ( :, pairs ( pair, 2 ) ) );
    
    % Prints the result.
    fprintf ( 1, '  Comparison between %s and %s. p = %.4f.\n', anas { pairs ( pair, : ) }, p )
end

fprintf ( 1, '\n' );


% Calculates the statistics for RHINO without nose.
fprintf ( 1, 'Coregistration using RHINO without the nose.\n' )

% Goes through each anatomy.
for ana = 1: size ( anas, 1 )
    
    % Prints the median value.
    fprintf ( 1, '  Median error for anatomy %s: %.2f mm.\n', anas { ana }, median ( err_rhnn ( :, ana ) ) )
end

% Goes through each pair.
for pair = 1: size ( pairs, 1 )
    
    % Compares the two images.
    p = signrank ( err_rhnn ( :, pairs ( pair, 1 ) ), err_rhnn ( :, pairs ( pair, 2 ) ) );
    
    % Prints the result.
    fprintf ( 1, '  Comparison between %s and %s. p = %.4f.\n', anas { pairs ( pair, : ) }, p )
end

fprintf ( 1, '\n' );


% Calculates the statistics for SPM with nose.
fprintf ( 1, 'Coregistration using SPM.\n' )

% Goes through each anatomy.
for ana = 1: size ( anas, 1 )
    
    % Prints the median value.
    fprintf ( 1, '  Median error for anatomy %s: %.2f mm.\n', anas { ana }, median ( err_spm ( :, ana ) ) )
end

% Goes through each pair.
for pair = 1: size ( pairs, 1 )
    
    % Compares the two images.
    p = signrank ( err_spm ( :, pairs ( pair, 1 ) ), err_spm ( :, pairs ( pair, 2 ) ) );
    
    % Prints the result.
    fprintf ( 1, '  Comparison between %s and %s. p = %.4f.\n', anas { pairs ( pair, : ) }, p )
end

fprintf ( 1, '\n' );


% Calculates the statistics for SPM without nose.
fprintf ( 1, 'Coregistration using SPM without the nose.\n' );

% Goes through each anatomy.
for ana = 1: size ( anas, 1 )
    
    % Prints the median value.
    fprintf ( 1, '  Median error for anatomy %s: %.2f mm.\n', anas { ana }, median ( err_spmnn ( :, ana ) ) )
end

% Goes through each pair.
for pair = 1: size ( pairs, 1 )
    
    % Compares the two images.
    p = signrank ( err_spmnn ( :, pairs ( pair, 1 ) ), err_spmnn ( :, pairs ( pair, 2 ) ) );
    
    % Prints the result.
    fprintf ( 1, '  Comparison between %s and %s. p = %.4f.\n', anas { pairs ( pair, : ) }, p )
end

fprintf ( 1, '\n' );



% Makes some extra comparisons.

% Trimmed version, with nose, vs. Defaced version, with no nose.
p = signrank ( err_rh ( :, 2 ), err_rhnn ( :, 3 ) );

fprintf ( 1, 'Median error for anatomy Trimmed (with nose): %.2f mm.\n', median ( err_rh ( :, 2 ) ) )
fprintf ( 1, 'Median error for anatomy Defaced (no nose): %.2f mm.\n', median ( err_rhnn ( :, 3 ) ) )
fprintf ( 1, 'Comparison between Trimmed (with nose) and Defaced (no nose). p = %.4f.\n', p )
fprintf ( 1, '\n' );



merr_fids  = median ( err_fids, 1 );
merr_rh    = median ( err_rh, 1 );
merr_rhnn  = median ( err_rhnn, 1 );
merr_spm   = median ( err_spm, 1 );
merr_spmnn = median ( err_spmnn, 1 );

table = array2table ( [ merr_fids merr_rh; merr_fids merr_rhnn; merr_fids merr_spm; merr_fids merr_spmnn ] );
table.Properties.VariableNames = { 'Fids only' 'Intact' 'Trimmed' 'Defaced' };
table.Properties.RowNames = { 'RHINO with nose' 'RHINO without nose' 'SPM with nose' 'SPM without nose' };

fprintf ( 1, 'Median fiducial errors.\n' )
disp ( table )


merr_fids  = mean ( err_fids, 1 );
merr_rh    = mean ( err_rh, 1 );
merr_rhnn  = mean ( err_rhnn, 1 );
merr_spm   = mean ( err_spm, 1 );
merr_spmnn = mean ( err_spmnn, 1 );

table = array2table ( [ merr_fids merr_rh; merr_fids merr_rhnn; merr_fids merr_spm; merr_fids merr_spmnn ] );
table.Properties.VariableNames = { 'Fids only' 'Intact' 'Trimmed' 'Defaced' };
table.Properties.RowNames = { 'RHINO with nose' 'RHINO without nose' 'SPM with nose' 'SPM without nose' };

fprintf ( 1, 'Mean fiducial errors.\n' )
disp ( table )
