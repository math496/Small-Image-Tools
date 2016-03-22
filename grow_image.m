function imgOut = grow_image(imgIn, varargin)
% resample an image to be an integer proportion larger. by default,
% grows the image by a proportion of 2 (example: 
% grow_image(testImg): 1080x1920 --> 2060x3840.
% varargin is an optional parameter that is a (higher) integer; eg,
% grow_image(testImg, 5): 1080x1920 --> 5400x9600
% this does not do any kind of nearest_neighbor smoothing or anything, it's
% very bare-bones.

% written by Efron Licht in 2016. You can use, copy, or edit this code for
% any reason whatsoever. Go nuts.

imgIn = import_image(imgIn);
if nargin >= 2
    
    if nargin > 2
        warning('grow_image should have at most 2 inputs: you have %g', ...
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
        error('second argument must be a postiive integer');
    end
    
else
    
    scaling_factor = 2;

end

[rows, cols, RGB_OR_GRAY] = size(imgIn);

rows = rows*scaling_factor;
cols = cols*scaling_factor;

imgOut = zeros(rows, cols, RGB_OR_GRAY, 'uint8'); %preallocate for speed
y_out = (1:scaling_factor:rows)-1;
x_out = (1:scaling_factor:cols)-1;
%RESAMPLE
for k=1:scaling_factor
    y_out = y_out+1;

    for j=1:scaling_factor
    
        x_out = x_out+1;
        imgOut(y_out, x_out, :) = imgIn;
        x_out = (1:scaling_factor:cols)-1;
    end    
end

end