function  pdf_leftTurn = pdfFunc_leftTurn(v,vl,R)
% SpeedSdv,SpeedTV,Dcp (v,vl,R)
%%
load('pdfFunc_leftTurn_paras.mat')


astar_leftTurn = [0 0 0];
bstar_leftTurn = [30 60 150];
K_leftTurn = 4;
% mu_leftTurn = mu_ite(:,:,50);
% sigma_leftTurn = sigma_ite(:,:,:,50);
% eta_leftTurn = eta_ite(:,:,50);


g_num_fun= @(data,mu_g,sigma_g,astar,bstar) mvnpdf(data,mu_g,sigma_g)/((mvncdf([bstar(1),bstar(2),bstar(3)],mu_g,sigma_g)-mvncdf([astar(1),bstar(2),bstar(3)],mu_g,sigma_g))...
    +(mvncdf([bstar(1),astar(2),astar(3)],mu_g,sigma_g)-mvncdf([astar(1),astar(2),astar(3)],mu_g,sigma_g))...
    -(mvncdf([bstar(1),astar(2),bstar(3)],mu_g,sigma_g)-mvncdf([astar(1),astar(2),bstar(3)],mu_g,sigma_g))...
    -(mvncdf([bstar(1),bstar(2),astar(3)],mu_g,sigma_g)-mvncdf([astar(1),bstar(2),astar(3)],mu_g,sigma_g))...
    );
pdf_leftTurn = 0;
for i = 1:K_leftTurn
    pdf_leftTurn = pdf_leftTurn + eta_leftTurn(i) * g_num_fun([v,vl,R],mu_leftTurn(i,:),sigma_leftTurn(:,:,i),astar_leftTurn,bstar_leftTurn);
end
end