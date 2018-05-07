% 
clear
load('IS_result.mat')


N_test=10^5;


%% trivial IS
v_trIS=rand(N_test,1)*30+5;
invR_trIS=exprnd( 0.02,N_test,1)+1/75;
invTTC_trIS=exprnd( 0.6,N_test,1);

%% new IS

I_or_O=mnrnd(N_test,[rho 1-rho]);
    data_samples=[];
    
    if I_or_O(1)>0
        outer_rnd_I = mnrnd(I_or_O(1),eta_data);
        for i=1:K
            if outer_rnd_I(i)>0
                inner_rnd = mnrnd(outer_rnd_I(i),ones(1,size(A_I{i},1))/size(A_I{i},1));
                for j=1:size(A_I{i},1)
                    if inner_rnd(j)>0
                         mixture_temp=mvnrnd(A_I{i}(j,:),sigma_data(:,:,i),inner_rnd(j)*10);
                         index_take=mixture_temp(:,1)>astar(1)&mixture_temp(:,1)<bstar(1)&mixture_temp(:,2)>astar(2)&mixture_temp(:,2)<bstar(2)&mixture_temp(:,3)>astar(3)&mixture_temp(:,3)<bstar(3);
                         mixture_take=mixture_temp(index_take,:);

                         while size(mixture_take,1)<inner_rnd(j)
                            mixture_temp=mvnrnd(A_I{i}(j,:),sigma_data(:,:,i),inner_rnd(j)*10);
                            index_take=mixture_temp(:,1)>astar(1)&mixture_temp(:,1)<bstar(1)&mixture_temp(:,2)>astar(2)&mixture_temp(:,2)<bstar(2)&mixture_temp(:,3)>astar(3)&mixture_temp(:,3)<bstar(3);
                            mixture_take=[mixture_take;mixture_temp(index_take,:)];
                         end

                         mixture_samples=mixture_take(1:inner_rnd(j),:);

                         data_samples=[data_samples;mixture_samples];
                    end
                end
            end    
        end
    end
    
    if I_or_O(2)>0
        outer_rnd_O = mnrnd(I_or_O(2),eta_data);
        for i=1:K
            if outer_rnd_O(i)>0
                inner_rnd_O = mnrnd(outer_rnd_O(i),ones(1,size(A_O{i},1))/size(A_O{i},1));
                for j=1:size(A_O{i},1)
                    if inner_rnd_O(j)>0
                         mixture_temp=mvnrnd(A_O{i}(j,:),sigma_data(:,:,i),inner_rnd_O(j)*10);
                         index_take=mixture_temp(:,1)>astar(1)&mixture_temp(:,1)<bstar(1)&mixture_temp(:,2)>astar(2)&mixture_temp(:,2)<bstar(2)&mixture_temp(:,3)>astar(3)&mixture_temp(:,3)<bstar(3);
                         mixture_take=mixture_temp(index_take,:);

                         while size(mixture_take,1)<inner_rnd_O(j)
                            mixture_temp=mvnrnd(A_O{i}(j,:),sigma_data(:,:,i),inner_rnd_O(j)*10);
                            index_take=mixture_temp(:,1)>astar(1)&mixture_temp(:,1)<bstar(1)&mixture_temp(:,2)>astar(2)&mixture_temp(:,2)<bstar(2)&mixture_temp(:,3)>astar(3)&mixture_temp(:,3)<bstar(3);
                            mixture_take=[mixture_take;mixture_temp(index_take,:)];
                         end

                         mixture_samples=mixture_take(1:inner_rnd_O(j),:);

                         data_samples=[data_samples;mixture_samples];
                    end
                end
            end    
        end
    end
    %step 4  
    %indicator function
    input_data=data_samples.*fitting_data.var_Std+fitting_data.center;
    
    %% simulation part
    
    Indicator_trIS=lane_change_model_vector(v_trIS,invTTC_trIS,invR_trIS);
    Indicator_monIS=lane_change_model_vector(input_data(:,1),input_data(:,3),input_data(:,2));
    
    
    
    %% IS score part
    
    IS_score_trIS=pdf_gaussian_mixture( ([v_trIS,invR_trIS,invTTC_trIS]-fitting_data.center)./fitting_data.var_Std, K, eta_data, mu_data, sigma_data, astar,bstar )./(prod(fitting_data.var_Std)*1/(35-5)*exppdf(invR_trIS-1/75,0.02)   .* exppdf (invTTC_trIS,0.6)    );
    
    IS_score_monIS=pdf_gaussian_mixture( input_data, K, eta_data, mu_data, sigma_data, astar,bstar )./pdf_gaussian_mixture_sampling( input_data, K, eta_data, A_I, A_O,rho , sigma_data, astar,bstar );
    
    
    %% results
    
    output_trIS=Indicator_trIS.*IS_score_trIS;
    
    output_monIS=Indicator_monIS.*IS_score_monIS;
    
    
    mean_trIS=mean(output_trIS);
    mean_monIS=mean(output_monIS);
    ci_trIS=1.96*std(output_trIS)/sqrt(10^5);
    ci_monIS=1.96*std(output_monIS)/sqrt(10^5);
    
    result_table=[mean_trIS,mean_monIS;ci_trIS,ci_monIS]
    
    mean_step_tr=zeros(100,1);
    ci_step_tr=zeros(100,1);
    mean_step_mon=zeros(100,1);
    ci_step_mon=zeros(100,1);
    step_N=1000:1000:10^5;
    for i=1:100
        mean_step_tr(i)=mean(output_trIS(1:step_N(i)));
        ci_step_tr(i)=mean(output_monIS(1:step_N(i)));
        mean_step_mon(i)=1.96*std(output_trIS(1:step_N(i)))/sqrt(step_N(i));
        ci_step_mon(i)=1.96*std(output_monIS(1:step_N(i)))/sqrt(step_N(i));
    end
    figure(1)
    plot(step_N,mean_step_tr,'b',step_N,mean_step_mon,'r')
    figure(2)
    plot(step_N,ci_step_tr,'b',step_N,ci_step_mon,'r')