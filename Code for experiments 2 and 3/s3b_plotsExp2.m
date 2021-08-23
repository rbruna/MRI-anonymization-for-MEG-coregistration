clc
clear
close all

anas = { 'intact'; 'trimmed'; 'defaced' };


% Adds NotBoxPlots to the path.
addpath ( sprintf ( '%s/toolboxes/notboxplots', fileparts ( pwd ) ) );



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


% Gets the error using RHINO and no nose.
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


% Gets the error using SPM and no nose.
load ( 'FidErr_spm_nonose' )

% Extracts the error.
fid_error = cat ( 3, fid_error {:} );
fid_error = permute ( fid_error, [ 3 2 1 ] );
err_spmnn = fid_error ( :, :, 2 );



% Generates the figure.
figure ( 'Units', 'centimeters', 'Position', [  0.0  0.0 15.2  6.0 ] )

% Plots the Y-axis.
axes ( 'Units', 'centimeters', 'Position', [ 1.2  0.6  0.0  4.8 ], 'FontSize', 9 )
xlim ( [ 0 1 ] )
ylim ( [ 0 round( max ( max ( err_rh (:) ), max ( err_rhnn (:) ) ) + 5, -1 ) ] )
ylabel ( 'Mean fiducial error (mm)' );


% Plots the fiducial error when considering the nose.
axes ( 'Units', 'centimeters', 'Position', [ 1.2  0.6  7.0  4.8 ], 'FontSize', 9 )
% boxplot ( [ err_fids err_rh ], 'notch', 'on' )
notBoxPlot ( [ err_fids err_rh ] )

% Fixes the boxplot.
patches  = findall ( gca, 'Type', 'Patch' );
set ( patches, 'FaceAlpha', 0.6, 'EdgeAlpha', 0.6 )
lines    = findall ( gca, 'Type', 'Line', 'Marker', 'none' );
set ( lines, 'LineWidth', 0.1 )
markers  = findall ( gca, 'Type', 'Line', 'LineStyle', 'none' );
set ( markers, 'MarkerSize', 4 )
uistack ( markers, 'bottom' )

% Adds the labels.
title ( 'Head points with nose' )
xlim ( [ 0.5 4.5 ] )
ylim ( [ 0 round( max ( max ( err_rh (:) ), max ( err_rhnn (:) ) ) + 5, -1 ) ] )
set ( gca, 'XTickLabel', { 'Fids Only', 'Intact', 'Trimmed', 'Defaced' } )
set ( gca, 'YTickLabel', {} )


% Plots the fiducial error not considering the nose.
axes ( 'Units', 'centimeters', 'Position', [ 8.2  0.6  7.0  4.8 ], 'FontSize', 9 )
% boxplot ( [ err_fids err_rhnn ], 'notch', 'on' )
notBoxPlot ( [ err_fids err_rhnn ] )

% Fixes the boxplot.
patches  = findall ( gca, 'Type', 'Patch' );
set ( patches, 'FaceAlpha', 0.6, 'EdgeAlpha', 0.6 )
lines    = findall ( gca, 'Type', 'Line', 'Marker', 'none' );
set ( lines, 'LineWidth', 0.1 )
markers  = findall ( gca, 'Type', 'Line', 'LineStyle', 'none' );
set ( markers, 'MarkerSize', 4 )
uistack ( markers, 'bottom' )

% Adds the labels.
title ( 'Head points without nose' )
xlim ( [ 0.5 4.5 ] )
ylim ( [ 0 round( max ( max ( err_rh (:) ), max ( err_rhnn (:) ) ) + 5, -1 ) ] )
set ( gca, 'XTickLabel', { 'Fids Only', 'Intact', 'Trimmed', 'Defaced' } )
set ( gca, 'YTickLabel', {} )


% Saves the figure.
print ( '-dpng', '-r300', 'Coregistraton error with RHINO.png' )



% Generates the figure.
figure ( 'Units', 'centimeters', 'Position', [  0.0  0.0 15.2  6.0 ] )

% Plots the Y-axis.
axes ( 'Units', 'centimeters', 'Position', [ 1.2  0.6  0.0  4.8 ], 'FontSize', 9 )
xlim ( [ 0 1 ] )
ylim ( [ 0 round( max ( max ( err_rh (:) ), max ( err_rhnn (:) ) ) + 5, -1 ) ] )
ylabel ( 'Increment in mean fiducial error (mm)' );


