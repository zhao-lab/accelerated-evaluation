%% generate truncated mixture gaussian
clear
MU=[1,3];
MU2=[5,1];
SIGMA=[5,2;2,3];
SIGMA2=[2,1;1,8];

s=[0,-6];
t=[Inf,6];


PI=0.6;

rng(123)

pi_rnd=rand(500,1);
pi_ind=pi_rnd>0.6;


data_raw_1=mvnrnd(MU,SIGMA,sum(pi_ind));
data_raw_2=mvnrnd(MU2,SIGMA2,sum(~pi_ind));

data_raw=[data_raw_1;data_raw_2];

% truncate data
data_set=data_raw;
data_set(data_raw(:,1)<=0 | data_raw(:,2)<=-6 |data_raw(:,2)>=6,:)=[];

g_num_fun= @(data,mu_g,sigma_g) mvnpdf(data,mu_g,sigma_g)/(mvncdf(t,mu_g,sigma_g)+mvncdf(s,mu_g,sigma_g)...
                                                          -mvncdf([s(1),t(2)],mu_g,sigma_g)-mvncdf([s(2),t(1)],mu_g,sigma_g)...
                                                          );
N_count=0;
N_data=size(data_set,1);

K=2;
    para_initial=init_kmeans(data_set,K);
    pi_hat=para_initial{1}.pp;
    mu_hat=para_initial{1}.mu;
    sigma_hat=para_initial{1}.C;
    
    eta_denom=0;
    eta_numer=zeros(1,K);
    for i=1:K
       eta_numer(i)=pi_hat(i)*(mvncdf(t,mu_hat(i,:),sigma_hat(:,:,i))+mvncdf(s,mu_hat(i,:),sigma_hat(:,:,i))...
                                             -mvncdf([s(1),t(2)],mu_hat(i,:),sigma_hat(:,:,i))-mvncdf([s(2),t(1)],mu_hat(i,:),sigma_hat(:,:,i))...
                                                          );
       eta_denom=eta_denom+eta_numer(i);         
        
    end
    eta_hat=eta_numer/eta_denom;
    % Start EM algorithm
    converge_flag=false;
    
    while ~converge_flag
%     for maxit=1:300
        % E step
        z_n=zeros(N_data,K);
        for i=1:N_data
            z_n_nume=zeros(1,K);
            z_n_denom=0;
            for j=1:K
                z_n_nume(j)=eta_hat(j)*g_num_fun(data_set(i,:),mu_hat(j,:),sigma_hat(:,:,j));
                z_n_denom=z_n_denom+z_n_nume(j);
            end
            z_n(i,:)=z_n_nume/z_n_denom;
        end
        
        % M step
        eta_hat_new=mean(z_n);
        mu_hat_new=zeros(K,2);
        sigma_hat_new=zeros(2,2,K);
        
        % compute first and second moment
        
        
        for i=1:K
            [tmu,tcov,talpha]=tmvn_m3([0,0], sigma_hat(:,:,i), s-mu_hat(i,:), t-mu_hat(i,:));
            m_k=tmu;
            H_k=sigma_hat(:,:,i)-(tcov+tmu'*tmu);           
            
            mu_hat_new(i,:)=sum(repmat(z_n(:,i),1,2).*data_set)/sum(z_n(:,i))-m_k;
            
            sigma_add=zeros(2,2);
            for j=1:N_data
                sigma_add=sigma_add+z_n(j,i)*(data_set(j,:)-mu_hat_new(i,:))'*(data_set(j,:)-mu_hat_new(i,:));
            end
            sigma_hat_new(:,:,i)= sigma_add/sum(z_n(:,i))+H_k;
            
        end
        
        if all(abs(eta_hat-eta_hat_new)<0.01)&& all(all(abs(mu_hat-mu_hat_new)<0.01)) && all(all(all(abs(sigma_hat-sigma_hat_new)<0.01)))
            converge_flag=true;
        end
        N_count=N_count+1;
        
        if N_count>K*300
            converge_flag=true;
        end
        
        eta_hat=eta_hat_new;
        mu_hat=mu_hat_new;
        sigma_hat=sigma_hat_new;
    end



