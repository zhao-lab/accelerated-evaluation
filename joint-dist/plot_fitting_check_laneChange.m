%% lane Change
raw_data=load('LaneChangeEvents.mat');
fitting_data=load('fitting_result_LaneChange_K = 25.mat','eta_ite','mu_ite','sigma_ite');
astar=[5 0 1/75]; % boundary
bstar=[35 30 Inf];
rng(123)
% astar=(astar-fitting_data.center)./fitting_data.var_Std;
% bstar=(bstar-fitting_data.center)./fitting_data.var_Std;
mixture_data=raw_data.mixture_data;
eta_hat=fitting_data.eta_ite(:,:,end);
mu_hat=fitting_data.mu_ite(:,:,end);
sigma_hat=fitting_data.sigma_ite(:,:,:,end);

figure()
hist3(mixture_data(:,1:2),[20,20])
[a b]=hist3(mixture_data(:,1:2),[20,20]);
surf(b{1},b{2},a)
hist3(mixture_data(:,1:2),[20,20])

[density_plot_x,density_plot_y]=meshgrid(b{1},b{2});
density_value=density_plot_x*0;
for i=1:22
    for j=1:20
        for k=1:20
            density_value(j,k)=density_value(j,k)+eta_hat(i)*mvnpdf([density_plot_x(j,k),density_plot_y(j,k)],mu_hat(i,1:2),sigma_hat(1:2,1:2,i));
            
        end
    end
    
end
figure(3)
surf(b{1},b{2},density_value)