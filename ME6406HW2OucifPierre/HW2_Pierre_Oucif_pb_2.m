%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%% Pierre Oucif - HW2 - Problem 2 %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;
close all
image=imread('HW2.bmp');
image_bw=rgb2gray(image);
edge=edge(image_bw,'canny',[0.1 0.2],2);

%%%%%%%%%%%%%%%%%% Question a - Rho-theta method %%%%%%%%%%%%%%%%%%%%%%%%%%

Outer_boundaries=bwlabel(edge);
x_max=size(edge,1);
y_max=size(edge,2);
image_contour=zeros(x_max,y_max);

nb_pixel=0;
x_centroid=0;
y_centroid=0;

for i=1:size(edge,1)
    for j=1:size(edge,2)
        if Outer_boundaries(i,j)==1 % Outer_boundaries(i,j) is equal to 1 on the outer boundaries
            nb_pixel=nb_pixel+1; % Number of points on the outer boundaries
            image_contour(i,j)=1; % Image with just the outer boundaries
            x_centroid=x_centroid+i; % Sum of all x on the outer boundaries
            y_centroid=y_centroid+j; % Sum of all y on the outer boundaries
        end
    end
end
x_centroid=round(x_centroid/nb_pixel); % Arithmetic average of x on the outer boundaries to get the x_centroid of the outer boundaries
y_centroid=round(y_centroid/nb_pixel); % Arithmetic average of y on the outer boundaries to get the y_centroid of the outer boundaries

theta=0:0.01:2*pi;
R_max=sqrt((size(edge,1)/2)^2+(size(edge,2)/2)^2); % The radius cannot be superior to half of the image diagonal
R=1:1:R_max;                                       % to keep a continuous shape in a square
angle=zeros(1,nb_pixel);
magnitude=zeros(1,nb_pixel);
k=0;
x_boundary=zeros(1,nb_pixel);
y_boundary=zeros(1,nb_pixel);

for i=1:size(theta,2)
    for j=1:size(R,2);
        % Determination of all point P(xx,yy) on the outer boundaries in
        % function of the centroid of the outer boundaries and with respect
        % to the distance between the centroid to P (the radius R)
        xx=round(x_centroid+round(R(j)*cos(theta(i)))); 
        yy=round(y_centroid+round(R(j)*sin(theta(i)))); 
        if xx>=1 && xx<=300 && yy<=300 && yy>=1 % We only keep (xx,yy) on [1,300]x[1,300] (to be on the image)
            if Outer_boundaries(xx,yy)==1 % We only keep (xx,yy) on the outer boundaries
                k=k+1;
                % Accumulation of (xx,yy) and corresponding
                % (magnitude,angle) on the inner boundary 
                x_boundary(1,k)=xx;
                y_boundary(1,k)=yy;
                angle(1,k)=theta(i);
                magnitude(1,k)=R(j);
            end
        end
    end
end

Result=zeros(2,6);
for k=1:6
    maximum=0;
    for i=1:size(magnitude,2)
       % We are looking for the local maximums of the magnitude to find the
       % edges. We use the fact that each edges are on different intervals
       % between k*pi/3 and (k+1)*pi/3.
       if angle(i)<=pi*k/3 && angle(i)>=pi*(k-1)/3
           if maximum<magnitude(i);
               maximum=magnitude(i);
               Result(1,k)=x_centroid+magnitude(i)*cos(angle(i));
               Result(2,k)=y_centroid+magnitude(i)*sin(angle(i));
           end
       end
    end
end

subplot(1,2,2)
plot(angle,magnitude,'-'); % Plot of the outer boundaries with rho-theta
xlabel('theta')
ylabel('R')
title('Rho-Theta representation')
figure(1)
subplot(1,2,1)
imshow(edge);
xlabel('x')
ylabel('y')
hold
plot(x_centroid,y_centroid,'r+');
for i=1:size(Result,2)
    plot(Result(1,i),Result(2,i),'y+') % Plot of the edges
end
legend('Centroid of the outer boundaries','Edges of the outer boundaries')



%%%%%%%%%%%%%%%%%% Question b - Curvature method %%%%%%%%%%%%%%%%%%%%%%%%%%

