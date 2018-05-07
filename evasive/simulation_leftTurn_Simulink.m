function [crash,R2L,AVVel] = simulation_leftTurn_Simulink(vh,vl,R,controllerParameters)
% the scenario starts 1 s before the vehicles run into the conflict point
% disp('-1')
vh = abs(vh);
vl = abs(vl);
R = abs(R);

plotTrajectoryFlag = 0;
plotInputTrajectoryFlag = 0;

Ts = 0.1;
turningRadius = 5; % turning radius should be larger than laneWidth
laneWidth = 3.9;
alphaRadius = acos((turningRadius - laneWidth)/turningRadius);
betaRadius = min(alphaRadius,vl/turningRadius);

nToRemove = (alphaRadius - betaRadius)*turningRadius/vl/Ts;

timeBeforeConflict = turningRadius * alphaRadius/vl;
timeToTurn = pi/2 * turningRadius/vl;
duration = (turningRadius*pi/2 + 2*laneWidth) /vl;

tspan = (0:duration/Ts)'*Ts;
%%
% vel of left turning vehicle,y axis, x axis, predefined
vly = zeros(size(tspan));
vlx = zeros(size(tspan));
% turning
nTurning = sum(tspan <= timeToTurn);
vly(tspan<=timeToTurn) = vl*cos(linspace(0,pi/2,nTurning));
vlx(tspan<=timeToTurn) = -vl*sin(linspace(0,pi/2,nTurning));
% after conflict point
vly(tspan > timeToTurn) = 0;
vlx(tspan > timeToTurn) = -vl;
%% remove start point so the head time is constant
tspan = tspan(1:(length(tspan)-nToRemove));
vly = vly(nToRemove+1:length(vly));
vlx = vlx(nToRemove+1:length(vlx));
timeBeforeConflict = betaRadius*turningRadius/vl;

%%
vly = [tspan,vly];
vlx = [tspan,vlx];
%%
hx0 = 0;
hy0 = sin(alphaRadius)*R + vh*timeBeforeConflict;
% initial coordinates of the ped,x and y
ly0 = -turningRadius + sin(alphaRadius-betaRadius)*turningRadius;
lx0 = laneWidth-cos(alphaRadius-betaRadius)*turningRadius;
% initial coordinates of the host vehicle along x and y
%%
%disp('0')
RLIni = abs(hy0 - ly0);
nTest = 1;
options = simset('SrcWorkspace','current','FixedStep', num2str(Ts));
NN = length(tspan);
RMin =0;
Focus = ones(NN,1);
vIni = vh;
vFIni = vIni;
% SimuTime =100;
StopWhenAEBOn = 0;
SimulinkFile_N = 'leftTurn_simulink.mdl';
Car_AEB = 'Volvo';
%% initialization
%% vehicle parameter
%disp('1')
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

% disp('beforeSim');

%disp('2')
% SimulinkFile_N
% options
% tspan
% [tspan(1),tspan(end)]




sim(SimulinkFile_N,[tspan(1),tspan(end)],options);
% disp('afterSim');
simI.Data;

if sum(simI.Data) > 0
    crash = 1;
else
    crash = 0;
end

if plotInputTrajectoryFlag == 1
    slx = cumsum(vlx(:,2))*Ts + lx0;
    sly = cumsum(vly(:,2))*Ts + ly0;
    shx = cumsum(ones(length(vlx),1)*0)*Ts + hx0;
    shy = - cumsum(ones(length(vlx),1)*vh)*Ts + hy0;
    figure(11)
    plot(slx,sly,shx,shy);
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