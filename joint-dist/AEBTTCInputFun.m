function AEBTTCInput = AEBTTCInputFun(SpdMinData_kmph,vAEBData_kmph,TTCAEBData,TTCAEBMax,Car_AEB)
if strcmp(Car_AEB, 'Infiniti')
    AEBTTCInput(1,1:3) = kmph2mps([SpdMinData_kmph,30,30+(TTCAEBMax-TTCAEBData(2))/((TTCAEBData(3)-TTCAEBData(2))/(vAEBData_kmph(3)-vAEBData_kmph(2)))]);
    AEBTTCInput(2,1:3) = [TTCAEBData(1)+(TTCAEBData(2)-TTCAEBData(1))/(vAEBData_kmph(2)-vAEBData_kmph(1))*(SpdMinData_kmph-vAEBData_kmph(1)),0.634,TTCAEBMax];
    AEBTTCInput(3,1:3) = [(TTCAEBData(2)-TTCAEBData(1))/kmph2mps(vAEBData_kmph(2)-vAEBData_kmph(1)),...
        (TTCAEBData(3)-TTCAEBData(2))/kmph2mps(vAEBData_kmph(3)-vAEBData_kmph(2)),0];
elseif strcmp(Car_AEB, 'Volvo')
    AEBTTCInput = [kmph2mps([SpdMinData_kmph,40]);...
        [TTCAEBData(1)+(TTCAEBData(2)-TTCAEBData(1))/(vAEBData_kmph(2)-vAEBData_kmph(1))*(SpdMinData_kmph-vAEBData_kmph(1)),TTCAEBMax];...
        [(TTCAEBData(2)-TTCAEBData(1))/kmph2mps(vAEBData_kmph(2)-vAEBData_kmph(1)),0]];
else
    AEBTTCInput(1,1:3) = kmph2mps([SpdMinData_kmph,30,30+(TTCAEBMax-TTCAEBData(2))/((TTCAEBData(3)-TTCAEBData(2))/(vAEBData_kmph(3)-vAEBData_kmph(2)))]);
    AEBTTCInput(2,1:3) = [TTCAEBData(1)+(TTCAEBData(2)-TTCAEBData(1))/(vAEBData_kmph(2)-vAEBData_kmph(1))*(SpdMinData_kmph-vAEBData_kmph(1)),0.634,TTCAEBMax];
    AEBTTCInput(3,1:3) = [(TTCAEBData(2)-TTCAEBData(1))/kmph2mps(vAEBData_kmph(2)-vAEBData_kmph(1)),...
        (TTCAEBData(3)-TTCAEBData(2))/kmph2mps(vAEBData_kmph(3)-vAEBData_kmph(2)),0];
    
end
