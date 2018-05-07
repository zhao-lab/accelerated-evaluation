%% set up
% load distribution model
% clear
fitting_data=load('test_fitting_result_leftTurn_K=8.mat','eta_ite','mu_ite','sigma_ite');

randNumber = 123;
N_simulate=5000;
K = 8;
% load IS distribution model

IS_10000=load('IS_information_Left_turn_Raw_10000.mat','S_0','S_1','A_I','A_O','K','mu_data','sigma_data','eta_data');
IS_10000_refined=load('IS_information_Left_turn_Refined_10000','refined_A_I','refined_A_O');
IS_1000=load('IS_information_Left_turn_Raw_1000.mat','S_0','S_1','A_I','A_O','K','mu_data','sigma_data','eta_data');
IS_1000_refined=load('IS_information_Left_turn_Refined_1000','refined_A_I','refined_A_O');

S_0=IS_10000.S_0;
S_1=IS_10000.S_1;

eta_data=fitting_data.eta_ite(:,:,end);
mu_data=fitting_data.mu_ite(:,:,end);
sigma_data=fitting_data.sigma_ite(:,:,:,end);
eta_data=round(eta_data,6); % parameters of mixture
eta_data(1)=eta_data(1)+(1-sum(eta_data));

rng(randNumber)
astar=[0 0 0];
bstar=[30 60 150];

rho1=0.5;
rho2=1;
rho3=0;

RMin=2;

%% generate samples
runningStep = 0;
% IS
runningStep = runningStep + 1;
disp(runningStep);
IS_4_samples_raw_rho_5= rnd_gaussian_bound_mixture_sampling( eta_data,mu_data,sigma_data ,astar,bstar,IS_10000.A_I, IS_10000.A_O,rho1,N_simulate,K);
% IS_4_samples_raw_rho_1= rnd_gaussian_bound_mixture_sampling( eta_data,mu_data,sigma_data ,astar,bstar,IS_10000.A_I, IS_10000.A_O,rho2,N_simulate,K);
% IS_4_samples_raw_rho_0= rnd_gaussian_bound_mixture_sampling( eta_data,mu_data,sigma_data ,astar,bstar,IS_10000.A_I, IS_10000.A_O,rho3,N_simulate,K);
IS_3_samples_raw_rho_5= rnd_gaussian_bound_mixture_sampling( eta_data,mu_data,sigma_data ,astar,bstar,IS_1000.A_I, IS_1000.A_O,rho1,N_simulate,K);

% Refined IS
runningStep = runningStep + 1;
disp(runningStep);
IS_4_samples_refined_rho_5= rnd_gaussian_bound_mixture_sampling( eta_data,mu_data,sigma_data ,astar,bstar,IS_10000_refined.refined_A_I, IS_10000_refined.refined_A_O,rho1,N_simulate,K);
% IS_4_samples_refined_rho_1= rnd_gaussian_bound_mixture_sampling( eta_data,mu_data,sigma_data ,astar,bstar,IS_10000_refined.refined_A_I, IS_10000_refined.refined_A_O,rho2,N_simulate,K);
% IS_4_samples_refined_rho_0= rnd_gaussian_bound_mixture_sampling( eta_data,mu_data,sigma_data ,astar,bstar,IS_10000_refined.refined_A_I, IS_10000_refined.refined_A_O,rho3,N_simulate,K);
IS_3_samples_refined_rho_5= rnd_gaussian_bound_mixture_sampling( eta_data,mu_data,sigma_data ,astar,bstar,IS_1000_refined.refined_A_I, IS_1000_refined.refined_A_O,rho1,N_simulate,K);



%% simulate

% IS
runningStep = runningStep + 1;
disp(runningStep);
output_4_raw_5=left_turn_model_vector_adaptive_rdot(  IS_4_samples_raw_rho_5(:,1),IS_4_samples_raw_rho_5(:,2),IS_4_samples_raw_rho_5(:,3),RMin );
% output_4_raw_1=left_turn_model_vector_adaptive_rdot(  IS_4_samples_raw_rho_1(:,1),IS_4_samples_raw_rho_1(:,2),IS_4_samples_raw_rho_1(:,3),RMin );
% output_4_raw_0=left_turn_model_vector_adaptive_rdot(  IS_4_samples_raw_rho_0(:,1),IS_4_samples_raw_rho_0(:,2),IS_4_samples_raw_rho_0(:,3),RMin );
output_3_raw_5=left_turn_model_vector_adaptive_rdot(  IS_3_samples_raw_rho_5(:,1),IS_3_samples_raw_rho_5(:,2),IS_3_samples_raw_rho_5(:,3),RMin );

% Refined IS
runningStep = runningStep + 1;
disp(runningStep);
output_4_refined_5=left_turn_model_vector_adaptive_rdot(  IS_4_samples_refined_rho_5(:,1),IS_4_samples_refined_rho_5(:,2),IS_4_samples_refined_rho_5(:,3),RMin );
% output_4_refined_1=left_turn_model_vector_adaptive_rdot(  IS_4_samples_refined_rho_1(:,1),IS_4_samples_refined_rho_1(:,2),IS_4_samples_refined_rho_1(:,3),RMin );
% output_4_refined_0=left_turn_model_vector_adaptive_rdot(  IS_4_samples_refined_rho_0(:,1),IS_4_samples_refined_rho_0(:,2),IS_4_samples_refined_rho_0(:,3),RMin );
output_3_refined_5=left_turn_model_vector_adaptive_rdot(  IS_3_samples_refined_rho_5(:,1),IS_3_samples_refined_rho_5(:,2),IS_3_samples_refined_rho_5(:,3),RMin );

%% approximate

monotone_direction=[1 -1 -1];

