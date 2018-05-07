Ts = 0.1; % [s]
Duration = 8; % [s]
tspan = (0:.1:Duration)';
RLIni = 20;
nTest = 1;
options = simset('SrcWorkspace','current');
NN = 81;
RMin =0;
Focus = ones(NN,1);
vIni = 15;
vFIni = vIni;
v = 10*ones(NN,1);
ut = [tspan,v,Focus];
%         if NewModelFlag == 1
%             if ~exist('Focus2','var'), Focus2 = Focus;end;
%             ut = [tspan,velGen{1,nTest},Focus{1,nTest},iDelayAll{1,nTest}'*0];
%         end

SimuTime =10;
StopWhenAEBOn = 0;
% SimulinkFile = which(SimCtrl.SimModel);
% SimulinkFile_N = [tempSimFolder,'\',SimCtrl.SimModel,sprintf('_%d',nSimulink),'.slx'];

SimulinkFile_N = 'ACCAEB3.slx';
Car_AEB = 'Volvo';
ACCAEBIni;
sim(SimulinkFile_N,[tspan(1),min(SimuTime, tspan(end))],options,ut);