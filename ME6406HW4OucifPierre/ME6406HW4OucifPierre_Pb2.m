%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%% Pierre Oucif - HW4 - Problem 2 %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Part I %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sample=(zeros(100,200,3));
sample(:,1:100,1)=225;
sample(:,1:100,2)=88;
sample(:,1:100,3)=96;
sample(:,101:200,1)=149;
sample(:,101:200,2)=135;
sample(:,101:200,3)=134;
D_h=zeros(1,9); % Vector to stock the distance between Target/Noise
[h123,D_h(1)]=ACC(sample,1,2,3);% We perform the ACC transformation
[h12c,D_h(2)]=ACC(sample,1,2,'c');
[h1b3,D_h(3)]=ACC(sample,1,'b',3);
[h1bc,D_h(4)]=ACC(sample,1,'b','c');
[ha23,D_h(5)]=ACC(sample,'a',2,3);
[ha2c,D_h(6)]=ACC(sample,'a',2,'c');
[hab3,D_h(7)]=ACC(sample,'a','b',3);
[habc,D_h(8)]=ACC(sample,'a','b','c');
% Computation of the distance Target/noise of the initial sample
D_h(9)=round(sqrt((sample(1,1,1)-sample(1,size(sample,2),1))^2+(sample(1,1,2)-sample(1,size(sample,2),2))^2+(sample(1,1,3)-sample(1,size(sample,2),3))^2));

Target_Noise=zeros(8,6); % Matrix to stock the values of the taret and noise after the ACC transformation
Target_Noise(1,:)=Color(h123); % The function Color gives us the RGB values of the Target and Noise
Target_Noise(2,:)=Color(h12c);
Target_Noise(3,:)=Color(h1b3);
Target_Noise(4,:)=Color(h1bc);
Target_Noise(5,:)=Color(ha23);
Target_Noise(6,:)=Color(ha2c);
Target_Noise(7,:)=Color(hab3);
Target_Noise(8,:)=Color(habc);

delta=130; % We add an offset delta to each RGB component to make each transformations visible 
Delta=zeros(size(sample,1),size(sample,2),3);
for i=1:3
    Delta(:,:,i)=delta;
end

% We plot the initial sample and each resulting images
figure(1)
subplot(3,3,1)
imshow(uint8(sample))
title('Sample')
subplot(3,3,2)
imshow(uint8(h123+Delta))
title('1-2-3')
subplot(3,3,3)
imshow(uint8(h12c+Delta))
title('1-2-c')
subplot(3,3,4)
imshow(uint8(h1b3+Delta))
title('1-b-3')
subplot(3,3,5)
imshow(uint8(h1bc+Delta))
title('1-b-c')
subplot(3,3,6)
imshow(uint8(ha23+Delta))
title('a-2-3')
subplot(3,3,7)
imshow(uint8(ha2c+Delta))
title('a-2-c')
subplot(3,3,8)
imshow(uint8(hab3+Delta))
title('a-b-3')
subplot(3,3,9)
imshow(uint8(habc+Delta))
title('a-b-c')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Part II %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
chicken_image=imread('Chicken.jpg');
% Size of the subplot
n=2;
p=3;
figure(2)
subplot(n,p,1)
imshow(chicken_image)
title('Initial image')
image=rgb2lab(chicken_image); % Conversion from RGB to Lab space
ab=zeros(size(image,1)*size(image,2),2); % Vector composed by all (a,b) points from the image

for i=1:size(image,1)
    ab((i-1)*size(image,2)+1:i*size(image,2),1)=image(i,:,2);
    ab((i-1)*size(image,2)+1:i*size(image,2),2)=image(i,:,3);
end

ka=kmeans(ab,3,'replicate',10); % K-means clustering of the points (a,b) 
subplot(n,p,2)
plot(ab(ka==1,1),ab(ka==1,2),'r+') % Plot of the first cluster
title('Clusters of the Lab datas on the a-b domain')
hold on
plot(ab(ka==2,1),ab(ka==2,2),'b+') % Plot of the second cluster
plot(ab(ka==3,1),ab(ka==3,2),'g+') % Plot of the third cluster
legend('Cluster 1','Cluster 2','Cluster 3')

Cluster1=uint8(zeros(size(image,1),size(image,2),3));
Cluster2=uint8(zeros(size(image,1),size(image,2),3));
Cluster3=uint8(zeros(size(image,1),size(image,2),3));
RGB=zeros(size(image,1),size(image,2));

