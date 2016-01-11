%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%% Pierre Oucif - HW4 - Problem 3 %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% a) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n=50;
L=4*n;

A=zeros(3*L+2,3*L+2);
B1=zeros(L+2,L/4+2);
B2=zeros(3*L/4+2,3*L/4+2);
B3=zeros(L/2+2,L/2+2);
B4=zeros(L+2,L+2);

% We create the 5 structures

for i=1:size(A,1)
    for j=1:size(A,2)
        if i>1 && i<size(A,1)
            if j>L+1 && j<2*L
                A(i,j)=1;
            end
        end
        if j>1 && j<size(A,2)
            if i>L+1 && i<2*L
                A(i,j)=1;
            end
        end
    end
end
for i=1:size(B1,1)
    for j=1:size(B1,2)
        if i>1 && i<size(B1,1)
          if j>1 && j<size(B1,2)
              B1(i,j)=1;
          end
        end
    end
end
for i=1:size(B2,1)
    for j=1:size(B2,2)
        if i>1 && i<size(B2,1)
            if j>L/4 && j<L/2
                B2(i,j)=1;
            end
        end
        if j>1 && j<size(B2,2)
            if i>L/4 && i<L/2
                B2(i,j)=1;
            end
        end
    end
end        
for i=1:size(B3,1)
    for j=1:size(B3,2)
        if i>1 && i<size(B3,1)
          if j>1 && j<size(B3,2)
              B3(i,j)=1;
          end
        end
    end
end      
for i=1:size(B4)
    for j=1:size(B4)
        if (i-L/2-1)^2+(j-L/2-1)^2<=(L/2)^2 % Equation of a circle
            B4(i,j)=1;
        end
    end
end
% Plot of the 5 structures
figure(1)
subplot(2,3,1)
imshow(A);
title('A')
subplot(2,3,2)
imshow(B1)
title('B1')
subplot(2,3,3)
imshow(B2)
title('B2')
subplot(2,3,4)
imshow(B3)
title('B3')
subplot(2,3,5)
imshow(B4)
title('B4')

% Morphological operations
% We use the Morphological Matlab function
Image11=imdilate(imerode(A,B4),B2);
Image12=imdilate(imerode(A,B1),B3);
Image13=imdilate(imdilate(A,B1),B3);
Image14=imerode(imdilate(A,B3),B2);

% We plot the results
figure(2)
subplot(2,2,1)
imshow(Image11)
title('(A -O B4)+O B2')
subplot(2,2,2)
imshow(Image12)
title('(A -O B1)+O B3')
subplot(2,2,3)
imshow(Image13)
title('(A +O B1)+O B3')
subplot(2,2,4)
imshow(Image14)
title('(A +O B3)+O B2')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% b) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

A=imread('Fingerprint.jpg');
B=[1 1 1;1 1 1;1 1 1]; % Structuring element
% Morphological filtering by using the scructure element on the image
Image21=imerode(A,B);
Image22=imdilate(imerode(A,B),B);
Image23=imdilate(imdilate(imerode(A,B),B),B);
Image24=imerode(imdilate(imdilate(imerode(A,B),B),B),B);

% We plot the results
figure(3)
subplot(2,2,1)
imshow(Image21)
title('A -O B')
subplot(2,2,2)
imshow(Image22)
title('(A -O B) +O B')
subplot(2,2,3)
imshow(Image23)
title('((A -O B) +O B) +O B')
subplot(2,2,4)
imshow(Image24)
title('(((A -O B) +O B) +O B) +O B')












