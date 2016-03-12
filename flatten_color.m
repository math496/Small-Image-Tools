
function imgOut = flatten_color(imgIn, varargin)
% Flattens the color depth of an image to the channel_depth specified by
% rounding each channel to the nearest neighbor.

% input: flatten_color(imgIn, channel_depth(optional)
% channel_depth is the number of shades of Green, or Blue allowed in the image
% a standard image has a channel depth of 256. the default channel_depth is
% 128.

% written by Efron Licht in 2016. This is free to use for any non-gross
% purpose. If you have to ask...


%% CHECK INPUT

if nargin == 2;
    try channel_depth = varargin{1}
        assert(isnumeric(channel_depth));
        assert(isscalar(channel_depth));
        assert(channel_depth < 256);
        assert(channel_depth > 0);
    catch ME
        error(['second argument "channel_depth"' ...
            'should be a positive integer less than 256']);
    end
    
elseif nargin > 2
    
    error('at most one optional input, "channel_depth"')

else
    
    channel_depth = 128;

end

scaling_factor = 256/channel_depth;

imgOut = imgIn./scaling_factor;
imgOut = round(imgOut);
imgOut = imgOut.*scaling_factor;

end