clc; clear; clear all; close all;

addpath(genpath('reticolo_allege_v9'));
addpath(genpath('Functions'));
FileName = string(datetime('now','Format','yyyyMMdd'));
LoadGoodInitialRho = 1;     % 1: loading a good Rho0; 0: generating a new Rho0

%% Initial Rho0

L = 1:1:192;
if LoadGoodInitialRho 
    load Good_Rho0;
else
    single_Period = rand(1,192);
end

%% Optimization

DevicePattern = single_Period;
Radius = 7;
B = Blur(L,Radius);
lb = zeros(size(DevicePattern));
ub = ones(size(DevicePattern));
fom = [];
exit = [];
Pattern = DevicePattern;
fun = @(PatternIn) FoM_and_Grad(PatternIn,B,FileName);

options = optimoptions(@fmincon,'SpecifyObjectiveGradient',true,'Display','iter','MaxIterations',20000,'MaxFunctionEvaluations',20000,'OutPutFcn',@TO_outfun,'StepTolerance',1*(10^(-4)));
options = optimoptions(options,'Display','iter');
[DevicePattern, fval, exitflag, output] = fmincon(fun,Pattern,[],[],[],[],lb,ub,[],options);
