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
%%%%%%%%%%%%%%%%%%%%% Values used to run the script. %%%%%%%%%%%%%%%%%%%%%%
Np=[4 10 30 50]; % Sizes of the hidden layer P. 
Alpha=[0.05 0.5 1 2 10]; % Values of the learning rate.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Beginning of the script to study the relationship between Np and alpha  %
% with the recognition accuracy and converge speed.                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Np_alpha=zeros(size(Alpha,2),size(Np,2));
for k=1:size(Alpha,2)% First loop to try many alpha values.
    for n=1:size(Np,2)% Second loop to try many Np for each previous values of alpha.
        input_size=25;
        output_size=4;
        hidden_layer_size=Np(n);% We test different number of nodes in the hidden layer at each loop of the script.
        network_size=[input_size;hidden_layer_size;output_size];
        w_pj=zeros(input_size,hidden_layer_size);
        w_qp=zeros(hidden_layer_size,output_size);

        alpha=Alpha(k);% We test different values of learning rate.
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
            if iterations>=5000 % Condition to break the while loop if the error doesn't converge to 0.
                Squared_error(iterations)=Error;
                Error=0;
            else
                Squared_error(iterations)=Error;
            end
        end
        Np_alpha(k,n)=iterations;
        % Plot of the squared error in function of the number of iteration.
        if n==1
            if k<=4
                figure(1)
                subplot(round(size(Alpha,2)/2),2,k)
                plot(Squared_error);
                xlabel('iteration')
                ylabel('Squared Error')
                hold all 
            elseif k==5
                figure(2)
                plot(Squared_error);
                xlabel('iteration')
                ylabel('Squared Error')
                hold all 
            end
        elseif n>1
            plot(Squared_error);
            xlabel('iteration')
            ylabel('Squared Error')
        end
    end
    out = ['Squared Error = f(iteration) for alpha =' num2str(alpha) ];
    title(out);
    legend('Np=4','Np=10','Np=30','Np=50')
    hold off
end
figure(3)
plot(Alpha,Np_alpha)
legend('Np=4','Np=10','Np=30','Np=50')
xlabel('Learning rate: alpha')
ylabel('iteration')
title('Number of iterations to get a squared error above 0.2%')




       