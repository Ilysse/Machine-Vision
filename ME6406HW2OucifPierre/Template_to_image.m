function [ V ] = Template_to_image( v,k,theta,vector_d )
% From a tiangle v and transformation parameters, we get the transformated
% triangle V

xc=0;
yc=0;
n=0;
R=[[cos(theta) -sin(theta)];[sin(theta) cos(theta)]]; % Rotation matrix
V=v; % V and v have the same dimensions

for i=1:size(v,1)/2 % We find the centroid of v
    xc=v(2*i-1)+xc;
    yc=v(2*i)+yc;
    n=n+1;
end
vector_c=[xc/n yc/n]'; % Arithmetic average of (xc,yc) to get the centroid of v

for i=1:size(v,1)/2 % Transformation calculations : V = k*R*v+vd+vc => for each couple of x (indices 2*i-1) and y (indices 2*i)
    v_int=v(2*i-1:2*i); % We split v into several v_int to make the calculations and to get several V_int
    V_int=round(k*(R*v_int)+vector_d+vector_c,3); % V_int = k*R*v_int+vd+vc
    V(2*i-1)=V_int(1); % We merge each V_int to get V
    V(2*i)=V_int(2); % We merge each V_int to get V
end

end
