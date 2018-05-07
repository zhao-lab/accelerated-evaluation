function [vh,vl,R,Likelihoodratio] = generate_leftTurn_accelerated(N)
% using uniform distribution to do importance sampling
% tmp = matlab.desktop.editor.getActive;
% cd(fileparts(tmp.Filename));
% 
% load('pdfFunc_pedestrian_paras.mat')

astar_leftTurn = [0 0 0];
bstar_leftTurn = [30 60 150];
vh = ones(N,1);
vl = ones(N,1);
R = ones(N,1);
Likelihoodratio = ones(N,1);



for n = 1:N
    vh(n) = rand(1)*bstar_leftTurn(1);
    vl(n) = rand(1)*(bstar_leftTurn(2) - astar_leftTurn(2)) + astar_leftTurn(2);
    R(n) = rand(1)*(bstar_leftTurn(3) - astar_leftTurn(3)) + astar_leftTurn(3);
    Likelihoodratio(n) = pdfFunc_leftTurn(vh(n),vl(n),R(n))/(1/abs(prod(astar_leftTurn-bstar_leftTurn)));
end
end





