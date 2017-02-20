function [m, sd] = autoLengths(minlen, maxlen)
% Calculate lengths of objects in fluorescence images automatically
% by providing a background value
% - minlen : minimum cutoff for lengths
% - maxlen : maximum cutoff for lengths

    if nargin < 2:
            minlen = 5      % smallest size acceptable (number of pixels)
            maxlen = 100    % largest size acceptable (number of pixels)
    end

    % read image file and display
    filename = uigetfile;
    im = imread(filename);
    im = rgb2gray(im);
    figure;
    imshow(im);

    temp = input('Please zoom to a single object in focus');
    temp = input('Please select background pixels');
    [x,y] = ginput();
    prof = improfile(im, x, y);
    profMean = ceil(mean(prof));

    imbw = im > profMean;
    smallestObjArea = ceil(pi * ((minlen-1) / 2) ** 2);  % smallest object
    imopen = bwareaopen(imbw, smallestObjArea);

    x = regionprops(imopen, 'MajorAxisLength');
    x = cell2mat(struct2cell(x))(:);

    y = x(x < maxlen && x > minlen);
    [m, sd] = [mean(y), std(y)]
    % dlmwrite('means.csv', y, '-append');

end

    

%{

% Original code

clear all
close all
clc

filename = uigetfile;
im = imread(filename);
im = rgb2gray(im);
imshow(im)

temp = input('Please zoom to single centriole');
[x,y] = ginput();
prof = improfile(im, x, y);
profMean = mean(prof);
ceilProfMean = ceil(profMean);

imbw = im > ceilProfMean;
imopen = bwareaopen(imbw, 10);

x = regionprops(imopen, 'MajorAxisLength');
x = struct2cell(x);
x = cell2mat(x);
x = x(:);
y = x(x < 13);
mean(y)
std(y)
%dlmwrite ('meanswt.csv', y, '-append');
%}

