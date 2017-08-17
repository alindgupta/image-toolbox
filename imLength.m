%% Calculate object lengths from supervised input on fluorescence images
%  
%  This is perhaps a slightly more principled way of measuring pixels than 
%  doing it completely manually. Certainly less error-prone.
%
%  Author: Alind Gupta
%  Last modified: Aug 2017
%

%% Read tiff files
% Should have files with a scale bar on them
im1 = imread(uigetfile('.tif'));
im2 = imread(uigetfile('.tif'));

im1 = rgb2gray(im1);        % rgb2gray may be unnecessary
im2 = rgb2gray(im2);
im = imfuse(imadjust(im1), imadjust(im2));

%% get background for channel 1
figure, imshow(imadjust(im1));
input('Please zoom to your liking. Hit `Return` when done');
input('Select background pixels. The median value will be used as the cutoff. Hit `Return`.');
[a,b] = ginput();
backgroundVec1 = improfile(im1, a, b);
backgroundInt1 = median(backgroundVec1);

%% get background for channel 2
figure, imshow(imadjust(im2));
input('Please zoom to your liking, hit a key when done');
input('Select background px');
[c, d] = ginput();
backgroundVec2 = improfile(im2, c, d);
backgroundInt2 = median(backgroundVec2);

input('OK, please close all image windows');
figure, imshow(im);

%% main loop

% I have commented these out
% but uncomment these if you care about efficiency a lot
% containers
% tempArr1 = zeros(1, 200);
% tempArr2 = zeros(1, 200);
% tempArrLogical1 = zeros(1, 200);
% tempArrLogical2 = zeros(1, 200);

finalLengths1 = zeros(100, 1);
finalLengths2 = zeros(100, 1);

userInput = 1;
i = 1;

input('Please zoom as you please and press a key');

while userInput ~= 0
    try
        [x, y] = ginput();
        tempArr1 = improfile(im1, x, y);
        tempArr2 = improfile(im2, x, y);

        tempArrLogical1 = tempArr1 > backgroundInt1;
        tempArrLogical2 = tempArr2 > backgroundInt2;

        % this works much better than what I had before, which was very error-prone
        [~, length1] = mode(cumsum(diff((find(tempArrLogical1)))~=1));
        [~, length2] = mode(cumsum(diff((find(tempArrLogical2)))~=1));

        finalLengths1(i) = length1;
        finalLengths2(i) = length2;
        
        i = i + 1;

        userInput = input('1 to go, 0 to stop');

    catch ME
        disp(ME);
        userInput = input('1 to go, 0 to stop'); 
        continue
    end
end

temp = input(['Go to scale bar, enter the scale reference (a number), ' ... 
'then press `Return` and select the beginning and end of scale bar']);

[x, y] = ginput();
delX = x(end) - x(1);

finalLengths1(finalLengths1==0) = [];
finalLengths1 = finalLengths1 * (temp / delX);

finalLengths2(finalLengths2==0) = [];
finalLengths2 = finalLengths2 * (temp / delX);

dlmwrite('out1.csv', finalLengths1, '-append');
dlmwrite('out2.csv', finalLengths2, '-append');
