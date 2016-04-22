function [varargout] = cross_image_splice(source_filename, target_filename, ...
    output_filename, varargin)
% splice a random square block from a SOURCE 'from' FILE to a VICTIM
% 'to' file. 

% by Efron Licht. no rights reserved. go nuts.

%% INPUT ARGUMENTS (NECESSARY)
% source_filename:
%    filename of SOURCE file (eg, foreground.png);
% copy_to_filename: 
%   filename of target file (eg, background.png);
% outout_filename:
%   filename of OUTPUT (eg,  splice_foreground_background.png);

%% INPUT ARGUMENTS (OPTIONAL)
% all input arguments are pairs:
% 'trim', trim_size: 
%   trim both images to trim_size x trim_size (non-negative integer)
%   we recommend 128, 256, or 512

% 'compress_source', source_compression_quality:
%   as intermediate step, resave SOURCE as .jpg at quality compresion_quality
%   before splicing

% 'compress_target', target_compression_quality:
%   as intermediate step, resave target as .jpg at quality target_quality
%   before splicing



% 'splice_size', splice_size
%   splice a block of exactly size splice_size

%% OUTPUT ARGUMENTS (OPTIONAL)
% varargout saves the output
%% INPUT HANDLING

% bools to zero if no optional arguments
COMPRESS_SOURCE_OF_SPLICE = 0;
COMPRESS_TARGET_OF_SPLICE = 0;
USE_CUSTOM_SPLICE_SIZE = 0;
TRIM_TO_SIZE = 0;

if nargin > 3
    for n=1:length(varargin)
        
        if(strcmp(varargin{n}, 'compress_source'))
            COMPRESS_SOURCE_OF_SPLICE = 1;
            source_compression_quality = varargin{n+1};
            
        elseif(strcmp(varargin{n}, 'compress_target'));
            COMPRESS_TARGET_OF_SPLICE = 1;
            target_compression_quality = varargin{n+1};
            
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
imgTo = imread(target_filename);

[rowFrom, colFrom, ~] = size(imgFrom);
[rowTo, colTo, ~] = size(imgTo);

row = min(rowFrom, rowTo);
col = min(colFrom, colTo);

%% HANDLE OPTIONAL ARGUMENTS
if TRIM_TO_SIZE
    try assert(row >= trim_size && col >= trim_size);
    catch
        error('image is smaller than trim_size')
    end
    
    imgFrom = imgFrom(1:trim_size, 1:trim_size, :);
    imgTo = imgTo(1:trim_size, 1:trim_size, :);
end

if COMPRESS_SOURCE_OF_SPLICE     % save as compressed JPG and re-read;
%     L = length(source_filename);
%     source_filename_stripped = source_filename(1:L-4);
%     compression_str = sprintf('_compressed_%02g.jpg', ...
%         source_compression_quality);
%     
%     compressed_filename = strcat(source_filename_stripped, ...
%         compression_str);
%     
    compressed_filename = 'temp.jpg';
    imwrite(imgFrom, compressed_filename, ...
        'jpg', 'Quality', source_compression_quality)
    
    imgFrom = imread(compressed_filename);
end

if COMPRESS_TARGET_OF_SPLICE % save as compressed JPG and re-read;
    compressed_filename = 'temp.jpg';
%     L = length(target_filename);
%     target_filename_stripped = target_filename(1:L-4);
%     compression_str = sprintf('_compressed_%02g.jpg', ...
%         target_compression_quality);
%     compressed_filename = strcat(target_filename_stripped, ...
%         compression_str);
    imwrite(imgTo, compressed_filename, ...
        'jpg', 'Quality', target_compression_quality);
    imgTo = imread(compressed_filename);
end
    
    

if USE_CUSTOM_SPLICE_SIZE
    splice_size = custom_splice_size;
else
    min_splice_size = floor(min(row, col)/8);
    max_splice_size = floor(min(row, col)/2);
    splice_size = randi([min_splice_size, max_splice_size]);
end

%% SPLICE
splice_from_row = randi([1, rowFrom-splice_size-1]);
splice_from_col = randi([1, colFrom-splice_size-1]);
splice_to_row = randi([1, rowTo-splice_size-1]);
splice_to_col = randi([1, colTo-splice_size-1]);


imgOut = imgTo;

imgOut(splice_to_row:(splice_to_row+splice_size), ...
    splice_to_col:(splice_to_col+splice_size), :) =  ...
    imgFrom(splice_from_row:(splice_from_row+splice_size), ...
    splice_from_col:(splice_from_col+splice_size), :);

% output
imwrite(imgOut, output_filename);

if nargout == 1;
    varargout{1} = imgOut;
elseif nargout > 1
    warning('function has at most one output. are you sure about this?');
end
% % diagnostics
% 
% fprintf('splice_to_row is %g\n', splice_to_row);
% fprintf('splice_to_col is %g\n', splice_from_row);
% imshow(imgOut);

end