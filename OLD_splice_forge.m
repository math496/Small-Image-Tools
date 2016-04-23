function spliceOut = splice_forge(spliceTo, spliceFrom, varargin)
% CREATES a forged image by splicing together a random square from
% spliceFrom into spliceTo.
% By default, copied squares are at least 64x64 and at most
% min(rows,cols)*2/3 in size, so the human eye can recognize the output.

% If both input images are RGB, output is RGB. Otherwise, the output is
% grayscale.
%% INPUT HANDLING

if nargin > 2
    warning(['variable argument input not currently supported.' ...
        'did you mean to do this?'])
end

%spliceTo = import_image(spliceTo);
%spliceFrom = import_image(spliceFrom)

% if nargin > 2
%     for n=1:length(varargin)
%         if strcmp(varargin{n}, 'copysize')
%             try copy_size = varargin{n+1};
%                 assert(isnumeric(copy_size))
%                 assert(numel(custom_copy_size) == 1)
%                 assert(not(any(mod(copy_size, 1) > 0)))
%                 assert(not(any(max(copy_size)>size(spliceTo))));
%                 assert(not(any(max(copy_size)>size(spliceFrom))));
%                 CUSTOM_COPY_SIZE = 1;
%             catch ME
%                 error(['copy_size should be a positive integer smaller'...
%                     'in dimension than the either source image']);
%             end
%         elseif strcmp(varargin{n}, 'copyposition')
%             try copy_position = varargin{n+1};
%                 assert(isnumeric(copy_position))
%                 assert(numel(custom_copy_size) == 2)
%                 assert(not(any(mod(copy_position, 1) > 0)))
%                 assert(not(any(max(copy_position)>size(spliceTo))));
%                 assert(not(any(max(copy_position)>size(spliceFrom))));
%                 CUSTOM_COPY_POSITION = 1;
%             catch ME
%                 error(['copy_position should be a 2x1 positive integer' ...
%                     'smaller in in dimension than either source image']);
%             end
%     end
% end
        
             

if size(spliceTo, 3) == 3 && size(spliceFrom, 3) == 1
    warning(['spliceTo is grayscale, but spliceFrom is RGB.' ...
        'grayscaling spliceTo'])
    
    spliceFrom = rgb2gray(spliceFrom);
    
elseif size(spliceTo, 3) == 1 && size(spliceFrom, 3) == 3
    warning(['spliceFrom is grayscale, but spliceTo is RGB.' ...
        'grayscaling spliceFrom'])
    
    spliceTo = rgb2gray(spliceTo);
    
end

[rowTo, colTo, ~] = size(spliceTo);
[rowFrom, colFrom, ~] = size(spliceFrom);

minrow = min(rowTo, rowFrom);
mincol = min(colTo, colFrom);

minimum_copy_size = round(min([64, [minrow, mincol]/2]));
maximum_copy_size = round(min([minrow, mincol]*2/3));

copy_size = randi([minimum_copy_size, maximum_copy_size]);
copy_from_row = randi([1, rowFrom-copy_size]);
copy_from_col = randi([1, colFrom-copy_size]);
    
copy_to_row = randi([1, rowTo-copy_size]); 
copy_to_col = randi([1, colTo-copy_size]);

spliceOut = spliceTo;

spliceOut(copy_to_row:(copy_to_row+copy_size), ...
    copy_to_col:(copy_to_col+copy_size), :) = ...
    spliceFrom(copy_from_row:(copy_from_row+copy_size), ...
    copy_from_col:(copy_from_col+copy_size), :);
    