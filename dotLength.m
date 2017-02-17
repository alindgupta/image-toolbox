%% clear
clc
clear all
close all

%% get images

im1 = imread('T00001C01Z001.tif');
im2 = imread('T00001C02Z001.tif');
im1 = rgb2gray(im1);
im2 = rgb2gray(im2);
im = imfuse(imadjust(im1), imadjust(im2));

figure, imshow(im);
temp = input('Please adjust the zoom to your liking. Hit a key when done.');



%% get background


temp = input('Please select a line with cutoff for background levels.');
[a, b] = ginput();
backgroundVec = improfile(im2, a, b);
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
        tempArr = improfile(im2, x, y);
    
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
finalLengths(finalLengths==0)=[];
finalLengths = finalLengths*(temp/delX);


dlmwrite ('mean.csv', finalLengths, '-append');












