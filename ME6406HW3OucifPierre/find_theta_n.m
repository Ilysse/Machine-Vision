function [theta,n]=find_theta_n(R)
theta=acos((trace(R)-1)/2);% Because trace(R)=1+2*cos(theta)
A=1/(2*sin(2*theta));

%We have to check the sign of theta (because cos(theta)=cos(-theta))
if sign(R(3,2)-R(2,3))~=sign(A*(R(3,2)-R(2,3)))
    theta=-theta;
end

n=[A*(R(3,2)-R(2,3));A*(R(1,3)-R(3,1));A*(R(2,1)-R(1,2))];% Expression from class' derivation
n=n/norm(n);% Normalization of n
end