% Plots the fiducial error when considering the nose.
axes ( 'Units', 'centimeters', 'Position', [ 1.2  0.6  7.0  4.8 ], 'FontSize', 9 )
% boxplot ( err_rh - err_fids, 'notch', 'on' )
notBoxPlot ( err_rh - err_fids )

% Fixes the boxplot.
patches  = findall ( gca, 'Type', 'Patch' );
set ( patches, 'FaceAlpha', 0.6, 'EdgeAlpha', 0.6 )
lines    = findall ( gca, 'Type', 'Line', 'Marker', 'none' );
set ( lines, 'LineWidth', 0.1 )
markers  = findall ( gca, 'Type', 'Line', 'LineStyle', 'none' );
set ( markers, 'MarkerSize', 4 )
uistack ( markers, 'bottom' )

% Adds the labels.
title ( 'Head points with nose' )
xlim ( [ 0.5 3.5 ] )
ylim ( [ 0 round( max ( max ( err_rh (:) ), max ( err_rhnn (:) ) ) + 5, -1 ) ] )
set ( gca, 'XTickLabel', { 'Fids Only', 'Intact', 'Trimmed', 'Defaced' } )
set ( gca, 'YTickLabel', {} )


% Plots the fiducial error not considering the nose.
axes ( 'Units', 'centimeters', 'Position', [ 8.2  0.6  7.0  4.8 ], 'FontSize', 9 )
% boxplot ( err_rhnn - err_fids, 'notch', 'on' )
notBoxPlot ( err_rhnn - err_fids )

% Fixes the boxplot.
patches  = findall ( gca, 'Type', 'Patch' );
set ( patches, 'FaceAlpha', 0.6, 'EdgeAlpha', 0.6 )
lines    = findall ( gca, 'Type', 'Line', 'Marker', 'none' );
set ( lines, 'LineWidth', 0.1 )
markers  = findall ( gca, 'Type', 'Line', 'LineStyle', 'none' );
set ( markers, 'MarkerSize', 4 )
uistack ( markers, 'bottom' )

% Adds the labels.
title ( 'Head points without nose' )
xlim ( [ 0.5 3.5 ] )
ylim ( [ 0 round( max ( max ( err_rh (:) ), max ( err_rhnn (:) ) ) + 5, -1 ) ] )
set ( gca, 'XTickLabel', { 'Fids Only', 'Intact', 'Trimmed', 'Defaced' } )
set ( gca, 'YTickLabel', {} )


% Saves the figure.
print ( '-dpng', '-r300', 'Coregistraton error with RHINO (increment).png' )



% Generates the figure.
figure ( 'Units', 'centimeters', 'Position', [  0.0  0.0 15.2  6.0 ] )

% Plots the Y-axis.
axes ( 'Units', 'centimeters', 'Position', [ 1.2  0.6  0.0  4.8 ], 'FontSize', 9 )
xlim ( [ 0 1 ] )
ylim ( [ 0 round( max ( max ( err_spm (:) ), max ( err_spmnn (:) ) ) + 5, -1 ) ] )
ylabel ( 'Mean fiducial error (mm)' );


% Plots the fiducial error when considering the nose.
axes ( 'Units', 'centimeters', 'Position', [ 1.2  0.6  7.0  4.8 ], 'FontSize', 9 )
% boxplot ( [ err_fids err_spm ], 'notch', 'on' )
notBoxPlot ( [ err_fids err_spm ] )

% Fixes the boxplot.
patches  = findall ( gca, 'Type', 'Patch' );
set ( patches, 'FaceAlpha', 0.6, 'EdgeAlpha', 0.6 )
lines    = findall ( gca, 'Type', 'Line', 'Marker', 'none' );
set ( lines, 'LineWidth', 0.1 )
markers  = findall ( gca, 'Type', 'Line', 'LineStyle', 'none' );
set ( markers, 'MarkerSize', 4 )
uistack ( markers, 'bottom' )

% Adds the labels.
title ( 'Head points with nose' )
xlim ( [ 0.5 4.5 ] )
ylim ( [ 0 round( max ( max ( err_spm (:) ), max ( err_spmnn (:) ) ) + 5, -1 ) ] )
set ( gca, 'XTickLabel', { 'Fids Only', 'Intact', 'Trimmed', 'Defaced' } )
set ( gca, 'YTickLabel', {} )


