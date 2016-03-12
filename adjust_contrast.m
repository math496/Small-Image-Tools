function imgOut = adjust_contrast(imgIn, CONTRAST, varargin)

% adjusts the contrast of an image. a contrast value greater than 1 makes
% the dark parts of the image darker and the bright parts brighter. and
% optinal parameter, LUMINANCE, adds a value between 0 and 255 to all color
% channels of the image BEFORE adjusting the contrast

% written by Efron Licht in 2016. You can use, copy, or edit this code for
% any reason whatsoever. Go nuts.

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


image_input_check(CONTRAST, 'CONTRAST')
if nargin == 3;
    LUMINANCE = varargin{1};
    image_input_check(LUMINANCE, 'LUMINANCE');
    SET_LUMINANCE = 1;
else SET_LUMINANCE = 0;
end

if SET_LUMINANCE
    imgOut = double(imgIn + LUMINANCE);
else
    imgOut = double(imgIn);
end

imgOut = imgOut - 128; 
imgOut = imgOut.*CONTRAST;
imgOut = imgOut + 128;
imgOut = uint8(imgOut);
end