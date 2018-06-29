function xc = bayer2rgb( xb,M,N,type )
%Bayer pattern to RGB true colour.

%Find size of xb

[m,n] = size(xb);	

%For each node find the color
color=zeros(m,n);
for j=1:n
    for i=1:m
        temp_x = mod(i,2);
        temp_y = mod(j,2);
        
        if(temp_x==0 && temp_y==1)
            color(i,j) = 'r';
        
        elseif (temp_x==1 && temp_y==0 )
            color(i,j) = 'b';
         
        else 
             color(i,j) = 'g';
         
         end

    end
end
clear temp_x;
clear temp_y;
clear i;
clear j;

%The scale is m/M and n/N
x_scale = m/M;       
y_scale = n/N;       

%Initialize RGB vector
RGB = zeros(M,N,3);

%Initialize nodes
%Nodes = pixels
nodes = [];

if (type==1)
    
    %Nearest neighbour interpolation
   
    for i=1:M
		%For image enlarging, there are pixels that there is no information to calculate them
		% So the rgb color is the same with the fisrt calculated row or column
        for j=1:N
            x = i*x_scale;
            if (x<1)
				x=1;
            end
            y = j*y_scale;
            if (y<1)
				y=1;
            end
            
            %For the nearest neighbour interpolation there are 4 nearest pixels
            
            nodes{1} = [floor(x) floor(y)];
            nodes{2} = [floor(x) floor(y)+1];
            nodes{3} = [floor(x)+1 floor(y)];
            nodes{4} = [floor(x)+1 floor(y)+1];
            
            %For array's limits case
            if(x==m || y==n)
                for k=1:4
                    if(nodes{k}(1)>m)
                        nodes{k}(1) = m-1;
                    end
                    if(nodes{k}(2)>n)
                        nodes{k}(2) = n-1;
                    end
                end
            end
            
            %Initialize minimum distance minG=2 for green colour.
			%In a square maximum disatnce between nodes is sqrt(2).
            minG=2;
            
			%for red & blue there is only one in the square
			%for blue there is only one in the square
            for k=1:4

                if(color(nodes{k}(1),nodes{k}(2))=='r')
                    RGB(i,j,1) = xb(nodes{k}(1),nodes{k}(2));
                elseif(color(nodes{k}(1),nodes{k}(2))=='g')
                    %find the minimum distance
                    dis = sqrt((x-nodes{k}(1))^(2) +(y-nodes{k}(2))^(2));
                    if (dis<minG)
                        minG = dis;
                         RGB(i,j,2) = xb(nodes{k}(1),nodes{k}(2));
                    end
                else  
                    RGB(i,j,3) = xb(nodes{k}(1),nodes{k}(2));
                end
            end
        end
    end

