function [R] = Pseudo_inverse(v,V )
% From an initial triangle v and its transformed triangle V, we get the
% transformation parameters [k, theta, xd, yx]

Q=zeros(4,1);
A=zeros(size(v,1),4);

for i=1:size(v,1)/2 % Writing of the inversed transformation matrix in function of v
    A(2*i-1,1)=v(2*i-1);
    A(2*i-1,2)=-v(2*i);
    A(2*i-1,3)=1;
    A(2*i,1)=v(2*i);
    A(2*i,2)=v(2*i-1);
    A(2*i,4)=1;
end
n=0;
xc=0;
yc=0;
for i=1:size(v,1)/2 % Calculation of (xc,yc)
    xc=v(2*i-1)+xc;
    yc=v(2*i)+yc;
    n=n+1;
end
xc=xc/n;
yc=yc/n;
Eq=inv(A'*A)*A'*V; % Q = (tA * A)^(-1)*tA*V = [q1;q2;q3;q4]

for i=1:4
    Q(i)=Eq(i);
end

% Determination of each transformation parameters by using the
% relationships between them and [q1;q2;q3;q4]
k=sqrt(Q(1)^2+Q(2)^2);
theta=atan(Q(2)/Q(1));
xd=Q(3)-xc;
yd=Q(4)-yc;

R=[k,theta,xd,yd]';
end

