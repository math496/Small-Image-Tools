function imgOut = add_tint(imgIn, RED, GREEN, BLUE)
% tints an image by adding RED, GREEN, AND BLUE directly to the pixel,
% values of an image. imgIn can be an RGB or GRAYSCALE

%% INPUT CHECKING

assert(nargin == 4, ...
    'tint_img should have four inputs: imgIn, RED, GREEN, BLUE');

% check if RGB
if size(imgIn, 3) == 1
    warning('input is not an RGB image. treating input as greyscale')
    imgIn = repmat(imgIn, 1, 1, 3);
else
    assert(size(imgIn, 3) == 3, 'imgIn should be RGB or grayscale image')
end

% check color depth:
try assert(isa(imgIn, 'uint8'))
catch
    warning('input should be a uint8, but is a %s. unintended behavior?', ...
        class(imgIn))
end

% check 0<=[RED, GREEN, BLUE]<=255
try
    SHIFT = [RED GREEN BLUE];
    assert(not(any ( ( mod(SHIFT, 1) > 0) ) ) );
    assert(isnumeric(SHIFT) );
    assert( not (any (SHIFT>255) ) );
    assert( not (any (SHIFT<0) ) );
catch
    error('RED, GREEN, and BLUE should be integers between 0 and 255');
end


%% ACTUAL DEAD-SIMPLE PROCESS
imgOut = imgIn;
imgOut(:, :, 1) = imgOut(:, :, 1) + RED;
imgOut(:, :, 2) = imgOut(:, :, 2) + BLUE;
imgOut(:, :, 3) = imgOut(:, :, 3) + GREEN;
end