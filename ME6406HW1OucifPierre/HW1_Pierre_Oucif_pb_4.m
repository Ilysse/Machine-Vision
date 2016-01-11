clear
%Question a)
original_image=imread('F15_nut-shell.bmp');


x_max=size(original_image,1);
y_max=size(original_image,2);

threshold=zeros(1,3);
threshold(1)=12/255;
threshold(2)=75/255;
threshold(3)=180/255;
image_thrs_1=zeros(x_max,y_max);
image_thrs_2=zeros(x_max,y_max);
image_thrs_3=zeros(x_max,y_max);
pixel_threshold=0;

for x=1:x_max
    for y=1:y_max
        pixel_threshold = double(original_image(x,y))/255;
        if pixel_threshold >= threshold(1)
            image_thrs_1(x,y)=1; %Binarization with respect to threshold 1
        end
        if pixel_threshold >= threshold(2)
            image_thrs_2(x,y)=1; %Binarization with respect to threshold 2
        end
        if pixel_threshold >= threshold(3)
            image_thrs_3(x,y)=1; %Binarization with respect to threshold 3
        end
    end
end

x_line_1=threshold(1)*255;
x_line_2=threshold(2)*255;
x_line_3=threshold(3)*255;
y_line=60000;

figure(1);
subplot(2,2,1)
histogram(original_image);
title('Histogram of the original image');
hold all
l1=line([x_line_1 x_line_1],[0 y_line],'Color','r');
l2=line([x_line_2 x_line_2],[0 y_line],'Color','g');
l3=line([x_line_3 x_line_3],[0 y_line],'Color','y');
legend([l1,l2,l3],'Threshold #1','Threshold #2','Threshold #3')
subplot(2,2,2)
imshow(image_thrs_1);
title('Threshold #1');
subplot(2,2,3)
imshow(image_thrs_2);
title('Threshold #2');
subplot(2,2,4)
imshow(image_thrs_3);
title('Threshold  #3');

%Question b)

area_nut=0;
area_shell=0;
image_nut=zeros(size(original_image,1),round(size(original_image,2)/2));
image_shell=zeros(size(original_image,1),round(size(original_image,2)/2));

for i=1:size(original_image,1)
    for j=1:round(size(original_image,2)/2)
            image_nut(i,j)=image_thrs_2(i,j);% Cut the original image into two image to separate the two objects
    end
    for j=(round(size(original_image,2)/2)+1):(size(original_image,2))
            image_shell(i,j-(round(size(original_image,2)/2)))=image_thrs_2(i,j);% Cut the original image into two image to separate the two objects
    end
end

for i=1:size(image_nut,1)
    for j=1:size(image_nut,2)
        if image_nut(i,j)==0
            area_nut=area_nut+1;% Area determination (black pixels/all pixels)
        end
    end
end

for i=1:size(image_shell,1)
    for j=1:size(image_shell,2)
        if image_shell(i,j)==0
            area_shell=area_shell+1;% Area determination (black pixels/all pixels)
        end
    end
end

area_shell_p=100*area_shell/(size(image_shell,1)*size(image_shell,2));
area_nut_p=100*area_nut/(size(image_nut,1)*size(image_nut,2));

nb_pixel_nut=0;
x_centroid_nut=0;
y_centroid_nut=0;

for x=1:size(image_nut,1)
    for y=1:size(image_nut,2)
        if image_nut(x,y)==0
            x_centroid_nut=x_centroid_nut+x;% Determination of the centroid (barycenter calculation)
            y_centroid_nut=y_centroid_nut+y;% Determination of the centroid (barycenter calculation)
            nb_pixel_nut=nb_pixel_nut+1;
        end
    end
end
x_centroid_nut=round(x_centroid_nut/nb_pixel_nut);
y_centroid_nut=round(y_centroid_nut/nb_pixel_nut);

x_centroid_shell=0;
y_centroid_shell=0;
nb_pixel_shell=0;

for x=1:size(image_shell,1)
    for y=1:size(image_shell,2)
        if image_shell(x,y)==0
            x_centroid_shell=x_centroid_shell+x;% Determination of the centroid (barycenter calculation)
            y_centroid_shell=y_centroid_shell+y;% Determination of the centroid (barycenter calculation)
            nb_pixel_shell=nb_pixel_shell+1;
        end
    end
end
x_centroid_shell=round(x_centroid_shell/nb_pixel_shell);
y_centroid_shell=round(y_centroid_shell/nb_pixel_shell);


figure(2);
subplot(1,2,1)
imshow(image_nut)
title('image nut')
hold
plot(y_centroid_nut,x_centroid_nut,'+')
hold
subplot(1,2,2)
imshow(image_shell)
title('image shell')
hold
plot(y_centroid_shell,x_centroid_shell,'+')
hold

