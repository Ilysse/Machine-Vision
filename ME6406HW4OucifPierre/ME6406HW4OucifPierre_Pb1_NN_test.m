%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%% Pierre Oucif - HW4 - Problem 1 %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
close all
data=load('GTME.mat');
w=load('NN_weights.mat');
%%%%%%%%%%%%%%%%%%% Loading of the initial datas. %%%%%%%%%%%%%%%%%%%%%%%%%
G=[1 0 0 0];
G_test=data.G_test;
T=[0 1 0 0];
T_test=data.T_test;
M=[0 0 1 0];
M_test=data.M_test;
E=[0 0 0 1];
E_test=data.E_test;
w_qp=w.w_qp;
w_pj=w.w_pj;
input_size=25;
hidden_layer_size=25;
output_size=4;
network_size=[input_size;hidden_layer_size;output_size];
% We use the function Character_recognition to compute the character
GTME=[Character_recognition(G_test,network_size,w_pj,w_qp);Character_recognition(T_test,network_size,w_pj,w_qp);Character_recognition(M_test,network_size,w_pj,w_qp);Character_recognition(E_test,network_size,w_pj,w_qp)];





