
function imgOut = flatten_color(imgIn, channel_depth)
% Flattens the color depth of an image to the channel_depth specified by
% rounding each channel to the nearest neighbor.
%channel_depth is the number of shades of Green, or Blue allowed in the image
% a standard image has a channel depth of 256. 
%% CHECK INPUT
assert(nargin == 2, ...
    'flatten_color should have two inputs: imgIn, channel_depth');
ACCEPTABLE_INPUTS = [1 2 4 6 8 16 32 64 128];

try
    assert(isnumeric(channel_depth));
    assert(isscalar(channel_depth));
    assert(any(channel_depth == ACCEPTABLE_INPUTS));
catch ME
    error('second argument "bit depth" should be a single integer less than 256');
end

scaling_factor = 256/channel_depth;
imgOut = imgIn./scaling_factor;
imgOut = round(imgOut);
imgOut = imgOut.*scaling_factor;

end