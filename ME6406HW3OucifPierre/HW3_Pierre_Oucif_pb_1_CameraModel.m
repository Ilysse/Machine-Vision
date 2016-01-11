clear;
close all;
T=[3 5 10]';%Translation Vector
Rx=[1 0 0;0 cos(pi*150/180) -sin(pi*150/180);0 sin(pi*150/180) cos(pi*150/180)];%Rotation Matrix
P=zeros(20,3);
P_transformed=zeros(20,3);

%%%%%%%%%%%%%%%%%%%%%%%%% Calibration Points %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:6
    P(i,:)=[-2+(i-1) 5 0];
    P(i+6,:)=[-2+(i-1) 4 0];
end
for i=1:4
    P(i+12,:)=[0 3-(i-1) 0];
    P(i+16,:)=[1 3-(i-1) 0];
end
%%%%%%%%%%%%%%%%%%%%%%%%% Camera Points %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:20
    P_transformed(i,:)=(Rx*P(i,:)')+T;
end
%%%%%%%%%%%%%%%%%%%%%% Plot of (Xw,Yw,Zw) & (x,y,z) %%%%%%%%%%%%%%%%%%%%%%%
figure(1)
for i=1:size(P_transformed,1)
    if i==1
        plot3(P(1,1),P(1,2),P(1,3),'r+')
        hold
        plot3(P_transformed(1,1),P_transformed(1,2),P_transformed(1,3),'b+')
    end
    plot3(P(i,1),P(i,2),P(i,3),'r+')
    plot3(P_transformed(i,1),P_transformed(i,2),P_transformed(i,3),'b+')
end
%%%%%%%%%%%%%%%%%%%%%%%%% Image Points %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f=1;
P_image=zeros(size(P,1),2);

for i=1:size(P_image,1)
    P_image(i,1)=f*P_transformed(i,1)/P_transformed(i,3);
    P_image(i,2)=f*P_transformed(i,2)/P_transformed(i,3);
end

%%%%%%%%%%%%%%%%%%%%%% Plot of the Image Points %%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:size(P_transformed,1)
    if i==1
        plot(P_image(1,1),P_image(1,2),'g+')
    end
    plot(P_image(i,1),P_image(i,2),'g+')

end



