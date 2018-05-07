%% Ding Zhao zhaoding@umich.edu
%% 6/9/2014
%% vehicle parameter
% model longitudinal dynamic as a first order system
tau = 0.0796; % bandwidth  = 1/2pi/tau = 2Hz; I did not use 1 order system before 7/28 
% tau = 1/2/pi;
RoadFrictionCoeff = 1; % before 7/28 I used 1
g = 9.8;
%% ACC setting
HeadwayTime_desire = 2;%
AbsAccMax = 5;%3.5; % I used 5 before  7/28
% PID control gains
AccDesign = 2; % I used 2 before  7/28
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This will be used in car-following only
if strcmp(Car_AEB, 'Infiniti')
    HeadwayTime_desire = 1;
    AbsAccMax = 3.5;
    AccDesign = 2;
    RoadFrictionCoeff = 0.8;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch AccDesign
    case 1% 10 rad/s bandwith, 60 degree phase margin
        Kp = -7.04362301700724;
        Ki = -0.126152880915797;
        Kd = 0;
        Kpid = [Kp,Ki,Kd];
    case 2% 2 rad/s bandwith, 60 degree phase margin % a lot of ocsilation
        Kp = -38.6252446973784;
        Ki = -1.35416845633818;
        Kd = 0;
        Kpid = [Kp,Ki,Kd];
    case 3% 1 rad/s bandwith, 60 degree phase margin, 1s rising time
        Kp = -14.9837374778501;
        Ki = -0.262231263665416;
        Kd = 0;
        Kpid = [Kp,Ki,Kd];
    case 4% 1.57 rad/s bandwith, 60 degree phase margin
        Kp = -29.0854643291981;
        Ki = -0.799749378851001;
        Kd = 0;
        Kpid = [Kp,Ki,Kd];
    case 5% 1.17 rad/s bandwith, 60 degree phase margin, 0.8s rising time
        Kp = -19.0772829319987;
        Ki = -0.390988376453558;
        Kd = 0;
        Kpid = [Kp,Ki,Kd]; 
    case 6% 1.17 rad/s bandwith, 60 degree phase margin, 0.7s rising time
        Kp = -24.763;
        Ki = -0.607;
        Kd = 0;
        Kpid = [Kp,Ki,Kd]; 
    case 7
        
    otherwise
        Kp = -7.04362301700724;
        Ki = -0.126152880915797;
        Kd = 0;
        Kpid = [Kp,Ki,Kd];
end
%% AEB setting
if strcmp(Car_AEB, 'Infiniti')
    rAEB = -12;
    aAEB = -5.8; % m/s2
    TTC_AEB = 0.7; % s
    vAEBData_kmph = [20,30,40];
    TTCAEBData = [0.538,0.634,0.758];
    TTCAEBMax = 0.955;
    SpdMinData_kmph = 15;
elseif strcmp(Car_AEB, 'Volvo')
    rAEB = -16;
    aAEB = -10; % m/s2
    % TTC_AEB = 0.7; % s
    vAEBData_kmph = [16,40];
    TTCAEBData = [0.86,0.91];
    TTCAEBMax = 0.91;
    SpdMinData_kmph = 4;
else
    rAEB = -12;
    aAEB = -5.8; % m/s2
%     TTC_AEB = 0.7; % s
end
AEBTTCInput = AEBTTCInputFun(SpdMinData_kmph,vAEBData_kmph,TTCAEBData,TTCAEBMax,Car_AEB);
iSpdMax_mph = 80; % mph
iSpdMin_mph = ceil(kmph2mph(5)); % mph
