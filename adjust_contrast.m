function imgOut = adjust_contrast(imgIn, CONTRAST, varargin)

% adjusts the contrast of an image. a contrast value greater than 1 makes
% the dark parts of the image darker and the bright parts brighter.
%input: imgIn, CONTRAST, LUMINANCE(optional), BIAS(optional)

% imgIn: input image: RGB or grayscale w/ pixel values 0-255

% CONTRAST: the ratio by which to adjust the contrast; 1 is unchanged. 
% 0 < CONTRAST < 1 reduces the contrast, CONTRAST > 1 increases the
% contrast.

% LUMINANCE: this adds 'white' to the image before adjusting the contrast.

% BIAS: this sets the 'zero' for the image to use while adjusting the
% contrast. if CONTRAST > 1, a channel with pixel value p < (128-BIAS) will
% be pushed closer to zero; a p > (128-bias) will be pushed closer to 255.
% if contrast < 1, the opposite.

% written by Efron Licht in 2016. You can use, copy, or edit this code for
% any reason whatsoever. Go nuts.

%% INPUT CHECK
function image_input_check(parameter, parameter_name)
    
    try    
        assert(isscalar(parameter))
        assert(isnumeric(parameter))
        assert(parameter < 256)
    catch
        error('input parameter %s should be a numeric scalar', ...
            parameter_name);
    end
end
assert(nargin <= 4, 'at most four input arguments');

image_input_check(CONTRAST, 'CONTRAST')

LUMINANCE = 0; BIAS = 0;

if nargin >= 3 % LUMINANCE
    
    LUMINANCE = varargin{1};
    image_input_check(LUMINANCE, 'LUMINANCE');
    
    if nargin == 4; %BIAS
        BIAS = varargin{2};
        image_input_check(BIAS, 'BIAS')
    end
    
end

%% ADJUST CONTRAST

imgOut = double(imgIn+LUMINANCE);

imgOut = imgOut - (128 - BIAS);
imgOut = imgOut.*CONTRAST;
imgOut = 2.^imgOut;
imgOut = imgOut + (128 - BIAS);
imgOut = uint8(imgOut);

end