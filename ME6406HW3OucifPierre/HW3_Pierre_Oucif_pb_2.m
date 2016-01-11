clear;
close all
%%%%%%%%%%%%%%%%%%%%%% Loading of the initial datas %%%%%%%%%%%%%%%%%%%%%%%
data=load('robot_hand_eye_data');
Hc1=data.Hc1;
Hc2=data.Hc2;
Hc3=data.Hc3;
Hg12=data.Hg12;
Hg23=data.Hg23;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% a) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Hc12=Hc2*inv(Hc1); % We use Hcij=Hcj*Hci^-1
Hc23=Hc3*inv(Hc2);

Rc12=Hc12(1:3,1:3);% We decompose Hcij to get Rcij and Tcij
Tc12=Hc12(1:3,4);
Rc23=Hc23(1:3,1:3);
Tc23=Hc23(1:3,4);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% b) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Rg12=Hg12(1:3,1:3);% We decompose Hgij to get Rgij and Tgij
Tg12=Hg12(1:3,4);
Rg23=Hg23(1:3,1:3);
Tg23=Hg23(1:3,4);

%%%%%%%%%%%%%%%%%%%%% Computation of theta_cij and n_cij %%%%%%%%%%%%%%%%%%

[theta_c12,n_c12]=find_theta_n(Rc12);% Cf the function code
[theta_c23,n_c23]=find_theta_n(Rc23);
[theta_g12,n_g12]=find_theta_n(Rg12);
[theta_g23,n_g23]=find_theta_n(Rg23);

%%%%%%%%%%%%%%%%%%%%% Computation of Pc_ij %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Pc12=2*sin(theta_c12/2)*n_c12;
Pc23=2*sin(theta_c23/2)*n_c23;
Pg12=2*sin(theta_g12/2)*n_g12;
Pg23=2*sin(theta_g23/2)*n_g23;

% Checking of the values of theta_gij and Pgij by computing the
% corresponding rotation matrix Rg_ij
[Rg12_eq8,Rg12_eq10]=R_Computation(theta_g12,n_g12,Pg12);
[Rg23_eq8,Rg23_eq10]=R_Computation(theta_g23,n_g23,Pg23);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% c) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% We follow the demarche described on the paper of Tsai to compute Pcg, Tcg
% and [Rcg]


P12=Pc12+Pg12;
P23=Pc23+Pg23;
Skew_P12=[0 -P12(3) P12(2);P12(3) 0 -P12(1);-P12(2) P12(1) 0];
Skew_P23=[0 -P23(3) P23(2);P23(3) 0 -P23(1);-P23(2) P23(1) 0];
% Concatenation of the two pairs of vector to get Pcg' 
Pcg_p=[Skew_P12;Skew_P23]\[Pc12-Pg12;Pc23-Pg23];

% We use Pcg_p to get theta and Pcg
theta_cg=2*atan(norm(Pcg_p));
Pcg=2*Pcg_p/sqrt(1+(norm(Pcg_p))^2);

% We use Pcg to get ncg
n_cg=Pcg/(2*sin(theta_cg/2));

% We use the previous function to get R with the equation [8] and [10]
[Rcg_eq8,Rcg_eq10]=R_Computation(theta_cg,n_cg,Pcg);

% Concatenation of the two vectors and two matrices to get Tcg 
Rg=[Rg12-eye(3);Rg23-eye(3)];
T12=Rcg_eq8*Tc12-Tg12;
T23=Rcg_eq8*Tc23-Tg23;
T=[T12;T23];
Tcg=Rg\T;


