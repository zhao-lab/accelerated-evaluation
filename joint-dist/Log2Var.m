function LogData = Log2Var(logsout)
Name = logsout.getElementNames;
for nElement = 1:logsout.numElements
    LogData.(Name{nElement}) =logsout.get(Name{nElement}).Values.Data;
end