clc
clear
close all


% Adds SPM12 to the path.
addpath ( sprintf ( '%s/osl/spm12', fileparts ( pwd ) ) );
spm defaults eeg

% Adds NotBoxPlots to the path.
addpath ( sprintf ( '%s/toolboxes/notboxplots', fileparts ( pwd ) ) );


% Loads the previously saved parameters and errors.
load ( 'iSkullErr.mat' )

% Calculates the median per-vertex error (distance).
mdist   = median ( errs, 3 );
mcodist = median ( coerrs, 3 );

% Calculates the mean per-subject error.
merr   = squeeze ( mean ( errs, 1 ) )';
mcoerr = squeeze ( mean ( coerrs, 1 ) )';


% Gets the MNI inner skull mesh.
meshes  = spm_eeg_inv_mesh;
mesh    = gifti ( meshes.tess_iskull );



% Plots the error for the Trimmed version.

% Creates the figure.
figure ( 'Units', 'centimeters', 'Position', [  0.0  0.0 20.0 12.0 ] );

% Draws the left lateral view.
axes ( 'Units', 'centimeters', 'Position', [  0.0  6.0  6.0  6.0 ] );
patch ( 'Faces', mesh.faces, 'Vertices', mesh.vertices, 'EdgeColor', 'none', 'FaceVertexCData', mdist ( :, 1 ), 'FaceColor', 'interp' )
% set ( gca, 'CLim', [ 0 max( mdist ( :, 1 ) ) ] )
view ( -90, 0 )
axis equal vis3d off

% Draws the frontal view.
axes ( 'Units', 'centimeters', 'Position', [  6.0  6.0  6.0  6.0 ] );
patch ( 'Faces', mesh.faces, 'Vertices', mesh.vertices, 'EdgeColor', 'none', 'FaceVertexCData', mdist ( :, 1 ), 'FaceColor', 'interp' )
% set ( gca, 'CLim', [ 0 max( mdist ( :, 1 ) ) ] )
view ( 180, 0 )
axis equal vis3d off

% Draws the right lateral view.
axes ( 'Units', 'centimeters', 'Position', [ 12.0  6.0  6.0  6.0 ] );
patch ( 'Faces', mesh.faces, 'Vertices', mesh.vertices, 'EdgeColor', 'none', 'FaceVertexCData', mdist ( :, 1 ), 'FaceColor', 'interp' )
% set ( gca, 'CLim', [ 0 max( mdist ( :, 1 ) ) ] )
view ( 90, 0 )
axis equal vis3d off

% Draws the inferior view.
axes ( 'Units', 'centimeters', 'Position', [  0.0  0.0  6.0  6.0 ] );
patch ( 'Faces', mesh.faces, 'Vertices', mesh.vertices, 'EdgeColor', 'none', 'FaceVertexCData', mdist ( :, 1 ), 'FaceColor', 'interp' )
% set ( gca, 'CLim', [ 0 max( mdist ( :, 1 ) ) ] )
view ( -90, -90 )
axis equal vis3d off

% Draws the posterior view.
axes ( 'Units', 'centimeters', 'Position', [  6.0  0.0  6.0  6.0 ] );
patch ( 'Faces', mesh.faces, 'Vertices', mesh.vertices, 'EdgeColor', 'none', 'FaceVertexCData', mdist ( :, 1 ), 'FaceColor', 'interp' )
% set ( gca, 'CLim', [ 0 max( mdist ( :, 1 ) ) ] )
view ( 0, 0 )
axis equal vis3d off

% Draws the superior view.
axes ( 'Units', 'centimeters', 'Position', [ 12.0  0.0  6.0  6.0 ] );
patch ( 'Faces', mesh.faces, 'Vertices', mesh.vertices, 'EdgeColor', 'none', 'FaceVertexCData', mdist ( :, 1 ), 'FaceColor', 'interp' )
% set ( gca, 'CLim', [ 0 max( mdist ( :, 1 ) ) ] )
view ( 90, 90 )
axis equal vis3d off

