clc,clear all;
xb = imread('march.png');
imshow(xb);

xc = bayer2rgb( xb,320,420,1 );
figure
imshow(xc);
title('Nearest neighbour interpolation 320x420 pixels');

xc = bayer2rgb( xb,320,420,2 );
figure
imshow(xc);
title('Bilinear interpolation 320x420 pixels');

xc = bayer2rgb( xb,960,1280,1 );
figure
%imshow(xc);
imshow(xc,'InitialMagnification',100);
title('Nearest neighbour interpolation 960x1280 pixels');

xc = bayer2rgb( xb,960,1280,2 );
figure
%imshow(xc);
imshow(xc,'InitialMagnification',100);
title('Bilinear interpolation 960x1280 pixels');