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