%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ding Zhao
% zhaoding@umich.edu
% 8/28/2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [crash,R2L,AVVel] = simulation_pedestrian_Simulink(vh,vp,R,controllerParameters)
plotTrajectoryFlag = 0;
plotInputTrajectoryFlag = 0;

vp = abs(vp);
vh = abs(vh);
R = abs(R);

laneWidth = 3.9;
Ts = 0.1;
duration = laneWidth/vp;
tspan = (0:duration/Ts)'*Ts;
%%
% vel of ped,y axis, x axis, predefined
vpy =  [tspan,zeros(size(tspan))];
vpx = [tspan,ones(size(tspan))*vp];
% initial coordinates of the ped,x and y
py0 = R;
px0 = -vp*duration/2;
% initial coordinates of the host vehicle along x and y
hx0 = 0;
hy0 = -vh*duration/2;
%%
RLIni = 20;
nTest = 1;
options = simset('SrcWorkspace','current','FixedStep', num2str(Ts));
NN = length(tspan);
RMin =0;
Focus = ones(NN,1);
vIni = vh;
vFIni = vIni;
SimuTime =100;
StopWhenAEBOn = 0;
SimulinkFile_N = 'pedestrian_simulink.mdl';
Car_AEB = 'Volvo';
%% initialization
%% vehicle parameter
switch nargin
    case 4
        tau = controllerParameters.delay;
        g = 9.8;
        HeadwayTime_desire = 1;
        AbsAccMax = 3.5;
        AccDesign = 2;
        RoadFrictionCoeff = 0.8;
        Kp = -controllerParameters.kp;
        Ki = -controllerParameters.ki;
        Kd = -controllerParameters.kd;
        Kpid = [Kp,Ki,Kd];
        rAEB = -controllerParameters.decelerationRate;
        aAEB = -controllerParameters.finalDeceleration; % m/s2
        TTC_AEB = controllerParameters.TTCThreshold; % s
        vAEBData_kmph = [20,30,40];
        TTCAEBData = [0.538,0.634,0.758];
        TTCAEBMax = 0.955;
        SpdMinData_kmph = 15;
        AEBTTCInput = AEBTTCInputFun(SpdMinData_kmph,vAEBData_kmph,TTCAEBData,TTCAEBMax,Car_AEB);
        iSpdMax_mph = 80; % mph
        iSpdMin_mph = ceil(kmph2mph(5)); % mph
    otherwise
        % model longitudinal dynamic as a first order system
        tau = 0.0796; % bandwidth  = 1/2pi/tau = 2Hz; I did not use 1 order system before 7/28
        RoadFrictionCoeff = 1; % before 7/28 I used 1
        g = 9.8;
        %% ACC setting
        HeadwayTime_desire = 2;
        HeadwayTime_desire = 1;
        AbsAccMax = 3.5;
        AccDesign = 2;
        RoadFrictionCoeff = 0.8;
        Kp = -38.6252446973784;
        Ki = -1.35416845633818;
        Kd = 0;
        Kpid = [Kp,Ki,Kd];
        %% AEB setting
        rAEB = -12;
        aAEB = -5.8; % m/s2
        TTC_AEB = 0.7; % s
        vAEBData_kmph = [20,30,40];
        TTCAEBData = [0.538,0.634,0.758];
        TTCAEBMax = 0.955;
        SpdMinData_kmph = 15;
        AEBTTCInput = AEBTTCInputFun(SpdMinData_kmph,vAEBData_kmph,TTCAEBData,TTCAEBMax,Car_AEB);
        iSpdMax_mph = 80; % mph
        iSpdMin_mph = ceil(kmph2mph(5)); % mph
        
end
%%
sim(SimulinkFile_N,[tspan(1),tspan(end)],options);
crash = sum(simI.Data)>0;
%% 
if plotInputTrajectoryFlag == 1
    spx = cumsum(vpx(:,2))*Ts + px0;
    spy = cumsum(vpy(:,2))*Ts + py0;
    shx = cumsum(ones(length(vpx),1)*0)*Ts + hx0;
    shy = cumsum(ones(length(vpx),1)*vh)*Ts + hy0;
    figure(11)
    plot(spx,spy,shx,shy);
    axis equal
    grid on
    title('input trajectory')
end

if plotTrajectoryFlag == 1
    figure(13);
    plot(hx_hy_lx_ly.Data(:,1),hx_hy_lx_ly.Data(:,2),hx_hy_lx_ly.Data(:,3),hx_hy_lx_ly.Data(:,4));
    axis equal
    grid on
    title('actual trajectory')
end
end