% Plots the fiducial error not considering the nose.
axes ( 'Units', 'centimeters', 'Position', [ 8.2  0.6  7.0  4.8 ], 'FontSize', 9 )
% boxplot ( [ err_fids err_spmnn ], 'notch', 'on' )
notBoxPlot ( [ err_fids err_spmnn ] )

% Fixes the boxplot.
patches  = findall ( gca, 'Type', 'Patch' );
set ( patches, 'FaceAlpha', 0.6, 'EdgeAlpha', 0.6 )
lines    = findall ( gca, 'Type', 'Line', 'Marker', 'none' );
set ( lines, 'LineWidth', 0.1 )
markers  = findall ( gca, 'Type', 'Line', 'LineStyle', 'none' );
set ( markers, 'MarkerSize', 4 )
uistack ( markers, 'bottom' )

% Adds the labels.
title ( 'Head points without nose' )
xlim ( [ 0.5 4.5 ] )
ylim ( [ 0 round( max ( max ( err_spm (:) ), max ( err_spmnn (:) ) ) + 5, -1 ) ] )
set ( gca, 'XTickLabel', { 'Fids Only', 'Intact', 'Trimmed', 'Defaced' } )
set ( gca, 'YTickLabel', {} )


% Saves the figure.
print ( '-dpng', '-r300', 'Coregistraton error with SPM.png' )



% Generates the figure.
figure ( 'Units', 'centimeters', 'Position', [  0.0  0.0 15.2  6.0 ] )

% Plots the Y-axis.
axes ( 'Units', 'centimeters', 'Position', [ 1.2  0.6  0.0  4.8 ], 'FontSize', 9 )
xlim ( [ 0 1 ] )
ylim ( [ 0 round( max ( max ( err_spm (:) ), max ( err_spmnn (:) ) ) + 5, -1 ) ] )
ylabel ( 'Increment in mean fiducial error (mm)' );


% Plots the fiducial error when considering the nose.
axes ( 'Units', 'centimeters', 'Position', [ 1.2  0.6  7.0  4.8 ], 'FontSize', 9 )
% boxplot ( err_spm - err_fids, 'notch', 'on' )
notBoxPlot ( err_spm - err_fids )

% Fixes the boxplot.
patches  = findall ( gca, 'Type', 'Patch' );
set ( patches, 'FaceAlpha', 0.6, 'EdgeAlpha', 0.6 )
lines    = findall ( gca, 'Type', 'Line', 'Marker', 'none' );
set ( lines, 'LineWidth', 0.1 )
markers  = findall ( gca, 'Type', 'Line', 'LineStyle', 'none' );
set ( markers, 'MarkerSize', 4 )
uistack ( markers, 'bottom' )

% Adds the labels.
title ( 'Head points with nose' )
xlim ( [ 0.5 3.5 ] )
ylim ( [ 0 round( max ( max ( err_spm (:) ), max ( err_spmnn (:) ) ) + 5, -1 ) ] )
set ( gca, 'XTickLabel', { 'Fids Only', 'Intact', 'Trimmed', 'Defaced' } )
set ( gca, 'YTickLabel', {} )


% Plots the fiducial error not considering the nose.
axes ( 'Units', 'centimeters', 'Position', [ 8.2  0.6  7.0  4.8 ], 'FontSize', 9 )
% boxplot ( err_spmnn - err_fids, 'notch', 'on' )
notBoxPlot ( err_spmnn - err_fids )

% Fixes the boxplot.
patches  = findall ( gca, 'Type', 'Patch' );
set ( patches, 'FaceAlpha', 0.6, 'EdgeAlpha', 0.6 )
lines    = findall ( gca, 'Type', 'Line', 'Marker', 'none' );
set ( lines, 'LineWidth', 0.1 )
markers  = findall ( gca, 'Type', 'Line', 'LineStyle', 'none' );
set ( markers, 'MarkerSize', 4 )
uistack ( markers, 'bottom' )

% Adds the labels.
title ( 'Head points without nose' )
xlim ( [ 0.5 3.5 ] )
ylim ( [ 0 round( max ( max ( err_spm (:) ), max ( err_spmnn (:) ) ) + 5, -1 ) ] )
set ( gca, 'XTickLabel', { 'Fids Only', 'Intact', 'Trimmed', 'Defaced' } )
set ( gca, 'YTickLabel', {} )


% Saves the figure.
print ( '-dpng', '-r300', 'Coregistraton error with SPM (increment).png' )
