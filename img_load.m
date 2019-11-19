clc, clear all;
addpath(genpath( 'C:\Users\caoshuning\Desktop\Bayer2RGB\bayerÍ¼Ïñ\20190802_wei2_Raw_bmp\'))
filepath = '19.bmp';
% I = fopen(filepath);
% I = fread(I);
I = imread(filepath);
% img = I(1:210*210);
% img = reshape(img,[210,210]);
% save('1.png','img')
img = bayer2rgb(I',210,210,2);
imshow(img);