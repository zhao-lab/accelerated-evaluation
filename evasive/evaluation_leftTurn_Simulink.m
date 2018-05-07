function [lr,y] = evaluation_leftTurn_Simulink(N)
beta = 0.2;
alpha = 0.2;
z_alpha = norminv(1-alpha/2,0,1);
y = zeros(N,1);
I = zeros(N,1);
LL = zeros(N,1); %likelihood ratio
lr = zeros(N,1);
[vhN,vlN,RN,LikelihoodratioN] = generate_leftTurn_accelerated(N);
for i = 1:N
    %% run the simulation of given parameters
    vh = vhN(i); % leading vehicle velocity
    vl = vlN(i); % host vehicle velocity
    R = RN(i); % range when the leading vehicle is at the center of the crossing lane
    LL(i) = LikelihoodratioN(i);
    %%
    [crash,R2L,AVVel] = simulation_leftTurn_Simulink(vh,vl,R);
    if crash ~= 0
        I(i) = 1;
    else
        I(i) = 0;
    end
    %% check convergence
    y(i) = 1/i*sum(I(1:i).*LL(1:i));
    lr(i) = z_alpha*std(y(1:i))/y(i);
    disp([num2str(i),' iteration finished'])
    if lr(i) < beta && i > 10 && sum(I)>=50
        break
    end
    
end

end
