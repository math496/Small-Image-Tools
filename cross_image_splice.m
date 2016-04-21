function cross_image_splice(source_filename, copy_to_filename, ...
    output_filename, varargin)
% splice a random square block from a SOURCE 'from' FILE to a VICTIM
% 'to' file. 

% by Efron Licht. no rights reserved. go nuts.

% ARGUMENTS
% source_filename: filename of SOURCE file (eg, foreground.png);
% copy_to_filename: filename of VICTIM file (eg, background.png);
% outout_filename: filename of OUTPUT (eg,
% splice_foreground_background.png);

% IMAGE SIZES ARE ASSUMED: 128, 256, and 512
% ONLY COLOR IMAGES

% variable argument pairs
% 'trim', trim_size: 
%   trim both images to trim_size x trim_size (non-negative integer)

% 'compression', compression_quality:
%  as intermediate step, resave as .jpg at quality compresion_quality
% before splicing

% 'splice_size', splice_size
% splice a block of exactly size splice_size
%% INPUT HANDLING

COMPRESS_SOURCE_OF_SPLICE = 0;
USE_CUSTOM_SPLICE_SIZE = 0;
TRIM_TO_SIZE = 0;

if nargin > 3
    for n=1:length(varargin)
        
        if(strcmp(varargin{n}, 'compression')
            COMPRESS_SOURCE_OF_SPLICE = 1;
            compression_quality = varargin{n+1};
            
        elseif(strcmp(varargin{n}, 'splice_size'))
            USE_CUSTOM_SPLICE_SIZE = 1;
            custom_splice_size = varargin{n+1};
            
        elseif(strcmp(varargin{n}, 'trim'));
            TRIM_TO_SIZE = 1;
            trim_size = varargin{n+1};
        end
    end
end
            

imgFrom = imread(source_filename);
imgTo = imread(copy_to_filename);

[rowFrom, colFrom, ~] = size(imgFrom);
[rowTo, colTo, ~] = size(imgTo);

row = min(rowFrom, rowTo);
col = min(colFrom, colTo);

if TRIM_TO_SIZE
    try assert(row >= trim_size && col >= trim_size);
    catch
        error('image is smaller than trim_size')
    end
    
    imgFrom = imgFrom(1:trim_size, 1:trim_size, :);
    imgTo = imgTo(1:trim_size, 1:trim_size, :);
end

if COMPRESS_SOURCE_OF_SPLICE     % save as compressed JPG and re-read;
    L = length(source_filename);
    source_filename_stripped = source_filename(1:L-4);
    compression_str = sprintf('_compressed_%02g.jpg', compression_level);
    compressed_filename = strcat(source_filename_stripped, ...
        compression_str);
    imwrite(imgFrom, compressed_filename, ...
        'jpg', 'Quality', compression_quality)
    imgFrom = imread(compressed_filename);
end


min_splice_size = floor(min(row, col)/8);
max_splice_size = floor(min(row, col)/2);

if USE_CUSTOM_SPLICE_SIZE
    splice_size = custom_splice_size;
else
    splice_size = randi([min_splice_size, max_splice_size]);
end

splice_from_row = randi(1, rowFrom-splice_size-1);
splice_from_col = randi(1, colFrom-splice_size-1);
splice_to_row = randi(1, rowTo-splice_size-1);
splice_to_col = randi(1, colTo-splice_size-1);

imgOut = imgTo;

imgOut(splice_to_row:(splice_to_row+splice_size), ...
    splice_to_col:(splice_to_col+splice_size)) =  ...
    imgFrom(splice_from_row:(splice_from_row+splice_size), ...
    splice_from_col:(splice_from_col+splice_size));

imwrite(imgOut, output_filename);