contour_image=contour(image_contour,1);
xs_0=contour_image(1,2:round(size(contour_image,2)/2)+4); % curvilinear x of the outer boundaries
ys_0=contour_image(2,2:round(size(contour_image,2)/2)+4); % curvilinear y of the outer boundaries
xs=zeros(1,size(xs_0,2));
ys=zeros(1,size(ys_0,2));
first_point=100;
xs(1:size(xs,2)-first_point+1)=xs_0(first_point:size(xs_0,2)); % Shift of xs to get the discontinuity away from to consecutive edges
xs(size(xs,2)-first_point+2:size(xs,2))=xs_0(1:first_point-1); % Shift of xs to get the discontinuity away from to consecutive edges
ys(1:size(ys,2)-first_point+1)=ys_0(first_point:size(ys_0,2)); % Shift of ys to get the discontinuity away from to consecutive edges
ys(size(ys,2)-first_point+2:size(ys,2))=ys_0(1:first_point-1); % Shift of ys to get the discontinuity away from to consecutive edges


s=linspace(-round(size(xs,2)/2),round(size(xs,2)/2),round(size(xs,2))); % s is increasing when a point P(s)=[xs(s),ys(s)] is moving on the outer boundaries
sigma=[1,3,5,8];
for i=1:size(sigma,2)
    g=1/sqrt(2*pi*sigma(i)^2)*exp(-s.^2/(2*sigma(i)^2)); % Gaussian functions of sigma parameter
    Xs=conv(xs,g,'same');Xs=Xs(15:size(Xs,2)-15); % Convolution of xs with the Gaussian to smooth the outer boundaries and therefore the corresponding cruvature
    Ys=conv(ys,g,'same');Ys=Ys(15:size(Ys,2)-15); % Convolution of ys with the Gaussian to smooth the outer boundaries and therefore the corresponding cruvature
    if i==1
        % Creation of elements at the first iteration to stock Xs, Ys and K for each sigma in
        % function of the number of sigma
        X=zeros(size(sigma,2),size(Xs,2)); 
        Y=zeros(size(sigma,2),size(Ys,2));
        K0=zeros(size(sigma,2),size(Ys,2));
        K=zeros(size(sigma,2),nb_pixel);
    end
    X(i,1:size(Xs,2))=Xs; % Saving Xs values for one sigma in X
    Y(i,1:size(Xs,2))=Ys; % Saving Ys values for one sigma in Y
    
    dx=zeros(1,size(Xs,2));
    ddx=zeros(1,size(Xs,2));
    dy=zeros(1,size(Ys,2));
    ddy=zeros(1,size(Ys,2));

    dx(1:size(Xs,2)-1)=diff(Xs); % First derivative of Xs with respect to s
    ddx(1:size(Xs,2)-2)=diff(Xs,2); % Second derivative of Xs with respect to s
    dy(1:size(Ys,2)-1)=diff(Ys); % First derivative of Ys with respect to s
    ddy(1:size(Ys,2)-2)=diff(Ys,2); % Second derivative of Ys with respect to s

    K0(i,1:size(K0,2))=ddy.*dx-ddx.*dy; % Computing of the curvature K0 for each sigma values
    K(i,10:nb_pixel)=K0(i,10:nb_pixel); % We ignore the firsts and finals point of the curvature to avoid the discontinuites (which are increased by the convolution with the Gaussian functions)
    
    figure(2)
    subplot(2,size(sigma,2),i)
    plot(X(i,:),Y(i,:)) % Plot of each outer boundaries that we got with the Gaussian smoothing
    xlabel('X')
    ylabel('Y')
    title('Curvilinear parametrization')
    subplot(2,size(sigma,2),i+size(sigma,2))
    plot(K(i,:)) % Plot of the corresponding curvatures
    xlabel('s')
    ylabel('Curvature')
    out = ['K with Gaussian Smoothing (sigma =' int2str(sigma(i)) ')'];
    title(out);
end
[peaks,location]=findpeaks(K(4,:)); % We find the peaks of the curvature which represent the edges of the outer boundaries
peaks_edge=zeros(2,6);
p=1;
for i=1:size(peaks,2)
    if p<=6 && peaks_edge(1,p)<peaks(i) && peaks(i)>0.016 % Threshold to get the local maximus of the curvature
        peaks_edge(1,p)=peaks(i);
        peaks_edge(2,p)=location(i);
        p=p+1;
    end
end

figure(4) % Plot of the outer boundaries with their edges
imshow(edge)
hold
for i=1:6
    plot(Xs(peaks_edge(2,i)),Ys(peaks_edge(2,i)),'r+')
    plot(Result(1,i),Result(2,i),'y+')
end
xlabel('x')
ylabel('y')
title('Edges fund with the curvature method and rho-theta method')
legend('Edges with curvature method','Edges with rho-theta method')


        
    














