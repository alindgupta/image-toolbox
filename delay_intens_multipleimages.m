%% clear screen, vars
clear
clc

%% main loop

MAX_ROWS = 400; % buffer, max number of pixels to be counted
MAX_NUMCILIA = 20; % max number of cilia to be counted


% for later cleanup
largest_initIndex = 0;
smallest_endIndex = MAX_ROWS;


userInput = 1;


% initialized arrays to hold max sizes
CD8 = zeros(MAX_ROWS, MAX_NUMCILIA);
PLC = zeros(MAX_ROWS, MAX_NUMCILIA);

% counter for concatenation
i = 1; 

selectNext = 1;

while userInput ~= 0
    
    if selectNext == 1
        disp('Please select the first two files, green followed by red')
        im1 = rgb2gray(imread(uigetfile));   
        im2 = rgb2gray(imread(uigetfile));
        im = imfuse(im1, im2);

        imAdj1 = imadjust(im1);
        imAdj2 = imadjust(im2);
        imAdj = imfuse(imAdj1, imAdj2);
        
        figure, imshow(imAdj);
        temp = input('Please adjust the zoom to your liking. Hit a key when done.');
    end
    
    
    % produce linescans
    [x, y] = ginput();                      % gets coordinates of line segments
    imageProfile = improfile(im, x, y);     % gets pixel values
    
    
    % add scans to containers
    CD8(1:length(imageProfile(:,:,1)),i) = imageProfile(:,:,1);
    PLC(1:length(imageProfile(:,:,2)),i) = imageProfile(:,:,2);
    
    selectNext = 0;
    selectNext = input('Enter 1 to change picture or 0 to continue with current picture');
    
    userInput = input('Press 1 to measure, 0 to exit');
    i = i + 1;
   
end

% trim columns
CD8(:,i-1:end) = [];
PLC(:,i-1:end) = [];

% calculate delays - same delays will be used for both PLC and CD8
reference = CD8(:,1);
delays = finddelay(reference, CD8);

tots = size(CD8, 2);

for counter = 1:tots
    CD8(:,counter) = circshift(CD8(:,counter), delays(counter));
    PLC(:,counter) = circshift(PLC(:,counter), delays(counter));
end

CD8 = circshift(CD8, 50);
PLC = circshift(PLC, 50);

figure, stdshade(CD8.', 0.2, 'r');
hold on
stdshade(PLC.', 0.2, 'g'); 