clear
%Question a)
Hx=[-1 -2 -1 ; 0 0 0 ; 1 2 1]; %Sobel operator
Hy=[-1 0 1 ; -2 0 2 ; -1 0 1]; %Sobel operator
Z=[119 120 114 ; 119 122 118 ; 126 122 125]; 
Gx=0;
Gy=0;


for i=1:3
    for j=1:3
        Gx=Gx+Hx(i,j)*Z(i,j); %Convolution
        Gy=Gy+Hy(i,j)*Z(i,j); %Convolution
    end
end

G=sqrt(Gx^2+Gy^2); %Magnitude of the gradient
theta=180*atan(Gy/Gx)/pi; %Angle of the gradient

original_image=imread('F15_checker.bmp');


Gx=zeros(length(original_image)-2,length(original_image)-2);% "-2" to avoid the edges of the image
Gy=zeros(length(original_image)-2,length(original_image)-2);% "-2" to avoid the edges of the image
G=zeros(length(original_image)-2,length(original_image)-2);% "-2" to avoid the edges of the image

for x=2:length(original_image)-2
    for y=2:length(original_image)-2
        for i=1:3
            for j=1:3
                Gx(x,y)=Gx(x,y)+Hx(i,j)*double(original_image(x-2+i,y-2+j));%Convolution at each pixels with x-Sobel operator
                Gy(x,y)=Gy(x,y)+Hy(i,j)*double(original_image(x-2+i,y-2+j));%Convolution at each pixels with y-Sobel operator
            end
        end
        G(x,y)=sqrt(Gx(x,y)^2+Gy(x,y)^2);%Magnitude ot the gradient at each pixels
    end
end

figure(1);
subplot(2,2,1)
imshow(Gx)
title('Display of Gx')
subplot(2,2,2)
imshow(Gy)
title('Display of Gy')
subplot(2,2,3)
imshow(G)
title('Display of G')
subplot(2,2,4)
imshow(edge(original_image,'sobel'))
title('Display of G using Matlab edge() function')

%Question b)

mask_size=0.8;%Mask size
x=(-5:mask_size:5);
y=(-5:mask_size:5);
sigma=[1 2 5];
G1=zeros(length(x),length(y));
G2=zeros(length(x),length(y));
G3=zeros(length(x),length(y));
DG=zeros(length(x),length(y));

for i=1:length(x)
    for j=1:length(y)
            G1(i,j)=exp(-(x(i)^2+y(j)^2)/(2*sigma(1)))/(sigma(1)*(2*pi));
            G2(i,j)=exp(-(x(i)^2+y(j)^2)/(2*sigma(2)))/(sigma(2)*(2*pi));
            G3(i,j)=exp(-(x(i)^2+y(j)^2)/(2*sigma(3)))/(sigma(3)*(2*pi));
            DG(i,j)=G1(i,j)-G2(i,j);%Difference between two Gaussian
    end
end

figure(2);
subplot(1,3,1)
mesh(G1)
title('Gaussian function for sigma = 1')
subplot(1,3,2)
mesh(G2)
title('Gaussian function for sigma = 2')
subplot(1,3,3)
mesh(G3)
title('Gaussian function for sigma = 5')
image_to_smooth=imread('F15_salt-pep-checker.bmp');

%Question d)

smooth_image_G1=imfilter(image_to_smooth,G1);%Smooth image with a Gaussian
smooth_image_G2=imfilter(image_to_smooth,G2);%Smooth image with a Gaussian
smooth_image_G3=imfilter(image_to_smooth,G3);%Smooth image with a Gaussian

figure(3);
subplot(1,3,1)
imshow(smooth_image_G1)
title('Smooth image with sigma = 1')
subplot(1,3,2)
imshow(smooth_image_G2)
title('Smooth image with sigma = 2')
subplot(1,3,3)
imshow(smooth_image_G3)
title('Smooth image with sigma = 5')

%Question e)

DoG=imfilter(smooth_image_G1,DG);%Edge detection by using DG difference between two Gaussian
%Histogram equalization to well visualize the edges
[nb_pixel,gray_level]=imhist(DoG);
C_hist=zeros(length(nb_pixel),1);

C_hist(1)=gray_level(1);

for i =2:length(nb_pixel)
   C_hist(i)=C_hist(i-1)+nb_pixel(i);
end

q_k=zeros(length(nb_pixel),1);
round_q_k=zeros(length(nb_pixel),1);

for i=1:length(nb_pixel)
    q_k(i)=C_hist(i)*max(gray_level)/(length(DoG)*length(DoG));
    round_q_k(i)=round(q_k(i));
end

processed_image=DoG;
for x=1:size(DoG,1)
    for y=1:size(DoG,2)
        for i=1:length(nb_pixel)
            if DoG(x,y)==i
                processed_image(x,y)=round_q_k(i);
            end
        end
    end
end

figure(4)
subplot(2,2,1)
imshow(original_image)
title('Original image')
subplot(2,2,2)
imshow(DoG)
title('Edge detections with DoG')
subplot(2,2,3)
histogram(DoG)
title('Histogram of DoG')
xlabel('Gray level')
ylabel('Number of pixels')
subplot(2,2,4)
imshow(processed_image)
title('Porcessed image of DoG')
