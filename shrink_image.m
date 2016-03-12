function imgOut = shrink_image(imgIn, varargin)
% resample an image to be an integer proportion smaller. by default,
% shrinks the image by a proportion of 2 (example: 
% shrink_image(testImg): 1080x1920 --> 540x960).
% varargin is an optional parameter that is a (higher) integer; eg,
% shrink_image(testImg, 5): 1080x1920 --> 216x384

% written by Efron Licht in 2016. You can use, copy, or edit this code for
% any reason whatsoever. Go nuts.

%% INPUT HANDLING %%
imgIn = import_image(imgIn);
if nargin >= 2
    if nargin > 2
        warning('shrink_image should have at most 2 inputs: you have %g', ...
            nargin);
        warning('ignoring further arguments')
    end
    try scaling_factor = varargin{1};
        assert(isnumeric(scaling_factor));
        assert(isscalar(scaling_factor));
        assert(varargin{1}>1)
        if (scaling_factor-floor(scaling_factor)) ~= 0
            warning('scaling factor %g is not an integer, treating as %g\n', ...
                scaling_factor, floor(scaling_factor));
        end
        scaling_factor = floor(scaling_factor);
    catch ME
    error(['second argument must be a postiive integer, \n']);
    end
else
    scaling_factor = 2;
end

%% Trim off Bottom-Right pixels if necessary
[rows, cols, ~] = (size(imgIn));
if any(mod([rows, cols], scaling_factor))
    warning('size of image not divided evenly by %g; trimming to fit', ...
        scaling_factor);
    rows = rows - mod(rows, scaling_factor);
    cols = cols - mod(cols, scaling_factor);
end 

%% Resampling
y = (1:scaling_factor:rows);
x = (1:scaling_factor:cols);

imgOut = imgIn(y, :, :);
imgOut = imgOut(:, x, :)
end;