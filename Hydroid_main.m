 clear all
close all
clc
tic
global Optim_Parameters 
global Walk_Speed Step_Length degree impactindex
global lb_q_int ub_q_int lb_qp_fin ub_qp_fin FootX_fin

global Hip_fin_config  q_bras_fin Mo_Cin_CdM_z MC THETA
global poly polyp polypp T vec_T
global GAM GAM2  g L1 L2 L3 L4 L5 hp
global ZMPx R_Force Swing_Height_int q_ini
global  mc dom_tra q_int
global vfoot2_toe vfoot2_heel Energie_criteria MC_CdM_criteria
global violate flag1 flag2
global xstep1 xstep2

% NOTE: All angles and positions are absolute

%% Initialization of parameters
format long
Hydroid_initialisation_2D

load('Optimisation Parameters Results\Optim_Parameters11_V10.mat')

Walk_Speed = 1.0;
initial_cond = Optim_Parameters;

%% Boundary Conditions
%Lower Boundary conditions
%lb_Hip_fin_config = [0; 0.40; -20*degree];  %[HipX_fin; HipY_fin; Hip_Angle_X_ini]

lb_Hip_int_config = [0; 0.40; -20*degree];
lb_Ratio_Tint_to_T = 0;
lb_HipY_fin = 0.4;
lb_HipQ_fin = -20*degree;
lb_FootX_fin = 0.01;
lb_q_bras_fin=[-90;-170;-90;-170]*degree;
lb_q_bras_int=[-90;-170;-90;-170]*degree;
lb_qp_int = -[300; 400; 400; 400; 400;2000;2000;2000;2000;300]*degree;
lb_qp_fin = -[300; 400; 400; 400; 400;2000;2000;2000;2000;300]*degree;

%Upper Boundary conditions
%ub_Hip_fin_config = [0.8; 0.846; 20*degree];  %[HipX_fin; HipY_fin; Hip_Angle_X_ini]
ub_Hip_int_config = [0.4; 0.846; 20*degree];  %[HipX_fin; HipY_fin; Hip_Angle_X_ini]
ub_Ratio_Tint_to_T = 1;
ub_HipY_fin = 0.846;
ub_HipQ_fin = 20*degree;
ub_FootX_fin = 1.2;
ub_q_bras_fin=[90;170;90;170]*degree;
ub_q_bras_int=[90;170;90;170]*degree;
ub_qp_int = [300; 400; 400; 400; 400;2000;2000;2000;2000;300]*degree;
ub_qp_fin = [300; 400; 400; 400; 400;2000;2000;2000;2000;300]*degree;

%Lower and Upper bounds for the matlab function "fmincon"
Ulb = [lb_Hip_int_config; lb_Ratio_Tint_to_T; lb_HipY_fin; lb_HipQ_fin; lb_FootX_fin; lb_q_bras_fin; lb_q_bras_int; lb_qp_int; lb_qp_fin];
Uub = [ub_Hip_int_config; ub_Ratio_Tint_to_T; ub_HipY_fin; ub_HipQ_fin; ub_FootX_fin; ub_q_bras_fin; ub_q_bras_int; ub_qp_int; ub_qp_fin];

%%
A=[];a=[];B=[];temp=[];Aeq=[];Beq=[];
goal=1;
weight=abs(goal);
% options = optimset('Display','iter-detailed','MaxFunEvals',100000,'MaxIter',1800,'TolCon',1e-2 ,'TolX',1e-2,'TolFun',1e-2);  %  ,'MeritFunction','singleobj'
% [Optim_Parameters,Fval,flag] = fgoalattain('Hydroid_Trajec',initial_cond,goal,weight,A,B,Aeq,Beq,Ulb,Uub,'Hydroid_constraints', options);
%   options = optimset('Display','iter-detailed','MaxFunEvals',100000,'MaxIter',1800,'TolCon',1e-1 ,'TolX',1e-1,'TolFun',1e-1,'Algorithm','active-set'); 
 options = optimset('Display','iter-detailed','MaxFunEvals',100000,'MaxIter',1800,'TolCon',1e-2 ,'TolX',1e-2,'TolFun',1e-2);  %  ,'MeritFunction','singleobj'
% options = optimset('Display','iter-detailed','MaxFunEvals',100000,'MaxIter',1800,'TolCon',1e-4 ,'TolX',1e-4,'TolFun',1e-4,'PlotFcns',@optimplotx);  %  ,'MeritFunction','singleobj'
[Optim_Parameters,Fval,EXITFLAG,output,lambda,grad] = fmincon('Hydroid_Trajec',...
    initial_cond,A,B,Aeq,Beq,Ulb,Uub,'Hydroid_constraints',options);
toc
flag1 
flag2

xstart = 0;
[xstep1] = animation(poly(:,1:impactindex), xstart);
[xstep2] = animation(poly(:,impactindex+1:end), xstep1);

% Plot handheld device's acceleration characterstics
% phone_characteristics_numerical   % Plots phone's acceleration using numerical differentiation
phone_characteristics_analytical  % Plots phone's acceleration using analytical differentiation
