% crash = simulation_leftTurn_PreScan(23,20,3);


astar_leftTurn = [0 0 0];
bstar_leftTurn = [30 60 150];

tempCrashLeftTurn = zeros(10*10*10,4);
ii = 0;
jj = 0;
kk = 0;

for i = linspace(1,30,10)
    for j = linspace(1,60,10)
        for k = linspace(1,150,10)
            kk = kk + 1;
            disp(['iteration now: ',num2str(kk)]);
            vh = i;
            vl = j;
            R = k;
            tempCrashLeftTurn(kk,1:3) = [i,j,k];
%             [cc,R2L,AVVel] = simulation_pedestrian_PreScan(vh,vp,R);
            [cc,~,~] = simulation_leftTurn_PreScan(vh,vl,R);
            tempCrashLeftTurn(kk,4) = cc;
            pause(0.2)
        end
    end
end

save('monocityTestLeftTurn.mat')
%% visualize
for i = 1:length(tempCrashLeftTurn)
    if tempCrashLeftTurn(i,4) == 0
        scatter3(tempCrashLeftTurn(i,1),tempCrashLeftTurn(i,2),tempCrashLeftTurn(i,3),1,'bo');
        hold on
    else
        scatter3(tempCrashLeftTurn(i,1),tempCrashLeftTurn(i,2),tempCrashLeftTurn(i,3),'MarkerEdgeColor','k',...
        'MarkerFaceColor',[0 .75 .75])
        hold on
    end
end

xlabel('host vehicle velocity');
ylabel('leftTurn vehicle velocity');
zlabel('Distance to conflict point');


title('leftTurn simulation')





