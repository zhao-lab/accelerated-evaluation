function [ nCrashL ] = lane_change_model_one_run( vLIni,X_InvTTC,X_InvR )
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
    

    TTCIni = 1/X_InvTTC;
    RLIni = 1/X_InvR;
    RRLIni = max(-23.49,-RLIni/TTCIni); % I forgot why it is -23.49 m/s
    vIni = min(35,vLIni - RRLIni);

    Ts = 0.1; % [s]
    Duration = 8; % [s]
    tspan = (0:.1:Duration)';
    K = length(tspan);
    Car_AEB = 'Volvo';
    ACCAEBIni;
    FSaveUncrashedEvent = 0;
    NTest = 10;
     RMin = 0; % m
    options = simset('SrcWorkspace','current');
    clear AllLogData;
    % vIniNCAP = vIni; % vIni = v(1); maybe you do not need it
    % RMin = 0;
    StopWhenAEBOn = 0; % ignore

    vL = ones(K,1)*vLIni;


    ut = [tspan,vL];
    CdPath = cd;
    nSimulink = 1;
    tempSimFolder = [cd,'\',sprintf('tempSim_%d',nSimulink)];
    SimModel = 'ACCAEB4';
    SimulinkFile_N = [tempSimFolder,'\',SimModel,sprintf('_%d',nSimulink),'.slx'];
    if ~exist(tempSimFolder,'file')
        mkdir(tempSimFolder)
        addpath(tempSimFolder);
        SimulinkFile = which(SimModel);
        copyfile(SimulinkFile,SimulinkFile_N)
        cd(tempSimFolder);
        sim(SimulinkFile_N,[tspan(1),tspan(end)],options,ut);
        cd(CdPath);
    else
        sim(SimulinkFile_N,[tspan(1),tspan(end)],options,ut);
        %     error('redundent temp folder');
    end

    nSimData = Log2Var(logsout);
    nAEBStatus = sum(nSimData.AEBStatus) > 0;
    nDist = nSimData.Dist(end);
    nStep = length(nSimData.Dist);
    if nSimData.RL(end) < RMin
        nCrashL = true;
    else
        nCrashL = false;
    end

end

