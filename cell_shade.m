function imgOut = cell_shade(imgIn, varargin)
% "cell-shades" an image, emulating a comic-book or cartoon feel by drawing
% thick black edges around objects and flattening the color depth. 
% INPUT: cell_shade(imgIn, 'edgeSize', N, 'colorDepth', M)

% written by Efron Licht in 2016. Feel free to use this for any
% non-gross purpose. If you have to ask...

% imgIn: a uint8, RGB image, or %FILENAME leading to same
% N and M should be positive integers.
% 'edgeSize' specifies the thickness of the edges around objects. '3' is
% the default. '1 or 2' produce thinner edges, '4' or higher produce thicker
% edges.

% 'colorDepth' is the DEPTH of COLOR. Acceptable inputs are
% 1, 2, 4, 8, 16, 32, 64, 128, or 256, where 256 means NO flattening.
%% INPUT CHECKING
if nargin > 1
    
   CUSTOM_EDGE = 0;
   CUSTOM_DEPTH = 0;
    for n=1:length(varargin)
    
        if strcmp(varargin{n}, 'edgeSize')
            
            CUSTOM_EDGE = 1;
            edgeSize = varargin{n+1};
        
        elseif strcmp(varargin{n}, 'colorDepth')
        
            CUSTOM_DEPTH = 1;
            colorDepth = varargin{n+1};
        
        end
    end

assert((any([CUSTOM_EDGE, CUSTOM_DEPTH])), ...
        'invalid input: edgeSize or colorDepth not specified')
end

imgIn = import_image(imgIn);

if CUSTOM_EDGE, 
    imgOut = cartoon_edge(imgIn, edgeSize);
else
    imgOut = cartoon_edge(imgIn);
end


if CUSTOM_DEPTH
    imgOut = flatten_color(imgOut, colorDepth);
elseif colorDepth == 256;
    % NO FLATTENING
else    
    imgOut = flatten_color(imgOut, 64);
end

end