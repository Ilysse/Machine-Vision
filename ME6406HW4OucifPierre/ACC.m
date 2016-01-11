function [ image,D_image ] = ACC( sample,c1,c2,c3)
Gs =fspecial('gaussian',45,10);% Gaussian
DOG=fspecial('gaussian',45,1)-fspecial('gaussian',45,10);% DOG
R=(sample(:,:,1));
G=(sample(:,:,2));
B=(sample(:,:,3));
image=(sample);
for j=1:3
    % We read the transformation sequence
    if j==1
        c=c1;
    elseif j==2
        c=c2;
    elseif j==3
        c=c3;
    end
    
    if c==1
        R1=imfilter(R,DOG,'replicate')+imfilter(G,Gs,'replicate'); % R1 computation
    end
    if c==2
        G1=imfilter(G,DOG,'replicate')+imfilter(2*G-R,Gs,'replicate');% G1 computation
    end
    if c==3
        B1=imfilter(B,DOG,'replicate')+imfilter(B-(R-G),Gs,'replicate');% B1 computation
    end
    if c=='a'
        R1=imfilter(R,DOG,'replicate')+imfilter(B-G,Gs,'replicate');% R1 computation
    end
    if c=='b'
        G1=imfilter(G,DOG,'replicate')+imfilter(B-R,Gs,'replicate');% G1 computation
    end
    if c=='c'
        B1=imfilter(B,DOG,'replicate')+imfilter(2*B-(R+G),Gs,'replicate');% B1 computation
    end
   
end
% Distance/contraste between the Target and Noise
D_image=round(sqrt((R1(1,1)-R1(1,size(R1,2)))^2+(G1(1,1)-G1(1,size(G1,2)))^2+(B1(1,1)-B1(1,size(B1,2)))^2));
image(:,:,1)=(R1);
image(:,:,2)=(G1);
image(:,:,3)=(B1);
image=(image);
end


