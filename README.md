# Small-Image-Tools
Small tools for image processing. Made for fun, programming practice, and to understand images better for my image forgery detection project with SDSU and LEIDOS.


## SIZE: RESAMPLING:

###grow_image:
expands an image by an integer factor via simple resampling

###shrink_image:
shrinks an image by an integer factor via simple resampling


## COLOR:
### add_tint:
adds RED, GREEN, OR BLUE to ALL of an image

### shift_tint:
shifts ratio of RED, GREEN, OR BLUE and (OPTIONAL) LUMINANCE [AKA, 'brightness']

### flatten_color:
crushes the color of an image to the specified bit depth. supports inputs that are not powers of two, but this may cause strange results.

## BRIGHTNESS AND CONTRAST
### adjust_contrast:
adjusts contrast of an image, making bright areas brighter and dark areas darker.
the user can adjust LUMINANCE first, or BIAS the threshold of what is  considered 'light' or  'dark'

## IMAGE FORGERY:
Various tools to create forged images for the purpose of image forgery detection

### copy_paste_forge
copies squares from the top-left quadrant of an image to somewhere else in the image

### splice_forge
copies a square from an image spliceFrom to an image spliceTos

## SHADERS
### cartoon_edge: 
adds a cartoon edge or 'border' around edges of an image: uses sobel edge detection

### cell_shade:
combines 'cartoon_edge' and 'flatten_color' to create a comic-book or cartoony effect. think "legend of zelda: wind waker" or "dark cloud 2"

### PREDICT IMAGE
predicts the values of an image by using it's neighboring pixels' 
channel values, as noted on page 3 of 'IMage Splicing Detection Using 2-D
phase congruency and statistical moments of characteristic function', by 
Wen CHen, Yun Q. Shi, & We Su.
