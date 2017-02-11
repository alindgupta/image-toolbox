%% clear screen, vars
clear all
clc
disp('****Please ginput at the distal end, not at the cilium tip*****');



%% read image files

im1 = imread('T00001C01Z001.tif');
im2 = imread('T00001C02Z001.tif');
im = imfuse(im1, im2);

% adjusted images - for ginput from user
imAdj1 = imadjust(rgb2gray(im1));
imAdj2 = imadjust(rgb2gray(im2));
imAdj = imfuse(imAdj1, imAdj2);

figure, imshow(imAdj)
temp = input('Please adjust the zoom to your liking. Hit a key when done.');


%% main loop

MAX_ROWS = 400;

% for later cleanup
largest_initIndex = 0;
smallest_endIndex = MAX_ROWS;

largest_initIndex1 = 0;
smallest_endIndex1 = MAX_ROWS;

userInput = 1;



% initialized arrays to hold max sizes
CD8 = zeros(MAX_ROWS, 10);
PLC = zeros(MAX_ROWS, 10);

% counter for concatenation
i = 1;

while userInput ~= 0
    
    % produces linescans
    [x, y] = ginput();
    imageProfile = improfile(im, x, y);
    
    % calculates lengths of cols in imageProfile, 
    % might be redundant to have both
    CD8len = length(imageProfile(:,:,1));
    PLClen = length(imageProfile(:,:,2));
    
    % normalize, might want to use a function here
    tmp1 = imageProfile(:,:,1);
    tmp1 = (tmp1 - min(tmp1)) / (max(tmp1) - min(tmp1));
    
    tmp2 = imageProfile(:,:,2);
    tmp2 = (tmp2 - min(tmp2)) / (max(tmp2) - min(tmp2));
    
    
    % calculate peak index - chooses peak@ciliary dilation
    [peakValues, peakIndex] = findpeaks(tmp1, 'MinPeakDistance', 40)
    secondPeak = peakIndex(1);
    
    [peakValues1, peakIndex1] = findpeaks(tmp2, 'MinPeakDistance', 40)
    secondPeak1 = peakIndex1(1);

    
    % update container arrays
    initIndex = (MAX_ROWS/2) - secondPeak;
    endIndex = initIndex + CD8len - 1;
    CD8(initIndex:endIndex, i) = tmp1;
    
    if initIndex > largest_initIndex
        largest_initIndex = initIndex;
    end
    
    
    if endIndex < smallest_endIndex
        smallest_endIndex = endIndex;
    end
   
    
    initIndex1 = (MAX_ROWS/2) - secondPeak1;
    endIndex1 = initIndex1 + PLClen - 1;
    PLC(initIndex1:endIndex1, i) = tmp2;
    
    if initIndex1 > largest_initIndex1
        largest_initIndex1 = initIndex1;
    end
    
    if endIndex1 < smallest_endIndex1
        smallest_endIndex1 = endIndex1;
    end
    
    i = i + 1;
    userInput = input('Press 1 to go, 0 to exit');
    
    
end




% trim columns
CD8(:,i:end) = [];
PLC(:,i:end) = [];

%{
 
% trim rows
CD8(min(smallest_endIndex+1, smallest_endIndex1+1):end,:) = [];
CD8(1:max(largest_initIndex-1,largest_initIndex-1),:) = [];

PLC(min(smallest_endIndex+1, smallest_endIndex1+1):end,:) = [];
PLC(1:max(largest_initIndex-1,largest_initIndex-1),:) = [];

%}

% plot

figure, stdshade(CD8.', 0.2, 'r');
hold on
stdshade(PLC.', 0.2, 'g');



%end