% Lights the scene.
lighting gouraud
material dull

% Draws the colorbar.
colorbar ( 'Units', 'centimeters', 'Position', [ 18.8  0.2  0.5 11.6 ] );
cbar = findall ( gcf, 'Type', 'colorbar' );
set ( cbar, 'YTick',  0.1:  0.1: 10.0 )
set ( cbar, 'Box',  'off' )

% Sets the color limits.
axs  = findall ( gcf, 'Type', 'axes' );
set ( axs, 'CLim', [ 0 max( mdist ( :, 1 ) ) ] )

% Saves the figure.
print ( '-dpng', '-r300', 'Inner skull error (surface, trimmed).png' )


% Sets the color limits.
axs  = findall ( gcf, 'Type', 'axes' );
set ( axs, 'CLim', [ 0 max( mdist (:) ) ] )

% Saves the figure.
print ( '-dpng', '-r300', 'Inner skull error (surface, trimmed, common scale).png' )



% Plots the error for the Defaced version.

% Creates the figure.
figure ( 'Units', 'centimeters', 'Position', [  0.0  0.0 20.0 12.0 ] );

% Draws the left lateral view.
axes ( 'Units', 'centimeters', 'Position', [  0.0  6.0  6.0  6.0 ] );
patch ( 'Faces', mesh.faces, 'Vertices', mesh.vertices, 'EdgeColor', 'none', 'FaceVertexCData', mdist ( :, 2 ), 'FaceColor', 'interp' )
% set ( gca, 'CLim', [ 0 max( mdist ( :, 1 ) ) ] )
view ( -90, 0 )
axis equal vis3d off

% Draws the frontal view.
axes ( 'Units', 'centimeters', 'Position', [  6.0  6.0  6.0  6.0 ] );
patch ( 'Faces', mesh.faces, 'Vertices', mesh.vertices, 'EdgeColor', 'none', 'FaceVertexCData', mdist ( :, 2 ), 'FaceColor', 'interp' )
% set ( gca, 'CLim', [ 0 max( mdist ( :, 1 ) ) ] )
view ( 180, 0 )
axis equal vis3d off

% Draws the right lateral view.
axes ( 'Units', 'centimeters', 'Position', [ 12.0  6.0  6.0  6.0 ] );
patch ( 'Faces', mesh.faces, 'Vertices', mesh.vertices, 'EdgeColor', 'none', 'FaceVertexCData', mdist ( :, 2 ), 'FaceColor', 'interp' )
% set ( gca, 'CLim', [ 0 max( mdist ( :, 1 ) ) ] )
view ( 90, 0 )
axis equal vis3d off

% Draws the inferior view.
axes ( 'Units', 'centimeters', 'Position', [  0.0  0.0  6.0  6.0 ] );
patch ( 'Faces', mesh.faces, 'Vertices', mesh.vertices, 'EdgeColor', 'none', 'FaceVertexCData', mdist ( :, 2 ), 'FaceColor', 'interp' )
% set ( gca, 'CLim', [ 0 max( mdist ( :, 1 ) ) ] )
view ( -90, -90 )
axis equal vis3d off

% Draws the posterior view.
axes ( 'Units', 'centimeters', 'Position', [  6.0  0.0  6.0  6.0 ] );
patch ( 'Faces', mesh.faces, 'Vertices', mesh.vertices, 'EdgeColor', 'none', 'FaceVertexCData', mdist ( :, 2 ), 'FaceColor', 'interp' )
% set ( gca, 'CLim', [ 0 max( mdist ( :, 1 ) ) ] )
view ( 0, 0 )
axis equal vis3d off

% Draws the superior view.
axes ( 'Units', 'centimeters', 'Position', [ 12.0  0.0  6.0  6.0 ] );
patch ( 'Faces', mesh.faces, 'Vertices', mesh.vertices, 'EdgeColor', 'none', 'FaceVertexCData', mdist ( :, 2 ), 'FaceColor', 'interp' )
% set ( gca, 'CLim', [ 0 max( mdist ( :, 1 ) ) ] )
view ( 90, 90 )
axis equal vis3d off

