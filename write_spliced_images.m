function write_spliced_images(filenames, splice_count, varargin)

% Control program for cross_image_splice that takes an input that is a list
% of filenames and randomly chooses splice_count pairs to splice into each
% other. can optionally compress images at different compression levels,
% trim images to a certain size, or splice a block of exactly a certain
% size



%% INPUT ARGUMENTS(NECESSARY)
% filenames:
%   a CELL ARRAY or STRUCT of filenames, eg
% {'red.png', 'blue.png', 'green.png', 'white.jpg', 'green.tif'}

% splice_count:
    % a positive integer less than or equal to length(filenames)^2
    
%% INPUT ARGUMENTS (OPTIONAL)
% paired input arguments:

    % 'trim', trim_size: 
    %   trim both images to trim_size x trim_size (non-negative integer)
    %   we recommend 128, 256, or 512



    % 'splice_size', splice_size
    %   splice a block of exactly size splice_size


% unpaired input:
    %  compression:
    %  compresses both images before splicing at different compression
    %  levels. image compression quality is between 40 and 90, and the
    %  compression level difference ranges between 0 and 25.
    
%% Broken Logging Stuff, Don't Worry About It
%     function log_filename = makeLog
%         time = (datestr('now', 'mmmm-dd'));
%         log_filename = strcat('write_spliced_images_', time);
%         log_file = fopen(log_filename, 'w+');
%         fprintf(log_file, 'write_spliced_images LOG start');
%         fclose(log_file);
%     end
% 
%     function write_log(log, has_been_logged)
%         log_file = fopen(log_filename, 'a+');
%         for m=1:numel(has_been_logged);
%             if not(has_been_logged(m))
%                 fprintf(log_file, log);
%                 has_been_logged(m) = 1;
%             end
%         end
%         fclose(log_file);
%                 
%     end

%% INPUT HANDLING
COMPRESS_IMAGES = 0;
USE_CUSTOM_SPLICE_SIZE = 0;
TRIM_TO_SIZE = 0;

if nargin > 2
    for n=1:length(varargin)
        
        if(strcmp(varargin{n}, 'compression'))
            COMPRESS_IMAGES = 1;
            
        elseif(strcmp(varargin{n}, 'splice_size'))
            USE_CUSTOM_SPLICE_SIZE = 1;
            splice_size = varargin{n+1};
            
        elseif(strcmp(varargin{n}, 'trim'));
            TRIM_TO_SIZE = 1;
            trim_size = varargin{n+1};
        end
    end
end

tic
%makeLog

%% Permute Input to Create Source-Target File Pairs
N = numel(filenames);

first_file = repmat((1:N)', N, 1);
second_file = reshape(repmat(1:N, N, 1), [], 1);

% this gives us a two-column array like this:
%   first_file     second_file
%   1               1
%   2               1
%   3               1
%   ..              ..
%   n               1
%   1               2
%   2               2
%   ..              ..
%   ..              ..
%   1               n
%   2               n


permutation_key = randperm(N^2, splice_count);
P = numel(permutation_key);
%log = cell(P, 1);
%has_been_logged = zeros(P, 1);


% keep track of percent completion
percent_marker = linspace(0, P);
percent_count = 1;
next_percent_marker = percent_marker(2);

%% MAIN LOOP
for n=1:P
    % choose source and destination files
    key = permutation_key(n);
    
    source_file = filenames{first_file(key)};
    
    target_file = filenames{second_file(key)};
    
    %source quality
    if COMPRESS_IMAGES
        compression_level_difference = randi([0, 25]);
        source_quality = randi([40+compression_level_difference, 90]);
        target_quality = source_quality - compression_level_difference;
    else
        source_quality = 100;
        target_quality = 100;
    end
    
    % filename string manipulation
    splice_string = sprintf('splice_%05g_src_', n);
    source_string = strcat(source_file(1:end-4), ...
        sprintf('_q1_%g', source_quality));
    target_string = strcat('_targ_', target_file(1:end-4), ...
        sprintf('_q2_%g', target_quality));
    output_filename = strcat(splice_string, source_string, ...
        target_string, '.jpg') ;
    
    
    
    %% splice images
    % in case of failure, we note the exception and move on. (except that
    % LOGGING is broken right now)
    
    try % cross_image_splice
        if TRIM_TO_SIZE && USE_CUSTOM_SPLICE_SIZE && COMPRESS_IMAGES
            cross_image_splice(source_file, target_file, output_filename, ...
                'compress_source', source_quality, ...
                'compress_target', target_quality, ...
                'trim', trim_size, ...
                'splice_size', splice_size);
            
        elseif TRIM_TO_SIZE && USE_CUSTOM_SPLICE_SIZE
            cross_image_splice(source_file, dest_file, output_filename, ...
                'trim', trim_size, ...
                'splice_size', splice_size);
            
        elseif TRIM_TO_SIZE && COMPRESS_IMAGES
            cross_image_splice(source_file, dest_file, output_filename, ...
                'compress_source', source_quality, ...
                'trim', trim_size)
            
        elseif TRIM_TO_SIZE
            cross_image_splice(source_file, dest_file, output_filename, ...
                'trim', trim_size)
            
        elseif COMPRESS_IMAGES && USE_CUSTOM_SPLICE_SIZE
            cross_image_splice(source_file, target_file, output_filename, ...
                'compress_source', source_quality, ...
                'compress_target', target_quality, ...
                'splice_size', splice_size);
            
        elseif COMPRESS_IMAGES
            cross_image_splice(source_file, target_file, output_filename, ...
                'compress_source', source_quality, ...
                'compress_target', target_quality)
            
        elseif USE_CUSTOM_SPLICE_SIZE
            cross_image_splice(source_file, target_file, output_filename, ...
                'splice_size', splice_size);
            
        else
            cross_image_splice(source_file, target_file, output_filename);
        end
        
        % if successful, note in LOG, but don't write to file to cut down on I/O
        % overhead
        
%         log{P} = strcat(num2str(n), ',', source_file, ',', dest_file, ',', ...
%             output_filename, ',', num2str(source_quality), ',', ...
%             num2str(target_quality), ',', 'good', '\n');
    catch exception
        
        warning('splice of image %s to image %s failed!', source_file, target_file);
        warning(exception.message)
        
        % write the LOG and keep going.
        
        %         log{P} = strcat(num2str(n), ',', source_file, ',', dest_file, ',', ...
        %             output_filename, ',', num2str(source_quality), ',', ...
        %             num2str(target_quality), ',', 'failed', ',', exception.message, '\n');
        %         write_log(log, has_been_logged);
    end
    
    % keep track of percent completion and output to stdout 
    if n > next_percent_marker
        percent_count = percent_count + 1;
        next_percent_marker = percent_marker(percent_count+1);
        fprintf('\n %0g percent complete! \n', round(n/P*100));
    end
    
end
end

