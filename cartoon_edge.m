function imgOut = cartoon_edge(imgIn, varargin)
% marks the edges of an image with black lines, like a cartoon drawing.
% cartoon_edge(imgIn, numSteps(optional) ).
% numSteps is the number of times to 'spread out' the mask; higher numbers
% will make the edges thicker

% written by Efron Licht in 2016. This is free to use for any non-gross
% purpose. If you have to ask...

% % INPUT HANDLING
assert(nargin <= 2, 'at most two input arguments');
if nargin == 2
    try numSteps = varargin{1};
        assert(isscalar(numSteps))
        assert(isnumeric(numSteps))
        assert(mod(numSteps, 1) == 0)
        assert(numSteps > 0);
    catch
        error('numSteps should be a positive integer');
    end
else numSteps = 3;
end

mask = edge(rgb2gray(imgIn));

[rows, cols] = size(mask);

%% 'spread' edges of mask by calculating nearest-neighbor averages:

for step=1:(numSteps-1)
UL = padarray(mask(1:(rows-1), 1:(cols-1)), [1, 1], 'pre');

UC = padarray(mask(1:(rows-1), 1:cols), [1, 0], 'pre');

UR = padarray(mask(1:(rows-1), 2:cols), [1, 0], 'pre');
UR = padarray(UR, [0, 1], 'post');

ML = padarray(mask(1:(rows), 1:(cols-1)), [0, 1], 'pre');

MM = zeros(rows, cols);

MR = padarray(mask(1:(rows), 2:cols), [0, 1], 'post');
 
LL = padarray(mask(2:rows, 1:(cols-1)), [1, 0], 'post');
LL = padarray(LL, [0, 1], 'pre');

LC = padarray(mask(2:rows, 1:cols), [1, 0], 'post');

LR = padarray(mask(2:rows, 2:cols), [1, 1], 'post');

nearest_neighbor = ...
    UL.^2 + UC.^2 + UR.^2 + ...
    ML.^2 + MM.^2 + MR.^2 + ...
    LL.^2 + LC.^2 + LR.^2;

nearest_neighbor = sqrt(nearest_neighbor ./8);

mask = min((mask + nearest_neighbor), 1);

end

%% 
mask = repmat(mask, 1, 1, 3);

imgOut = uint8(double(imgIn) .* not(mask));

mask = uint8(mask*255);
imgOut = imgOut - mask;

end
