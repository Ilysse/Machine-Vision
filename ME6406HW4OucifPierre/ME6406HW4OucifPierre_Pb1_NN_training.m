%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%% Pierre Oucif - HW4 - Problem 1 %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
close all
data=load('GTME.mat');
%%%%%%%%%%%%%%%%%%% Loading of the initial datas. %%%%%%%%%%%%%%%%%%%%%%%%%
G=[1 0 0 0];
G_test=data.G_test;
G1=data.G_train1;
G2=data.G_train2;
G3=data.G_train3;
T=[0 1 0 0];
T_test=data.T_test;
T1=data.T_train1;
T2=data.T_train2;
T3=data.T_train3;
M=[0 0 1 0];
M_test=data.M_test;
M1=data.M_train1;
M2=data.M_train2;
M3=data.M_train3;
E=[0 0 0 1];
E_test=data.E_test;
E1=data.E_train1;
E2=data.E_train2;
E3=data.E_train3;


input_size=25;
output_size=4;
hidden_layer_size=25;% We test different number of nodes in the hidden layer at each loop of the script.
network_size=[input_size;hidden_layer_size;output_size];
w_pj=zeros(input_size,hidden_layer_size);
w_qp=zeros(hidden_layer_size,output_size);

alpha=0.5;
lambda=1;
iterations=0;
Squared_error=zeros(1,iterations);
Error=1;

% Initialisation of the weights by taking randomly an integer
% between -0.5 and +0.5.
for i=1:hidden_layer_size
    for j=1:output_size
        w_qp(i,j)=-0.5+rand;
    end
    for j=1:input_size
        w_pj(j,i)=-0.5+rand;
    end
end

% The Neural Network learns until the squared error is above 0.2%.
while Error>=0.002
    iterations=iterations+1; % We count the number of iteration to be above the 0.2% of error
    % We use the function update_weight to make the Neural Network
    % learning. For one input and one known output, we update each
    % weights of the NN by using the back-propagation learning
    % method. 
    [w_pj,w_qp]=update_weight(alpha,lambda,G,G1,network_size,w_pj,w_qp);
    [w_pj,w_qp]=update_weight(alpha,lambda,G,G2,network_size,w_pj,w_qp);
    [w_pj,w_qp]=update_weight(alpha,lambda,G,G3,network_size,w_pj,w_qp);
    [w_pj,w_qp]=update_weight(alpha,lambda,T,T1,network_size,w_pj,w_qp);
    [w_pj,w_qp]=update_weight(alpha,lambda,T,T2,network_size,w_pj,w_qp);
    [w_pj,w_qp]=update_weight(alpha,lambda,T,T3,network_size,w_pj,w_qp);
    [w_pj,w_qp]=update_weight(alpha,lambda,M,M1,network_size,w_pj,w_qp);
    [w_pj,w_qp]=update_weight(alpha,lambda,M,M2,network_size,w_pj,w_qp); 
    [w_pj,w_qp]=update_weight(alpha,lambda,M,M3,network_size,w_pj,w_qp); 
    [w_pj,w_qp]=update_weight(alpha,lambda,E,E1,network_size,w_pj,w_qp);
    [w_pj,w_qp]=update_weight(alpha,lambda,E,E2,network_size,w_pj,w_qp);    
    [w_pj,w_qp]=update_weight(alpha,lambda,E,E3,network_size,w_pj,w_qp);
    % We use the function Character_recognition to get the output
    % from the NN in order to compare it with the reference.
    G_Outputs=Character_recognition(G_test,network_size,w_pj,w_qp);
    T_Outputs=Character_recognition(T_test,network_size,w_pj,w_qp);
    M_Outputs=Character_recognition(M_test,network_size,w_pj,w_qp);
    E_Outputs=Character_recognition(E_test,network_size,w_pj,w_qp);
    Error=0;
    for j=1:size(G_Outputs) % Computation of the squared error.
        Error=Error+(G(j)-G_Outputs(j))^2+(T(j)-T_Outputs(j))^2+(T(j)-T_Outputs(j))^2+(T(j)-T_Outputs(j))^2;
    end
    if iterations>=500 % Condition to break the while loop if the error doesn't converge to 0.
        Squared_error(iterations)=Error;
        Error=0;
    else
        Squared_error(iterations)=Error;
    end
end
plot(Squared_error);
xlabel('iteration')
ylabel('Squared Error')
title('Converge curve')
save('NN_weights.mat','w_pj','w_qp')