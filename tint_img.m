function imgOut = tint_img(imgIn, RED, GREEN, BLUE)

if size(imgIn, 3) == 1
    warning('input is not an RGB image. treating as greyscale')
    imgIn = repmat(imgIn, 1, 1, 3);
else
    assert(size(imgIn, 3) == 3, 'imgIn should be RGB or grayscale image')
end
assert(nargin == 4, ...
    'tint_img should have four inputs: imgIn, RED, GREEN, BLUE');

try
    SHIFT = [RED GREEN BLUE];
    assert(not(any ( ( mod(SHIFT, 1) > 0) ) ) );
    assert(isnumeric(SHIFT) );
    assert( not (any (SHIFT>255) ) );
    assert( not (any (SHIFT<0) ) );
catch
    error('RED, GREEN, and BLUE should be integers between 0 and 255');
end

imgOut = imgIn;
imgOut(:, :, 1) = imgOut(:, :, 1) + RED;
imgOut(:, :, 2) = imgOut(:, :, 2) + BLUE;
imgOut(:, :, 3) = imgOut(:, :, 3) + GREEN;
end