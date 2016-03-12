# Small-Image-Tools
Small tools for image processing made as part of this project.


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

## SHADERS
### cartoon_edge: adds a cartoon edge or 'border' around edges of an image: uses sobel edge detection
### cell_shade: combines 'cartoon_edge' and 'flatten_color' to create a comic-book or cartoony effect. think "legend of zelda: wind waker" or "dark cloud 2"
