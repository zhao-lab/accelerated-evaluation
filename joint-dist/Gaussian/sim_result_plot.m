% sim plot

clear


load('sim_results_1')

total_data=input_data;

returns=Indicator_monIS;


% IS_score_monIS=pdf_gaussian_mixture( data_samples, K, eta_data, mu_data, sigma_data, astar,bstar )./pdf_gaussian_mixture_sampling( data_samples, K, eta_data, A_I, A_O,rho , sigma_data, astar,bstar );
    
load('sim_results_2')

total_data=[total_data;input_data];

returns=[returns;Indicator_monIS];

% IS_score_monIS=[IS_score_monIS;pdf_gaussian_mixture( input_data, K, eta_data, mu_data, sigma_data, astar,bstar )./pdf_gaussian_mixture_sampling( input_data, K, eta_data, A_I, A_O,rho , sigma_data, astar,bstar )];

load('sim_results_3')

total_data=[total_data;input_data];

returns=[returns;Indicator_monIS];

% IS_score_monIS=[IS_score_monIS;pdf_gaussian_mixture( input_data, K, eta_data, mu_data, sigma_data, astar,bstar )./pdf_gaussian_mixture_sampling( input_data, K, eta_data, A_I, A_O,rho , sigma_data, astar,bstar )];

load('sim_results_4')

total_data=[total_data;input_data];

returns=[returns;Indicator_monIS];

load('sim_results_5')

total_data=[total_data;input_data];

returns=[returns;Indicator_monIS];

load('sim_results_6')

total_data=[total_data;input_data];

returns=[returns;Indicator_monIS];

load('sim_results_7')

total_data=[total_data;input_data];

returns=[returns;Indicator_monIS];

load('sim_results_8')

total_data=[total_data;input_data];

returns=[returns;Indicator_monIS];

load('sim_results_9')

total_data=[total_data;input_data];

returns=[returns;Indicator_monIS];

load('sim_results_10')

total_data=[total_data;input_data];

returns=[returns;Indicator_monIS];
% IS_score_monIS=[IS_score_monIS;pdf_gaussian_mixture( input_data, K, eta_data, mu_data, sigma_data, astar,bstar )./pdf_gaussian_mixture_sampling( input_data, K, eta_data, A_I, A_O,rho , sigma_data, astar,bstar )];

IS_score_monIS=pdf_gaussian_mixture( total_data, K, eta_data, mu_data, sigma_data, astar,bstar )./pdf_gaussian_mixture_sampling( total_data, K, eta_data, A_I, A_O,rho , sigma_data, astar,bstar );


output_monIS=returns.*IS_score_monIS;


    mean_step_mon=zeros(100,1);
    ci_step_mon=zeros(100,1);
    step_N=10000:10000:1*10^6;
    for i=1:100
        mean_step_mon(i)=mean(output_monIS(1:step_N(i)));
        ci_step_mon(i)=1.96*std(output_monIS(1:step_N(i)))/sqrt(step_N(i));
    end
    figure(1)
    plot(step_N,mean_step_mon,'b')
xlabel('Number of Experiments')
ylabel('Crash Probability Estimation')
    figure(2)
    plot(step_N,ci_step_mon,'r-.')
xlabel('Number of Experiments')
ylabel('95% Confidence Half Width')
