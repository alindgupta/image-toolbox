function dotLength(im1, varargin)
%   Calculate lengths of objects supervised by user input
%   Firstly, user selects background pixel value cutoff (averaged)
%   Then, user manually inputs (using mouse) line segment across objects
%   Finally, a scale is selected for pixel to length conversion
%   The program writes lengths of all measured objects to a csv file
%
% - im1 is the image of interest
% - im2 (out of varargin) may be useful for orientation, not required though
%

    %% clear
    %clc
    %clear all
    %close all

    %% file IO
    if nargin == 0
        error('Require at least one image file!');        
    end

    if length(varargin) > 1
        disp('Only one additional image file is supported, truncating to first...');
        im2 = varargin{1};
    end

    if length(varargin) == 0
        im2 = zeros(size(im1));
    end

    im1 = rgb2gray(im1);
    im2 = rgb2gray(im2);
    im = imfuse(imadjust(im1), imadjust(im2));

    figure, imshow(im);
    temp = input('Please adjust the zoom to your liking. Hit a key when done');


    %% get background
    temp = input('Please select background pixels');
    [a, b] = ginput();
    backgroundVec = improfile(im1, a, b);
    backgroundInt = mean(backgroundVec);


    %% main loop

    % container array
    tempArr = zeros(1,200);         % stores output from improfile
    tempArrLogical = zeros(1,200);  % stores a logical, >background value
    finalLengths = zeros(100, 1);   % stores final lengths from tempArr

    length = 0;

    userInput = 1;
    i = 1;

    while userInput ~= 0
    
        try
            [x,y] = ginput();
            tempArr = improfile(im1, x, y);
    
            tempArrayLogical = tempArr > backgroundInt
    
            length = max( find(diff(tempArrayLogical)==-1) - find(diff(tempArrayLogical)==1) )
            finalLengths(i) = length;
            i = i+1;
    
            userInput = input('1 to go, 0 to stop');  
    
        catch ME
            continue
        end 
    end

    temp = input('Go to the scale bar and enter scale ref');
    [x,y] = ginput();
    delX = x(end)-x(1);
    finalLengths(finalLengths==0) = [];
    finalLengths = finalLengths*(temp/delX);

    dlmwrite ('mean.csv', finalLengths, '-append');

end
