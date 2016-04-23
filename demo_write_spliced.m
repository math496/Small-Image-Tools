% test write_spliced_images

filename = {'white.png', 'blue.png', 'black.png', 'red.png', 'green.png'};

black = zeros(512, 512, 3, 'uint8');
blue = black;       blue(:, :, 3) = 256;
red = black;        red(:, :, 1) = 256;
green = black;      green(:, :, 2) = 256;
white = black;      white(:) = 256;
    
color = {white, blue, black, red, green};

for n=1:5
    imwrite(color{n}, filename{n});
end

write_spliced_images(filename, 'all', 'no_duplicates', 'compression')