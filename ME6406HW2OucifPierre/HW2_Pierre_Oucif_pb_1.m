%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%% Pierre Oucif - HW2 - Problem 1 %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
close all
image=imread('HW2.bmp');
image_bw=rgb2gray(image);
edge=edge(image_bw,'canny',[0.1 0.2],2);

[Gy,Gx]=imgradientxy(image_bw);
boundaries=bwlabel(edge);
nb_pixel=0;
for x=1:size(edge,1)
    for y=1:size(edge,2)
        if boundaries(x,y)==1 % Determination of pixel of the outer boundaries
            nb_pixel=nb_pixel+1;
        end
    end
end


a_min=-100;
a_max=300;
nb_a=a_max-a_min;
b_min=-100;
b_max=300;
nb_b=b_max-b_min;
A1=zeros(nb_a,nb_b);

Result_array=zeros(nb_pixel,2);
nb=0;

for x=1:size(edge,1)
    for y=1:size(edge,2)
        if boundaries(x,y)==1 % For each point on the outer boundaries
                nb=nb+1;
                nu=(x*Gx(x,y)+y*Gy(x,y))/(Gx(x,y)^2+Gy(x,y)^2);
                x0=nu*Gx(x,y);
                y0=nu*Gy(x,y);
                Result_array(nb,1)=x0; % Accumulation of x0 values in a n-2 array called Result_array
                Result_array(nb,2)=y0; % Accumulation of y0 values in a n-2 array called Result_array
                
                if (x0<=a_max) && (x0>=a_min) && (y0>=b_min) && (y0<=b_max)
                    A1(round(x0)-a_min,round(y0)-b_min)=A1(round(x0)-a_min,round(y0)-b_min)+1; % Accumulated Matrix
                end
        end

    end
end

cluster=kmeans(Result_array,6,'replicates', 10); % Using k-means method to find an average of each couple (a,b)
XY=zeros(6,2);

for i=1:6
    k=0;
    a=0;
    b=0;
    for j=1:size(Result_array,1)
        if cluster(j)==i
            a=a+Result_array(j,1); % Sum of each x0 of the same cluster
            b=b+Result_array(j,2); % Sum of each y0 of the same cluster
            k=k+1; % Number of element of one cluster
        end
        if k>0
            XY(i,1)=a/k; % Arithmetic average of x0 in one cluster
            XY(i,2)=b/k; % Arithmetic average of y0 in one cluster
        end
    end
end


Edge_intersections=zeros(2,20);
n=0;

for i=1:size(XY,1)
    for j=1:size(XY,1)
        if i~=j
            n=n+1;
            a1=-XY(i,1)/XY(i,2); % Relationship between a and (x0,y0)
            a2=-XY(j,1)/XY(j,2); % Relationship between a and (x0,y0)
            b1=(XY(i,2)^2+XY(i,1)^2)/XY(i,2); % Relationship between b and (x0,y0)
            b2=(XY(j,2)^2+XY(j,1)^2)/XY(j,2); % Relationship between b and (x0,y0)
            
            % We find the intersection between each straight lines defined
            % by (a1,b1) and (a2,b2) over [20;300]x[20;300] 
            if round((b2-b1)/(a1-a2))<=300 && round((b2-b1)/(a1-a2))>=20 && round(a1*(b2-b1)/(a1-a2)+b1)<=300 && round(a1*(b2-b1)/(a1-a2)+b1)>=20
                Edge_intersections(1,n)=round((b2-b1)/(a1-a2));
                Edge_intersections(2,n)=round(a1*(b2-b1)/(a1-a2)+b1);
           end
        end
    end
end

xx=1:1:300;

figure(1)
imagesc(A1) % Plot of the accumulated matrix
title('Accumulated Matrix')
xlabel('x0')
ylabel('y0')
figure(2)
subplot(1,2,1)
scatter(Result_array(:,1),Result_array(:,2)); % Plot of the clusters with theirs centroid values.
xlabel('x0')
ylabel('y0')
title('Hough transform with clustering')
hold
for i=1:6
    plot(XY(i,1),XY(i,2),'r+') % Plot of the intersection of each straight lines fund with the Hough transform.
end
legend('(x0,y0)','Clusters')
subplot(1,2,2)
imshow(edge);
hold

for i=1:size(XY,1)
    yy=(XY(i,2)^2+XY(i,1)^2)/XY(i,2)-xx*XY(i,1)/XY(i,2); % Plot of all straight lines fund with the Hough transform.
    plot(xx,yy,'y')
end

for i=1:size(Edge_intersections,2)
    plot(Edge_intersections(1,i),Edge_intersections(2,i),'r+')
end


R=1:1:max(size(edge,1),size(edge,2));
A2=zeros(size(edge,1),size(edge,2),size(R,2));
[Gy,Gx]=imgradientxy(edge);

c=0;
for k=1:size(R,2)
    for x=1:size(edge,1)
        for y=1:size(edge,2)
             if boundaries(x,y)==2 % boundaries(x,y) is equal to 2 when we are on the inner boudary which is the circle.
                xc=round(x-R(k)*Gx(x,y)/sqrt(Gx(x,y)^2+Gy(x,y)^2)); % Determination of x_center of the circle using Hough Transform for a circle
                yc=round(y-R(k)*Gy(x,y)/sqrt(Gx(x,y)^2+Gy(x,y)^2)); % Determination of y_center of the circle using Hough Transform for a circle
                if xc>0 && xc<=size(edge,1) && yc>0 && yc<=size(edge,2) % We only keep the (xc,yc) which are on the image.
                    A2(xc,yc,k)=A2(xc,yc,k)+1; % Accumulated matrix 
                    if c<A2(xc,yc,k) % Finding the maximum value of the accumulated matrix with corresponding (xc,yc) and R.
                        c=A2(xc,yc,k);
                        x_centroid=xc; 
                        y_centroid=yc;
                        R_centroid=R(k);
                    end
                end
             end
        end
    end
end

angle=0:0.01:2*pi;
x_circle=x_centroid+R_centroid*cos(angle); % (rho,theta) => (x,y)
y_circle=y_centroid+R_centroid*sin(angle); % (rho,theta) => (x,y)

figure(3) % Plot of the circle fund previously with Hough Transform.
imshow(edge);
hold
plot(x_centroid,y_centroid,'r+');
plot(x_circle,y_circle,'r');
legend('Center','Inner boudary')



                    
                
                    
                    
                    
                    
                    
                    
                    