Hx=[-1 -2 -1 ; 0 0 0 ; 1 2 1];% x-Sobel operator
Hy=[-1 0 1 ; -2 0 2 ; -1 0 1];% y-Sobel operator

Gx=zeros(size(image_thrs_2,1)-2,size(image_thrs_2,2)-2);
Gy=zeros(size(image_thrs_2,1)-2,size(image_thrs_2,2)-2);
G=zeros(size(image_thrs_2,1)-2,size(image_thrs_2,2)-2);

for x=2:size((image_thrs_2),1)-2
    for y=2:size(image_thrs_2,2)-2
        for i=1:3
            for j=1:3
                Gx(x,y)=Gx(x,y)+Hx(i,j)*double(image_thrs_2(x-2+i,y-2+j));% x gradient
                Gy(x,y)=Gy(x,y)+Hy(i,j)*double(image_thrs_2(x-2+i,y-2+j));% y gradient
            end
        end
        G(x,y)=sqrt(Gx(x,y)^2+Gy(x,y)^2);% gradient magnitude
    end
end

figure(3);
subplot(2,2,1)
imshow(Gx)
title('Display of Gx')
subplot(2,2,2)
imshow(Gy)
title('Display of Gy')
subplot(2,2,3)
imshow(G)
title('Display of G')

Outer_boundaries_nut=zeros(size(image_nut,1),size(image_nut,2));
Outer_boundaries_shell=zeros(size(image_shell,1),size(image_shell,2));
bounded_image=original_image;

for y=1:size(image_nut,2)
    k1=0;
    k2=0;
    for x=1:size(image_nut,1)
        if x<size(image_nut,1)-x+1
            if image_nut(x,y)==0 && k1==0
                 Outer_boundaries_nut(x,y)=1;% x scan
                 k1=1;
            end
            if image_nut(size(image_nut,1)+1-x,y)==0 && k2==0
                 Outer_boundaries_nut(1-x+size(image_nut,1),y)=1;% x scan
                 k2=1;
            end
        end
    end
end
for x=1:size(image_nut,1)
    k1=0;
    k2=0;
    for y=1:size(image_nut,2)
        if y<size(image_nut,2)-y+1
            if image_nut(x,y)==0 && k1==0 && Outer_boundaries_nut(x,y)==0
                 Outer_boundaries_nut(x,y)=1;% y scan
                 k1=1;
            end
            if image_nut(x,size(image_nut,2)-y+1)==0 && k2==0 && Outer_boundaries_nut(x,size(image_nut,2)-y+1)==0
                 Outer_boundaries_nut(x,size(image_nut,2)-y+1)=1;% y scan
                 k2=1;
            end
        end
    end
end            

for y=1:size(image_shell,2)
    k1=0;
    k2=0;
    for x=1:size(image_shell,1)
        if x<size(image_shell,1)-x+1
            if image_shell(x,y)==0 && k1==0
                 Outer_boundaries_shell(x,y)=1;% x scan
                 k1=1;
            end
            if image_shell(size(image_shell,1)+1-x,y)==0 && k2==0
                 Outer_boundaries_shell(1-x+size(image_shell,1),y)=1;% x scan
                 k2=1;
            end
        end
    end
end
for x=1:size(image_shell,1)
    k1=0;
    k2=0;
    for y=1:size(image_shell,2)
        if y<size(image_shell,2)-y+1
            if image_shell(x,y)==0 && k1==0 && Outer_boundaries_shell(x,y)==0
                 Outer_boundaries_shell(x,y)=1;% y scan
                 k1=1;
            end
            if image_shell(x,size(image_shell,2)-y+1)==0 && k2==0 && Outer_boundaries_shell(x,size(image_shell,2)-y+1)==0
                 Outer_boundaries_shell(x,size(image_shell,2)-y+1)=1;% y scan
                 k2=1;
            end
        end
    end
end            


for x=1:size(original_image,1)
    for y=1:size(original_image,2)
        if y<=round(size(original_image,2)/2)
            if Outer_boundaries_nut(x,y)==1% Color change to plot the outer boundaries
                bounded_image(x,y,1)=250;
                bounded_image(x,y,2)=0;
                bounded_image(x,y,3)=0;
            end
        else
            if Outer_boundaries_shell(x,y-round(size(original_image,2)/2))==1 % Color change to plot the outer boundaries
                bounded_image(x,y,1)=250;
                bounded_image(x,y,2)=0;
                bounded_image(x,y,3)=0;
            end
        end
    end
end

figure(4)
imshow(bounded_image)
title('Final image with boudaries and centroids')
hold
plot(y_centroid_nut,x_centroid_nut,'+')% x and y are inversed (image axis different from the plot axis)
plot(y_centroid_shell+round(size(original_image,2)/2),x_centroid_shell,'+')% x and y are inversed (image axis different from the plot axis)

        
        
  


            