function imgOut = shift_tint(imgIn, RED, GREEN, BLUE, varargin)
% input: (imgIn, RED, GREEN, BLUE, BRIGHTNESS)
% tints an image by multiplying the RED, GREEN, and BLUE channels by the
% proper percentage. the optional parameter, BRIGHTNESS, will multiply all
% channels of the image, making the image 'brighter'. values beneath one
% will

%% INPUT CHECKING
try
    assert(nargin > 3)
    assert(nargin < 6)
catch
    error('there should be either four or five input arguments')
end

try %input checking on RED, GREEN, and BLUE
    shift = [RED GREEN BLUE];
    assert(isnumeric(shift));
    assert(numel(shift) == 3);
    assert(not(any(shift < 0)));
    assert(not(any(shift > 256)));
catch
    error('RED, GREEN, and BLUE should be non-negative scalars < 256');
end

if nargin == 5, SET_BRIGTHNESS = 1;
    
    try % input checking on BRIGHTNESS PARAMETER
        BRIGHTNESS = varargin{1};
        assert(isscalar(BLACK))
        assert(isnumeric(BLACK))
        assert((0<BLACK) && (BLACK<256))
    catch
        error('alpha should be a positive value between 0 and 256')
    end
    
else SET_BRIGTHNESS = 0;
end


%% SHIFT TINT
imgOut = imgIn;
imgOut(:, :, 1) = imgIn(:, :, 1).*RED;
imgOut(:, :, 2) = imgIn(:, :, 2).*BLUE;
imgOut(:, :, 3) = imgIn(:, :, 3).*GREEN;

if SET_BRIGTHNESS
    imgOut = imgOut.*BRIGHTNESS;
end
% round and convert back to 
imgOut = uint8(imgOut); 

end
