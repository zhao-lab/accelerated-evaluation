%%
% 3 dim truncated at s=[5,0,1/75] and t =[35,inf,inf]
clear
fitting_data=load('fitting_result_leftTurn_K = 4.mat','eta_ite','mu_ite','sigma_ite');
astar=[0 0 0];
bstar=[30 60 150];

rng(123)
% astar=(astar-fitting_data.center)./fitting_data.var_Std;
% bstar=(bstar-fitting_data.center)./fitting_data.var_Std;

eta_hat=fitting_data.eta_ite(:,:,end);
mu_hat=fitting_data.mu_ite(:,:,end);
sigma_hat=fitting_data.sigma_ite(:,:,:,end);

eta_data=round(eta_hat,6); % parameters of mixture
eta_data(1)=eta_data(1)+(1-sum(eta_data));
mu_data=mu_hat;
sigma_data=sigma_hat;

K=size(eta_data,2);
A_I=cell(K,1);
A_O=cell(K,1);
% initial
for i=1:K
    A_I{i}=mu_data(i,:);
    A_O{i}=mu_data(i,:);
end
    S_0=[];
    S_1=[];
    
    N_count=1;
    N_max=10;
    N_data_iter=100;
    Set_max=inf;
    stop_flag=0;
while ~stop_flag
    % step 2 and step 3
    
    if isempty(S_1)
        rho=0;
    else
        rho=1/2;
    end
        
    I_or_O=mnrnd(N_data_iter,[rho 1-rho]);
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
%     input_data=data_samples.*fitting_data.var_Std+fitting_data.center;
    input_data=data_samples;

    index_indicator=lane_change_model_vector_adaptive_rdot(  input_data(:,1),input_data(:,2),input_data(:,3),0);  % where we use the simulation
    index_indicator=index_indicator>0;
    
    S_0=[S_0;data_samples(~index_indicator,:)];
    S_1=[S_1;data_samples(index_indicator,:)];
    
    mono_direc=[-1 1 1]; % monotonic direction    -1:smaller--rare event     1:larger--rare event 
    index_s0=paretofronts(S_0,-mono_direc); % monotonic direction 
    index_s1=paretofronts(S_1,mono_direc); 
    
    S_0=S_0(index_s0>0,:);
    S_1=S_1(index_s1>0,:);
    
    %step 5
    if ~isempty(S_1)
        for i=1:K
            A_I{i}=[];
            for j=1:size(S_1,1)

                cvx_begin
                    variable x(3);
                    minimize ((x-mu_data(i,:)')'*sigma_data(:,:,i)*(x-mu_data(i,:)'))
                    subject to

                    x(1) <= S_1(j,1);
                    x(2) >= S_1(j,2);
                    x(3) >= S_1(j,3);
                    x(1) >= astar(1);

                cvx_end
                if isequal(cvx_status,'Solved' )
                    A_I{i}=[A_I{i};x'];
                end

            end
        end
    end
    
    %step 6
    
    for i=1:K
        A_O{i}=[];
        N_set_0=size(S_0,1);
        pos_comb=fullfact(ones(1,3)*N_set_0);
        
        for j=1:size(pos_comb,1);

            cvx_begin
                variable x(3);
                minimize ((x-mu_data(i,:)')'*sigma_data(:,:,i)*(x-mu_data(i,:)'))
                subject to
                
                x(1) <= S_0(pos_comb(j,1),1);
                x(2) <= S_0(pos_comb(j,2),2); 
                x(3) <= S_0(pos_comb(j,3),3); 
                x(1) >= astar(1);
                x(2) >= astar(2);
                x(3) >= astar(3);
                
            cvx_end
            if isequal(cvx_status,'Solved' )
            A_O{i}=[A_O{i};x'];
            end
                       
        end
    end
    
    N_count=N_count+1;
    if N_count>N_max
        stop_flag=1;
    end
    
    if size(A_O{i},1)>Set_max
        stop_flag=1;
    end
    
    if size(A_I{i},1)>Set_max
        stop_flag=1;
    end    
end
save('IS_construct_leftTurn.mat')
