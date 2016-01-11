function [ w_pj,w_qp] = update_weight( alpha,lambda,reference,input,network_size,w_pj,w_qp)
% Loading of the initial datas 
input_size=network_size(1);
hidden_layer_size=network_size(2);
output_size=network_size(3);
dw_pj=zeros(input_size,hidden_layer_size);
dw_qp=zeros(hidden_layer_size,output_size);
delta_qp=zeros(1,hidden_layer_size);
delta_q=zeros(1,output_size);
y_layer=zeros(1,hidden_layer_size);
y_output=zeros(1,output_size);
y_input=zeros(1,input_size);

% We follow the derivation from the report
for i=1:size(input,1)
    y_input(1,(4*(i-1)+1):(4*i+1))=input(i,:);
end

for i=1:hidden_layer_size
   for j=1:input_size
       y_layer(i)=y_layer(i)+w_pj(j,i)*y_input(j);
   end
   y_layer(i)=h(y_layer(i),lambda);
end

for i=1:output_size
   for j=1:hidden_layer_size
       y_output(i)=y_output(i)+w_qp(j,i)*y_layer(j);
   end
   y_output(i)=h(y_output(i),lambda);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:output_size
    delta_q(i)=y_output(i)*(1-y_output(i))*(reference(i)-y_output(i));
end
for i=1:hidden_layer_size
    for j=1:output_size
        dw_qp(i,j)=alpha*delta_q(j)*y_layer(i);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:hidden_layer_size
    for j=1:output_size
        delta_qp(i)=delta_qp(i)+y_layer(i)*(1-y_layer(i))*w_qp(i,j)*delta_q(j);
    end
end
for i=1:input_size
    for j=1:hidden_layer_size
        dw_pj(i,j)=alpha*delta_qp(j)*y_input(i);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:size(w_qp,1)
    for j=1:size(w_qp,2)
        w_qp(i,j)=w_qp(i,j)+dw_qp(i,j);
    end
end
for i=1:size(w_pj,1)
    for j=1:size(w_pj,2)
        w_pj(i,j)=w_pj(i,j)+dw_pj(i,j);
    end
end

        
end