elseif (type==2)
    %Bilinear interpolation
    
	%Initialize RGB.
    RGB=zeros(M,N,3);
    
    %Find RED
	
	%Create red's grid 
    [X,Y] =meshgrid(2:2:m,1:2:n);
    
    %Find the red Rbayer array from xb array
	local_i=1;
    for i=2:2:m
        local_j=1;
        for j= 1:2:n
            Rbayer(local_i,local_j)=xb(i,j);
            local_j = local_j +1;
        end
        local_i = local_i +1;
    end
    
    Rbayer=double(Rbayer);
	%Create resized grid
    [Xg,Yg] =meshgrid(x_scale:x_scale:m,y_scale:y_scale:n);
	%Interpolate values
    R_interp=interp2(X,Y,Rbayer.',Xg,Yg);
    R_interp=R_interp.';

    %Inform RGb array.
    for j=1:N
        for i=1:M
            RGB(i,j,1) = R_interp(i,j);
        end
    end
   
    if(mod(m,2)==1)
	%The last row is not calculated because of bayer structure.
	%Inform this row with previous row values
        for i=1:N
            RGB(M,i,1) =RGB(M-1,i,1);
        end
    end
    
    if(mod(n,2)==0)
	%The last column is not calculated because of bayer structure.
	%Inform this column with previous column values.
        for i=1:M
            RGB(i,N,1) =RGB(i,N-1,1);
        end
    end
    
    %Find Blue

    %Create blue's grid 
	[X,Y] =meshgrid(1:2:m,2:2:n);
    
	%Find the blue Bbayer array from xb array
    local_i=1;
    for i=1:2:m
        local_j=1;
        for j= 2:2:n
            Bbayer(local_i,local_j)=xb(i,j);
            local_j = local_j +1;
        end
        local_i = local_i +1;
    end
    
    Bbayer=double(Bbayer);
	%Create resized grid
    [Xg,Yg] =meshgrid(x_scale:x_scale:m,y_scale:y_scale:n);
	%Interpolate values
    B_interp=interp2(X,Y,Bbayer.',Xg,Yg);
    B_interp=B_interp.';
    
	%Inform RGb array.
    for j=1:N
        for i=1:M
            RGB(i,j,3) = B_interp(i,j);
        end
    end
    
    if(mod(m,2)==0)
		%Last row is not calculated
        for i=1:N
            RGB(M,i,3) =RGB(M-1,i,3);
        end	
    end
    
    if(mod(n,2)==1)
        for i=1:M
            RGB(i,N,3) =RGB(i,N-1,3);
        end
    end
    
	%For image enlarging, there are pixels that there is no information to calculate them.
	%So the blue color is the same with the fisrt calculated row or column
        if (x_scale<=1)
		for i= 1:1:floor(2/x_scale)-0.01
			for j= 1:1:N
				RGB(i,j,1) = RGB(2,j,1);
                RGB(i,j,3) = RGB(2,j,3);
			end
		end
    end
    
    if (y_scale<=1)
	for j= 1:1:floor(2/y_scale) -0.01
		for i= 1:1:M
			RGB(i,j,1) = RGB(i,2,1);
            RGB(i,j,3) = RGB(i,2,3);
		end
	end
    end
    
    %Find  Green
    
    for j=1:N
        for i=1:M
            
			%For image enlarging, there are pixels that there is no information to calculate them
			% So the rgb color is the same with the fisrt calculated row or column
            x = i*x_scale;
            if (x<1)
                    x=1;
            end
            y = j*y_scale;
            if (y<1)
                y=1;
            end
            
            %nodes = pixels
            nodes{1} = [floor(x) floor(y)];
            nodes{2} = [floor(x) floor(y)+1];
            nodes{3} = [floor(x)+1 floor(y)];
            nodes{4} = [floor(x)+1 floor(y)+1];
            
            %for array limit case
            if(x==m || y==n)
                for k=1:4
                    if(nodes{k}(1)>m)
                        nodes{k}(1) = m-1;
                    end
                    if(nodes{k}(2)>n)
                        nodes{k}(2) = n-1;
                    end
                end
            end

            %Check if pixel is green
            is_green =0;
            if ((mod(x,2)==1 && mod(y,2)==1) || (mod(x,2)==0 && mod(y,2)==0) )
                RGB(i,j,2) = xb(x,y);
                is_green =1;
            end    
            
            limit=0;
            
            if ((x<=2 || y<=2 ||x>=m-1 || y>=n-1) && is_green ==0)
                 %From image limit's do nearest neigbour interpolation 
                 minG=2;
                for k=1:4
                    if(color(nodes{k}(1),nodes{k}(2))=='g')
                        %find the minimum distance
                        dis = sqrt((x-nodes{k}(1))^(2) +(y-nodes{k}(2))^(2));
                        if (dis<minG)
                            minG = dis;
                             RGB(i,j,2) = xb(nodes{k}(1),nodes{k}(2));
                        end
                    end  
                end
                limit=1;    
            end
            
            if(is_green ==0 && limit==0)
                
                minPos =1;
                mindis = 2; %In a square maximum distance between nodes is sqrt(2).
				%find which of blue or red pixel is nearest
                for k=1:4
                    if(color(nodes{k}(1), nodes{k}(2))=='r' || color(nodes{k}(1), nodes{k}(2))=='b')

                            dis = sqrt((x-nodes{k}(1))^(2) +(y-nodes{k}(2))^(2));
                            if (dis<mindis)
                                mindis = dis;
                                minPos = k;
                          end
                    end
                end
                
                centerNode = nodes{minPos}.';
                
                %There are four green nodes around center node
                A = centerNode(1);
                B = centerNode(2);
				
				%The method is to rotate the coordinates 45 degrees.
                green{1} = [A;B-1]; %Left pixel
                green{2} = [A-1;B];	%Up pixel
                green{3} = [A;B+1];	%Right pixel
                green{4} = [A+1;B];	%Down pixel
                
                dis1 = sqrt((A-x)^(2) +(B-1-y)^(2));
                dis4 = sqrt((A+1-x)^(2) +(B-y)^(2));
				
				%Solve the system :  x^2 +y^2 = dis1^2
				%					(x-sqrt(2))^2 +y^2 = dis4^2
				%					 x,y>0
                x_t = ((dis1)^2 -(dis4)^2 +2)/(2*sqrt(2));
                y_t = sqrt(dis1^2 - x_t^2);
				
				%Bilinear method as it is described in Wikipedia.
                fR1 = ((sqrt(2)-x_t)/sqrt(2))*xb(green{1}(1),green{1}(2)) + (x_t/sqrt(2))* xb(green{4}(1),green{4}(2));
                
                fR2 = ((sqrt(2)-x_t)/sqrt(2))*xb(green{2}(1),green{2}(2)) + (x_t/sqrt(2))* xb(green{3}(1),green{3}(2));

               RGB(i,j,2)= (sqrt(2)-abs(y_t))*fR1/sqrt(2) + abs(y_t)*fR2/sqrt(2); 
                  
            end
        end
    end
end
%Convert to uint8 
xc = uint8(RGB);

end


