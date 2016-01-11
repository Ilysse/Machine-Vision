function [ y_output ] = Character_recognition( character_input,network_size,w_pj,w_qp )
% Loading of the initiale datas
input_size=network_size(1);
hidden_layer_size=network_size(2);
output_size=network_size(3);
y_layer=zeros(1,hidden_layer_size);
y_output=zeros(1,output_size);
y_input=zeros(1,input_size);

% Computation of the outputs of each layers
for i=1:size(character_input,1)
    y_input(1,(4*(i-1)+1):(4*i+1))=character_input(i,:);
end

for i=1:hidden_layer_size
   for j=1:input_size
       y_layer(1,i)=y_layer(1,i)+w_pj(j,i)*y_input(1,j);
   end
   y_layer(1,i)=h(y_layer(1,i),1); % y=h(Sum of inputs)
end

for i=1:output_size  
   for j=1:hidden_layer_size
       y_output(i)=y_output(i)+w_qp(j,i)*y_layer(1,j);
   end
   y_output(i)=h(y_output(i),1); 
end

end

