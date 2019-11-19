clc
clear
close all
TBdata_path= 'C:\Users\caoshuning\Desktop\Bayer2RGB\bayerÕºœÒ\';
image_row=240;
image_col=240;
imag_num=895; %210*210ÕºœÒ”–451’≈
data_col=image_row*imag_num;
ImgPath=[TBdata_path,'20190815_240240_4_Raw.bin'];
fid = fopen(ImgPath);
[data,map] = fread(fid, [image_row data_col], 'uchar');
data=data';

for i=1:895
    image_row_begin=(i-1)*image_row+1;
    image_row_end=i*image_row;
    imag(1:image_row,1:image_col)=data(image_row_begin:image_row_end,1:image_col);
    image8 =uint8(imag);  
    imshow(image8);
    image8_RGB = bayer2rgb(image8, image_row, image_col,2 );
    BMP_Path=[TBdata_path,'20190815_240240_4_Raw_bmp\',num2str(i),'.bmp'];
    imwrite(image8,BMP_Path);
    RAW_Path=[TBdata_path,'20190815_240240_4_Raw\',num2str(i),'.raw'];
    fid1 = fopen(RAW_Path,'wb');
    fwrite(fid1,image8','uint8');
    RGB_Path = [TBdata_path,'20190815_240240_4_Raw_RGB_matlab_1\',num2str(i),'.bmp'];
    imwrite(image8_RGB, RGB_Path);
    [x,map]=imread(BMP_Path);%–¥»ÎRGBÕºœÒ
    fclose(fid1);
end

display('work done');







 