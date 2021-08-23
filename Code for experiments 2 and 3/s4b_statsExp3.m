clc
clear
close all


% Loads the previously saved parameters and errors.
load ( 'iSkullErr.mat' )

% Calculates the mean per-subject error.
merr   = squeeze ( mean ( errs, 1 ) )';
mcoerr = squeeze ( mean ( coerrs, 1 ) )';


% Defines the pairs of images.
pairs = nchoosek ( 2: numel ( anas ), 2 );


% Results with no coregistration.
fprintf ( 1, 'Comparison of inner skull meshes.\n' )

% Goes through each anatomy.
for ana = 2: size ( anas, 1 )
    
    % Prints the median value.
    fprintf ( 1, '  Median value for anatomy %s: %.2f mm.\n', anas { ana }, median ( merr ( :, ana - 1 ) ) )
end

% Goes through each pair.
for pair = 1: size ( pairs, 1 )
    
    % Compares the two images.
    p = signrank ( merr ( :, pairs ( pair, 1 ) - 1 ), merr ( :, pairs ( pair, 2 ) - 1 ) );
    
    % Prints the result.
    fprintf ( 1, '  Comparison between %s and %s. p = %.4f.\n', anas { pairs ( pair, : ) }, p )
end

fprintf ( '\n' )




% Results with coregistration.
fprintf ( 1, 'Comparison of inner skull meshes after coregistration.\n' )

% Goes through each anatomy.
for ana = 2: size ( anas, 1 )
    
    % Prints the median value.
    fprintf ( 1, '  Median value for anatomy %s: %.2f mm.\n', anas { ana }, median ( mcoerr ( :, ana - 1 ) ) )
end

% Goes through each pair.
for pair = 1: size ( pairs, 1 )
    
    % Compares the two images.
    p = signrank ( mcoerr ( :, pairs ( pair, 1 ) - 1 ), mcoerr ( :, pairs ( pair, 2 ) - 1 ) );
    
    % Prints the result.
    fprintf ( 1, '  Comparison between %s and %s. p = %.4f.\n', anas { pairs ( pair, : ) }, p )
end

fprintf ( '\n' )