for i=1:size(image,1)
    RGB(i,:)=ka((i-1)*size(image,2)+1:i*size(image,2)); % K-means cluster on the 2D image
end

for i=1:size(image,1)
    for j=1:size(image,2)
        if RGB(i,j)==1
            Cluster1(i,j,:)=chicken_image(i,j,:); % We keep the image RGB components for the first cluster
        end
        if RGB(i,j)==2
            Cluster2(i,j,:)=chicken_image(i,j,:); % We keep the image RGB components for the second cluster
        end
        if RGB(i,j)==3
            Cluster3(i,j,:)=chicken_image(i,j,:); % We keep the image RGB components for the third cluster
        end
    end
end
A=[1 1 1;1 1 1;1 1 1];
Cluster1=imerode(Cluster1,A); % Erode the cluster 1 to reduce the noise
Cluster2=imerode(Cluster2,A); % Erode the cluster 2 to reduce the noise
Cluster3=imerode(Cluster3,A); % Erode the cluster 3 to reduce the noise
subplot(n,p,3)
imshow(Cluster1)
title('Image from the Cluster #1 after the erosion')
subplot(n,p,4)
imshow(Cluster2)
title('Image from the Cluster #2 after the erosion')
subplot(n,p,5)
imshow(Cluster3)
title('Image from the Cluster #3 after the erosion')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Part III %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
image=double(imread('Chicken.jpg'));
% Extraction of the RGB components of the initial image
R=image(:,:,1);
G=image(:,:,2);
B=image(:,:,3);
R_average=0;
G_average=0;
B_average=0;
N=0;
% Computation of the RGB average values
for i=1:size(image,1)
    for j=1:size(image,2)
        N=N+1;
        R_average=R_average+R(i,j);
        G_average=G_average+G(i,j);
        B_average=B_average+B(i,j);
    end
end
R_average=R_average/N;
G_average=G_average/N;
B_average=B_average/N;
RGB_average=[R_average G_average B_average];

% Transformation of the R,G and B matrices into a vector Nx3 
RGB=zeros(size(image,1)*size(image,2),3);
for i=1:size(image,1)
    RGB((i-1)*size(image,2)+1:i*size(image,2),1)=image(i,:,1);
    RGB((i-1)*size(image,2)+1:i*size(image,2),2)=image(i,:,2);
    RGB((i-1)*size(image,2)+1:i*size(image,2),3)=image(i,:,3);
end

C1=(RGB')*RGB/N^2; % Computation of the covariance using the class notes equation
C2=cov(RGB); % Computation of the covariance using the Matlab function
[V1,E1]=eig(C1); % Computation of the eigenvalues and eigenvectors
[V2,E2]=eig(C2); % Computation of the eigenvalues and eigenvectors
% These values are almost the same for the two covariance

% We sort in descending order the eigenvalues and so the corresponding
% eigenvectors
V=V1;
order=sort(diag(E1),'descend');
ini_eig=diag(E1);
for i=1:3
    for j=1:3
    if order(i)==ini_eig(j)
        V(:,i)=V1(:,j);
    end
    end
end

Y1=(V')*RGB'; % Transformation from RGB space to PCA space
Y1=Y1';

for i=1:3
    Y1(:,i)=Y1(:,i)-RGB_average(i); % We remove the RGB average
    Y1(:,i)=255*(Y1(:,i)-min(Y1(:,i)))/(max(Y1(:,i))-min(Y1(:,i))); % We scale the PCA values in order to be able to see the resulting images
end
    
Result=image;
% We transform the Nx3 Y1 vector into an image
for i=1:size(image,1)
    Result(i,:,1)=Y1((i-1)*size(image,2)+1:i*size(image,2),1);
    Result(i,:,2)=Y1((i-1)*size(image,2)+1:i*size(image,2),2);
    Result(i,:,3)=Y1((i-1)*size(image,2)+1:i*size(image,2),3);
end

% We plot each results
figure(3)
subplot(2,2,1)
imshow(uint8(image))
title('Initial image')
subplot(2,2,2)
imshow(uint8(Result(:,:,1)))
title('PCA First component')
subplot(2,2,3)
imshow(uint8(Result(:,:,2)))
title('PCA Second component')
subplot(2,2,4)
imshow(uint8(Result(:,:,3)))
title('PCA Third component')