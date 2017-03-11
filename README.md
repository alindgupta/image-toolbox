# Assorted image processing scripts

### Usage

##### dotLength.m
Useful for supervised measurements of lengths of objects in a fluorescence image. First, select background pixels to set an average cutoff value for measurements. Then, manually enter line segments traversing the object to calculate number of pixels above cutoff. Finally, pick a scale to convert pixel measurements to length. All measurements are written to a .csv file.

##### autoLength.m
Useful for unsupervised measurements of objects in fluorescence images. Automatic image segmentation based on a cutoff value (determined by selection of background pixels). The algorithm measures lengths of the major axis for each object and writes them to a .csv file. It also prints the mean and standard deviation of the calculated lengths.

##### linescanProfiler.m
Measures line profiles for multiple objects in an image based on user input, aligns the signals using cross-correlation and plots average line profiles with standard deviation for 2 channels on the same graph. Useful for quantifying enrichment (pixel intensities) of 2 markers along discrete segments of interest to see how they vary relative to each other. 
Dependancy - stdshade.m (MathWorks) for plotting graphs

##### linescanProfileMultipleIm.m
Identical to linescanProfiler.m but can be used for processing multiple images iteratively.
