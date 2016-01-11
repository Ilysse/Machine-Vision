function [R_eq8,R_eq10 ] = R_Computation(theta,n,Pr)
n1=n(1);
n2=n(2);
n3=n(3);
t=theta;

% First method to get R by using theta and n
% Computation of each components of R by using Tsai's paper formulas
R11=n1^2+(1-n1^2)*cos(t);
R12=n1*n2*(1-cos(t))-n3*sin(t);
R13=n1*n3*(1-cos(t))+n2*sin(t);
R21=n1*n2*(1-cos(t))+n3*sin(t);
R22=n2^2+(1-n2^2)*cos(t);
R23=n2*n3*(1-cos(t))-n1*sin(t);
R31=n1*n3*(1-cos(t))-n2*sin(t);
R32=n2*n3*(1-cos(t))+n1*sin(t);
R33=n3^2+(1-n3^2)*cos(t);
R_eq8=[R11 R12 R13;R21 R22 R23;R31 R32 R33];

% Second method to get R by using Pr
% We also use the Tsai's paper formulas 
skew_Pr=[0 -Pr(3) Pr(2);Pr(3) 0 -Pr(1);-Pr(2) Pr(1) 0];% Skew(Pr)
alpha=sqrt(4-(norm(Pr))^2);% Alpha
R_eq10=(1-(norm(Pr)^2)/2)*eye(3)+((Pr*(Pr')+alpha*skew_Pr))/2;% R

end

