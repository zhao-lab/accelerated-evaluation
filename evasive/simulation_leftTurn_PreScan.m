function [crash,R2L,AVVel] = simulation_leftTurn_PreScan(vh,vl,R)
CurrentPath = fileparts(mfilename('fullpath'));
cd(CurrentPath);
dh = 43;
dl = 19;
d_offset = dl/vl*vh - 43 + R;%offset of the host(straight) vehicle according to the trajectory
%t_offset    %offset of the start time(conflict time)
duration = dl/vl;

CurrentPath = fileparts(mfilename('fullpath'));
open([CurrentPath,'\MCity_cs.mdl']);
options = simset('SrcWorkspace','current');
sim('MCity_cs.mdl',duration,options);
crash = sum(simI.Data)>0;
end