% Lights the scene.
lighting gouraud
material dull

% Draws the colorbar.
colorbar ( 'Units', 'centimeters', 'Position', [ 18.8  0.2  0.5 11.6 ] );
cbar = findall ( gcf, 'Type', 'colorbar' );
set ( cbar, 'YTick',  0.1:  0.1: 10.0 )
set ( cbar, 'Box',  'off' )

% Sets the color limits.
axs  = findall ( gcf, 'Type', 'axes' );
set ( axs, 'CLim', [ 0 max( mdist ( :, 2 ) ) ] )

% Saves the figure.
print ( '-dpng', '-r300', 'Inner skull error (surface, defaced).png' )


% Sets the color limits.
axs  = findall ( gcf, 'Type', 'axes' );
set ( axs, 'CLim', [ 0 max( mdist (:) ) ] )

% Saves the figure.
print ( '-dpng', '-r300', 'Inner skull error (surface, defaced, common scale).png' )



% Plots the boxplots.

% Generates the figure.
figure ( 'Units', 'centimeters', 'Position', [  0.0  0.0 15.0  6.0 ] )

% Plots the Y-axis.
axes ( 'Units', 'centimeters', 'Position', [ 1.0  0.6  0.0  4.8 ], 'FontSize', 9 )
xlim ( [ 0 1 ] )
ylim ( [ 0 ceil( max ( max ( merr (:) ), max ( mcoerr (:) ) ) ) ] )
ylabel ( 'Mean inner skull difference (mm)' );


% Plots the error for the original meshes.
axes ( 'Units', 'centimeters', 'Position', [ 1.0  0.6  7.0  4.8 ], 'FontSize', 9 )
% boxplot ( merr )
notBoxPlot ( merr )

% Fixes the boxplot.
patches  = findall ( gca, 'Type', 'Patch' );
set ( patches, 'FaceAlpha', 0.6, 'EdgeAlpha', 0.6 )
lines    = findall ( gca, 'Type', 'Line', 'Marker', 'none' );
set ( lines, 'LineWidth', 0.1 )
markers  = findall ( gca, 'Type', 'Line', 'LineStyle', 'none' );
set ( markers, 'MarkerSize', 4 )
uistack ( markers, 'bottom' )

% Adds the labels.
title ( 'Before coregistration')
xlim ( [ 0.5 2.5 ] )
ylim ( [ 0 ceil( max ( max ( merr (:) ), max ( mcoerr (:) ) ) ) ] )
set ( gca, 'XTickLabel', { 'Trimmed vs. Intact', 'Defaced vs. Intact' } )
set ( gca, 'YTickLabel', {} )


% Plots the error for the coregistered meshes.
axes ( 'Units', 'centimeters', 'Position', [  8.0  0.6  7.0  4.8 ], 'FontSize', 9 )
% boxplot ( mcoerr )
notBoxPlot ( mcoerr )

% Fixes the boxplot.
patches  = findall ( gca, 'Type', 'Patch' );
set ( patches, 'FaceAlpha', 0.6, 'EdgeAlpha', 0.6 )
lines    = findall ( gca, 'Type', 'Line', 'Marker', 'none' );
set ( lines, 'LineWidth', 0.1 )
markers  = findall ( gca, 'Type', 'Line', 'LineStyle', 'none' );
set ( markers, 'MarkerSize', 4 )
uistack ( markers, 'bottom' )

% Adds the labels.
title ( 'After coregistration')
xlim ( [ 0.5 2.5 ] )
ylim ( [ 0 ceil( max ( max ( merr (:) ), max ( mcoerr (:) ) ) ) ] )
set ( gca, 'XTickLabel', { 'Trimmed vs. Intact', 'Defaced vs. Intact' } )
set ( gca, 'YTickLabel', {} )

% Saves the figure.
print ( '-dpng', '-r300', 'Inner skull error (boxplots).png' )
