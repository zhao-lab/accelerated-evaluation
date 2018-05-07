function pdf_pedestrian = pdfFunc_pedestrian(v,vl,R)
% SpeedSdv,SpeedTV,Dcp (v,vl,R)
%%
load('pdfFunc_pedestrian_paras.mat')

astar_pedestrian = [0 -7 5];
bstar_pedestrian = [13 6 60];
K_pedestrian = 6;
% mu_pedestrian = mu_ite(:,:,50);
% sigma_pedestrian = sigma_ite(:,:,:,50);
% eta_pedestrian = eta_ite(:,:,50);
g_num_fun= @(data,mu_g,sigma_g,astar,bstar) mvnpdf(data,mu_g,sigma_g)/((mvncdf([bstar(1),bstar(2),bstar(3)],mu_g,sigma_g)-mvncdf([astar(1),bstar(2),bstar(3)],mu_g,sigma_g))...
    +(mvncdf([bstar(1),astar(2),astar(3)],mu_g,sigma_g)-mvncdf([astar(1),astar(2),astar(3)],mu_g,sigma_g))...
    -(mvncdf([bstar(1),astar(2),bstar(3)],mu_g,sigma_g)-mvncdf([astar(1),astar(2),bstar(3)],mu_g,sigma_g))...
    -(mvncdf([bstar(1),bstar(2),astar(3)],mu_g,sigma_g)-mvncdf([astar(1),bstar(2),astar(3)],mu_g,sigma_g))...
    );
pdf_pedestrian = 0;
for i = 1:K_pedestrian
    pdf_pedestrian = pdf_pedestrian + eta_pedestrian(i) * g_num_fun([v,vl,R],mu_pedestrian(i,:),sigma_pedestrian(:,:,i),astar_pedestrian,bstar_pedestrian);
end

%%