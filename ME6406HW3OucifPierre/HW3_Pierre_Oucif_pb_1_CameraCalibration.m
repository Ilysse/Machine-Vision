clear;
close all;

Points=load('HW3_Pierre_Oucif_pb_1_camera_calibration_data.mat');% Loading of the data points from question a)
XYZ=Points.P;% Global Points
xyz=Points.P_transformed;% Camera Points
uv=Points.P_image;% Image Points


A=zeros(20,5);
b=uv(:,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%% Stage 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:20 % Writting of the matrix A to get relationships between XYZ,uv & T
    A(i,:)=[XYZ(i,1)*uv(i,2) XYZ(i,2)*uv(i,2) -XYZ(i,1)*uv(i,1) -XYZ(i,2)*uv(i,1) uv(i,2)];
end


mu=round(A\uv(:,1),6);% We solve [A].mu=b
% Recuperation of the results from the solving
mu11=mu(1);
mu12=mu(2);
mu21=mu(3);
mu22=mu(4);
T_xy=mu(5);
U=mu11^2+mu12^2+mu21^2+mu22^2;
% Computation of Ty with a test on the values of mu11,mu12,m21 & mu22
if mu11*mu22==mu12*mu21
    Ty2=(1/U);
else
    Ty2=((U-sqrt(U^2-4*(mu11*mu22-mu12*mu21)^2))/(2*(mu11*mu22-mu12*mu21)^2));
end


s1=1;
s2=1;
% We take Ty=+sqrt(Ty^2) & s1=1,s2=2 and so we have to check the sign of
% Ty, r13 and r23
Ty=sqrt(Ty2);
Tx=T_xy*Ty;
r11=mu11*Ty;
r12=mu12*Ty;
r13=s1*sqrt(1-r11^2-r12^2);
r21=mu21*Ty; 
r22=mu22*Ty;
r23=s2*sqrt(1-r21^2-r22^2);

a1=r11*XYZ(1,1)+r12*XYZ(1,2)+Tx;
a2=r21*XYZ(1,1)+r22*XYZ(1,2)+Ty;

% Test to get the sign of Ty
if sign(uv(1,1))~=sign(a1) || sign(uv(1,2))~=sign(a2)
    Ty=-Ty;
    Tx=T_xy*Ty;
    r11=round(mu11*Ty,6);
    r12=round(mu12*Ty,6);
    r13=round(s1*sqrt(1-r11^2-r12^2),6);
    r21=round(mu21*Ty,6); 
    r22=round(mu22*Ty,6);
    r23=s2*round(sqrt(1-r21^2-r22^2),6);
end

% Test for the sign of r13 and r23 
if sign(r11*r21+r12*r22)<1
    s2=-1;
    r23=s2*sqrt(1-r21^2-r22^2);
end

r31=round(r12*r23-r13*r22,6);
r32=round(r13*r21-r11*r23,6);
r33=round(r11*r22-r12*r21,6);

% Writting of the rotation matrix R
R=[r11 r12 r13;r21 r22 r23;r31 r32 r33];

%%%%%%%%%%%%%%%%%%%%%%% Stage 2 with no distortion %%%%%%%%%%%%%%%%%%%%%%%
B=zeros(20,3);
B(:,1)=xyz(:,1);
B(:,3)=-uv(:,1);
c=round((r31*XYZ(:,1)+r32*XYZ(:,2)).*uv(:,1),6);
x=round(B\c,6); % We solve [A']x'=b' to get f & Tz
f=x(1);
Tz=x(3);

T=[Tx;Ty;Tz];







