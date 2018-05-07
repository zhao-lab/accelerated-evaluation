function [ data_samples ] = rnd_gaussian_bound_mixture_sampling( eta_data,mu_data,sigma_data ,astar,bstar,A_I, A_O,rho,N_data,K)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%     K=length(eta_data);
%     N_each_mixture = mnrnd(N_data,eta_data);
%     data_samples=[];
%         for i=1:K
%             if N_each_mixture(i)>0
%                 mixture_temp=mvnrnd(mu_data(i,:),sigma_data(:,:,i),N_each_mixture(i)*10);
%                 index_take=mixture_temp(:,1)>astar(1)&mixture_temp(:,1)<bstar(1)&mixture_temp(:,2)>astar(2)&mixture_temp(:,2)<bstar(2)&mixture_temp(:,3)>astar(3)&mixture_temp(:,3)<bstar(3);
%                 mixture_take=mixture_temp(index_take,:);
% 
%                 while size(mixture_take,1)<N_each_mixture(i)
%                     mixture_temp=mvnrnd(mu_data(i,:),sigma_data(:,:,i),N_each_mixture(i)*10);
%                     index_take=mixture_temp(:,1)>astar(1)&mixture_temp(:,1)<bstar(1)&mixture_temp(:,2)>astar(2)&mixture_temp(:,2)<bstar(2)&mixture_temp(:,3)>astar(3)&mixture_temp(:,3)<bstar(3);
%                     mixture_take=[mixture_take;mixture_temp(index_take,:)];
%                 end
%                 
%                 mixture_samples=mixture_take(1:N_each_mixture(i),:);
% 
%                 data_samples=[data_samples;mixture_samples];
%                    
%             end    
%         end
%         
        
    I_or_O=mnrnd(N_data,[rho 1-rho]);
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
end
