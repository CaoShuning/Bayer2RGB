function [R, G0, G1, B] = BayerColorSplit(BAYER)
%Bayer pattern 颜色分离.

%Find size of xb
[m,n] = size(BAYER);	

%For each node find the color
color=zeros(m,n);
R = uint8(zeros(m,n));
B = uint8(zeros(m,n));
G0 = uint8(zeros(m,n));
G1 = uint8(zeros(m,n));

for j=1:n
    for i=1:m
        temp_x = mod(i,2);
        temp_y = mod(j,2);
        
        if(temp_x==0 && temp_y==1)%R
%             color(i,j) = 'r';
            R(i,j) = BAYER(i,j);
        
        elseif (temp_x==1 && temp_y==0 )%B
%             color(i,j) = 'b';
            B(i,j) = BAYER(i,j);
        
        elseif (temp_x==1&&temp_x==1)%G1坐标都是奇数
%             color(i,j) = 'g1';
            G1(i, j) = BAYER(i, j);
            
        elseif (temp_x==0&&temp_y==0)%G0坐标都是偶数
%             color(i,j) = 'g0';
            G0(i, j) = BAYER(i, j);
        end

    end
end