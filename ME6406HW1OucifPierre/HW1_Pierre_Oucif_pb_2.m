clear
%Question a
image=[113 112 110 109 111 112 112 113;114 111 107 104 103 105 107 112;118 115 110 104 101 102 105 111;119 120 114 107 104 103 104 107;119 122 118 111 106 105 105 106; 126 122 125 125 120 113 109 107];
original_image=uint8(image); 

histogram(original_image);
[nb_pixel,gray_level]=imhist(original_image); %get the informations to realize the histrogram equalization
C_hist=zeros(length(nb_pixel),1);


C_hist(1)=gray_level(1);

for i =2:length(nb_pixel)
   C_hist(i)=C_hist(i-1)+nb_pixel(i);
end

q_k=zeros(length(nb_pixel),1);
round_q_k=zeros(length(nb_pixel),1);

for i=1:length(nb_pixel)
    q_k(i)=C_hist(i)*max(gray_level)/(length(original_image)*length(original_image));
    round_q_k(i)=round(q_k(i));
end

processed_image=original_image;
for x=1:size(original_image,1)
    for y=1:size(original_image,2)
        for i=1:length(nb_pixel)
            if original_image(x,y)==i
                processed_image(x,y)=round_q_k(i);
            end
        end
    end
end

figure(1)
subplot(1,2,1)
imshow(original_image)
title('Original image')
subplot(1,2,2)
imshow(processed_image)
title('Processed image')

%Question b : we use the previous script code to make the histogram
%equalization%
original_image=imread('F15_pollen.bmp');
[nb_pixel,gray_level]=imhist(original_image);
C_hist=zeros(length(nb_pixel),1);

C_hist(1)=gray_level(1);

for i =2:length(nb_pixel)
   C_hist(i)=C_hist(i-1)+nb_pixel(i);
end

q_k=zeros(length(nb_pixel),1);
round_q_k=zeros(length(nb_pixel),1);

for i=1:length(nb_pixel)
    q_k(i)=C_hist(i)*max(gray_level)/(length(original_image)*length(original_image));
    round_q_k(i)=round(q_k(i));
end

processed_image=original_image;
for x=1:length(original_image)
    for y=1:length(original_image)
        for i=1:length(nb_pixel)
            if original_image(x,y)==i
                processed_image(x,y)=round_q_k(i);
            end
        end
    end
end

figure(2)
subplot(2,2,1)
imhist(original_image)
title('Histogram of the original image')
subplot(2,2,2)
imhist(processed_image)
title('Histogram of the processed image')
subplot(2,2,3)
imshow(original_image)
title('Display of the orginal image')
subplot(2,2,4)
imshow(processed_image)
title('Display of the processed image')