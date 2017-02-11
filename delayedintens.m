%% clear screen, vars
clear variables
clc
disp('Please begin ginput at the proximal end, not from the cilium tips');

%% read image files

% Note - replace with uigetfile if needed
im1 = rgb2gray(imread('T00001C01Z001.tif'));   % rgb2gray just in case    
im2 = rgb2gray(imread('T00001C02Z001.tif'));
im = imfuse(im1, im2);

% adjusted images for displaying to the user
imAdj1 = imadjust(im1);
imAdj2 = imadjust(im2);
imAdj = imfuse(imAdj1, imAdj2);

figure, imshow(imAdj);
temp = input('Please adjust the zoom to your liking. Hit a key when done.');

%% main loop

MAX_ROWS = 400; % buffer, max number of pixels to be counted
MAX_NUMCILIA = 10; % max number of cilia to be counted


% for later cleanup
largest_initIndex = 0;
smallest_endIndex = MAX_ROWS;


userInput = 1;


% initialized arrays to hold max sizes
CD8 = zeros(MAX_ROWS, MAX_NUMCILIA);
PLC = zeros(MAX_ROWS, MAX_NUMCILIA);

% counter for concatenation
i = 1; 

while userInput ~= 0
    
    % produce linescans
    [x, y] = ginput();                      % gets coordinates of line segments
    imageProfile = improfile(im, x, y);     % gets pixel values
    
    
    % add scans to containers
    CD8(1:length(imageProfile(:,:,1)),i) = imageProfile(:,:,1);
    PLC(1:length(imageProfile(:,:,2)),i) = imageProfile(:,:,2);
    
    userInput = input('Press 1 to go, 0 to exit');
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

















