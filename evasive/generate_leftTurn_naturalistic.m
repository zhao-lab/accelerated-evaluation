function [vh,vl,R,Likelihoodratio] = generate_leftTurn_naturalistic(N)
% using uniform distribution to do importance sampling
CurrentPath = fileparts(mfilename('fullpath'));
load([CurrentPath,'\pdfFunc_leftTurn_paras.mat']);

astar_leftTurn = [0 0 0];
bstar_leftTurn = [30 60 150];
vh = ones(N,1);
vl = ones(N,1);
R = ones(N,1);
Likelihoodratio = ones(N,1);



for n = 1:N
    K = 4;
    Temp = zeros(1,3);
    vh_vl_R = zeros(1,3);
    for i = 1:K
        Temp = mvnrnd(mu_leftTurn(i,:),sigma_leftTurn(:,:,i));
        while ~( Temp(1) <= bstar_leftTurn(1) && Temp(1) >= astar_leftTurn(1) && ...
                Temp(2) <= bstar_leftTurn(2) && Temp(2) >= astar_leftTurn(2) && ...
                Temp(3) <= bstar_leftTurn(3) && Temp(3) >= astar_leftTurn(3))
            Temp = mvnrnd(mu_leftTurn(i,:),sigma_leftTurn(:,:,i));
        end
        vh_vl_R = vh_vl_R + Temp * eta_leftTurn(i);
    end
    vh(n) = vh_vl_R(1);
    vl(n) = vh_vl_R(2);
    R(n) = vh_vl_R(3);
    Likelihoodratio(n) = 1;%pdfFunc_leftTurn(vh_vl_R(1),vh_vl_R(2),vh_vl_R(3));
end
end





