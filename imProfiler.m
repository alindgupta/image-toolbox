%%  Linescan profiler
%   
%   This script will allow simultaneous measurements of pixel intensity linescans
%   from `two` channels with user input.
% 
%   No length scaling is implemented (which would require interpolation of values)
%
%   Author: Alind Gupta
%   Last modified: Aug 2017
%

%% clear screen, vars
clear
clc

%% containers initialized with zeros to hold values from the while loop
%  this is done in advance for efficiency
MAX_NPX = 400;                          % buffer, max number of pixels to be counted
MAX_NOBJ = 20;                          % max number of objects to be counted
channel1 = zeros(MAX_NPX, MAX_NOBJ);
channel2 = zeros(MAX_NPX, MAX_NOBJ);

%% the following two variables are required for trimming the container later
largest_initIndex = 0;
smallest_endIndex = MAX_NPX;

%% main loop
userInput = 1;
i = 1; 
selectNext = 1;

while userInput ~= 0
    
    if selectNext == 1

        disp('Please select a picture')
        bf = bfopen(uigetfile({'*'}));      % reads pictures with bfopen, files need to be in the same directory as this script for uigetfile
        bfr = bf{1, 1};
        im1 = bfr{1, 1};                    % channel 1
        im2 = bfr{2, 1};                    % channel 2
        
        bfm = bf{1, 2};                     % metadata - I use this to figure out the zoom factor for ndi images
        bfm = bfm.get('Global sSpecSettings');
        disp(bfm(460:480));
       
        im = imfuse(im1, im2);

        imAdj1 = imadjust(im1);
        imAdj2 = imadjust(im2);
        imAdj = imfuse(im1, imAdj2);
        
        figure, imshow(imAdj);
        temp = input('Please adjust the zoom to your liking. Hit `Return`  when done.');

    end
    
    % produce linescans
    [x, y] = ginput();                      % gets coordinates of line segments
    imageProfile = improfile(im, x, y);     % gets pixel values
    
    % add scans to containers
    channel1(1:length(imageProfile(:,:,1)), i) = imageProfile(:,:,1);
    channel2(1:length(imageProfile(:,:,2)), i) = imageProfile(:,:,2);
    
    selectNext = 0;
    selectNext = input('Enter 1 to change picture or 0 to continue with current picture');
    
    userInput = input('Press 1 to measure, 0 to exit');
    i = i + 1;
   
end % end of main loop

% trim empty columns
% may want to just remove all columns that only contain zeros
channel1(:,i-1:end) = [];
channel2(:,i-1:end) = [];

% calculate delays - same delays will be used for both channel2 and channel1
% finds the delay that maximizes cross-correlation
reference = channel1(:,1);
delays = finddelay(reference, channel1);

tots = size(channel1, 2);

for counter = 1:tots
    channel1(:,counter) = circshift(channel1(:,counter), delays(counter));
    channel2(:,counter) = circshift(channel2(:,counter), delays(counter));
end

% this simply "centers" the data in the matrix
channel1 = circshift(channel1, 50);
channel2 = circshift(channel2, 50);

csvwrite('channel1.csv', channel1);
csvwrite('channel2.csv', channel2);
