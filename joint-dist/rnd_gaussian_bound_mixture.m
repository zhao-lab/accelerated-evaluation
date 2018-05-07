function [ data_samples ] = rnd_gaussian_bound_mixture( eta_data,mu_data,sigma_data ,astar,bstar,N_data,K)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%     K=length(eta_data);
    N_each_mixture = mnrnd(N_data,eta_data);
    data_samples=[];
        for i=1:K
            if N_each_mixture(i)>0
                mixture_temp=mvnrnd(mu_data(i,:),sigma_data(:,:,i),N_each_mixture(i)*10);
                index_take=mixture_temp(:,1)>astar(1)&mixture_temp(:,1)<bstar(1)&mixture_temp(:,2)>astar(2)&mixture_temp(:,2)<bstar(2)&mixture_temp(:,3)>astar(3)&mixture_temp(:,3)<bstar(3);
                mixture_take=mixture_temp(index_take,:);

                while size(mixture_take,1)<N_each_mixture(i)
                    mixture_temp=mvnrnd(mu_data(i,:),sigma_data(:,:,i),N_each_mixture(i)*10);
                    index_take=mixture_temp(:,1)>astar(1)&mixture_temp(:,1)<bstar(1)&mixture_temp(:,2)>astar(2)&mixture_temp(:,2)<bstar(2)&mixture_temp(:,3)>astar(3)&mixture_temp(:,3)<bstar(3);
                    mixture_take=[mixture_take;mixture_temp(index_take,:)];
                end
                
                mixture_samples=mixture_take(1:N_each_mixture(i),:);

                data_samples=[data_samples;mixture_samples];
                   
            end    
        end
end