% IS
runningStep = runningStep + 1;
disp(runningStep);
[outer_appr_4_raw_5 inner_appr_4_raw_5]=left_turn_monotone_approaximate( IS_4_samples_raw_rho_5(:,1),IS_4_samples_raw_rho_5(:,2),IS_4_samples_raw_rho_5(:,3),S_0,S_1,monotone_direction);
% [outer_appr_4_raw_1 inner_appr_4_raw_1]=left_turn_monotone_approaximate( IS_4_samples_raw_rho_1(:,1),IS_4_samples_raw_rho_1(:,2),IS_4_samples_raw_rho_1(:,3),S_0,S_1,monotone_direction);
% [outer_appr_4_raw_0 inner_appr_4_raw_0]=left_turn_monotone_approaximate( IS_4_samples_raw_rho_0(:,1),IS_4_samples_raw_rho_0(:,2),IS_4_samples_raw_rho_0(:,3),S_0,S_1,monotone_direction);
[outer_appr_3_raw_5 inner_appr_3_raw_5]=left_turn_monotone_approaximate( IS_3_samples_raw_rho_5(:,1),IS_3_samples_raw_rho_5(:,2),IS_3_samples_raw_rho_5(:,3),S_0,S_1,monotone_direction);

% Refined IS
runningStep = runningStep + 1;
disp(runningStep);
[outer_appr_4_refined_5 inner_appr_4_refined_5]=left_turn_monotone_approaximate( IS_4_samples_refined_rho_5(:,1),IS_4_samples_refined_rho_5(:,2),IS_4_samples_refined_rho_5(:,3),S_0,S_1,monotone_direction);
% [outer_appr_4_refined_1 inner_appr_4_refined_1]=left_turn_monotone_approaximate( IS_4_samples_refined_rho_1(:,1),IS_4_samples_refined_rho_1(:,2),IS_4_samples_refined_rho_1(:,3),S_0,S_1,monotone_direction);
% [outer_appr_4_refined_0 inner_appr_4_refined_0]=left_turn_monotone_approaximate( IS_4_samples_refined_rho_0(:,1),IS_4_samples_refined_rho_0(:,2),IS_4_samples_refined_rho_0(:,3),S_0,S_1,monotone_direction);
[outer_appr_3_refined_5 inner_appr_3_refined_5]=left_turn_monotone_approaximate( IS_3_samples_refined_rho_5(:,1),IS_3_samples_refined_rho_5(:,2),IS_3_samples_refined_rho_5(:,3),S_0,S_1,monotone_direction);

%%

runningStep = runningStep + 1;
disp(runningStep);
pause(1);
score_4_raw_5=pdf_gaussian_mixture( IS_4_samples_raw_rho_5, K, eta_data, mu_data, sigma_data, astar,bstar )./pdf_gaussian_mixture_sampling( IS_4_samples_raw_rho_5, K, eta_data, IS_10000.A_I, IS_10000.A_O,rho1 , sigma_data, astar,bstar );
% score_4_raw_1=pdf_gaussian_mixture( IS_4_samples_raw_rho_1, K, eta_data, mu_data, sigma_data, astar,bstar )./pdf_gaussian_mixture_sampling( IS_4_samples_raw_rho_1, K, eta_data, IS_10000.A_I, IS_10000.A_O,rho2 , sigma_data, astar,bstar );
% score_4_raw_0=pdf_gaussian_mixture( IS_4_samples_raw_rho_0, K, eta_data, mu_data, sigma_data, astar,bstar )./pdf_gaussian_mixture_sampling( IS_4_samples_raw_rho_0, K, eta_data, IS_10000.A_I, IS_10000.A_O,rho3 , sigma_data, astar,bstar );
score_3_raw_5=pdf_gaussian_mixture( IS_3_samples_raw_rho_5, K, eta_data, mu_data, sigma_data, astar,bstar )./pdf_gaussian_mixture_sampling( IS_3_samples_raw_rho_5, K, eta_data, IS_1000.A_I, IS_1000.A_O,rho1 , sigma_data, astar,bstar );



runningStep = runningStep + 1;
disp(runningStep);
pause(1);
score_4_refined_5=pdf_gaussian_mixture( IS_4_samples_refined_rho_5, K, eta_data, mu_data, sigma_data, astar,bstar )./pdf_gaussian_mixture_sampling( IS_4_samples_refined_rho_5, K, eta_data, IS_10000_refined.refined_A_I, IS_10000_refined.refined_A_O,rho1 , sigma_data, astar,bstar );
% score_4_refined_1=pdf_gaussian_mixture( IS_4_samples_refined_rho_1, K, eta_data, mu_data, sigma_data, astar,bstar )./pdf_gaussian_mixture_sampling( IS_4_samples_refined_rho_1, K, eta_data, IS_10000_refined.refined_A_I, IS_10000_refined.refined_A_O,rho2 , sigma_data, astar,bstar );
% score_4_refined_0=pdf_gaussian_mixture( IS_4_samples_refined_rho_0, K, eta_data, mu_data, sigma_data, astar,bstar )./pdf_gaussian_mixture_sampling( IS_4_samples_refined_rho_0, K, eta_data, IS_10000_refined.refined_A_I, IS_10000_refined.refined_A_O,rho3 , sigma_data, astar,bstar );
score_3_refined_5=pdf_gaussian_mixture( IS_3_samples_refined_rho_5, K, eta_data, mu_data, sigma_data, astar,bstar )./pdf_gaussian_mixture_sampling( IS_3_samples_refined_rho_5, K, eta_data, IS_1000_refined.refined_A_I, IS_1000_refined.refined_A_O,rho1 , sigma_data, astar,bstar );


filename = ['afterrunning_simulation_compare_leftTurn20171212_with_rng_' num2str(randNumber)];
save(filename);