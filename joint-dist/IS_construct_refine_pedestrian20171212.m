dataNum = 1000;
filename = ['IS_information_pedestrian_Raw_' num2str(dataNum) '.mat'];
IS_info=load(filename,'S_0','S_1','A_I','A_O','K','mu_data','sigma_data','eta_data');



A_I=IS_info.A_I;
A_O=IS_info.A_O;
K=IS_info.K;
mu_data=IS_info.mu_data;
sigma_data=IS_info.sigma_data;
eta_data=IS_info.eta_data;

refined_A_I=cell(K,1);
refined_A_O=cell(K,1);

for i=1:K
    
            candidate_points=A_I{i};
            opt_value=zeros(size(candidate_points,1),1);
            covered=false(size(candidate_points,1),1);
            
            
            for j=1:size(candidate_points,1)
                
                opt_value(j)=((candidate_points(j,:)-mu_data(i,:))*sigma_data(:,:,i)*(candidate_points(j,:)'-mu_data(i,:)'));
                                
            end
            
            
            
            
            while ~all(covered)
                
                [temp min_I]=min(opt_value);
                
                optimal_point=candidate_points(min_I,:);
                
                refined_A_I{i}=[refined_A_I{i};optimal_point];
                
                
                gradient_vec=2*sigma_data(:,:,i)*optimal_point'-sigma_data(:,:,i)*mu_data(i,:)' ;
                
                
                covered= (candidate_points-repmat(optimal_point,size(candidate_points,1),1))*gradient_vec>=0;
                
                
                candidate_points=candidate_points(~covered,:);
                opt_value=opt_value(~covered);
            end
end


 for i=1:K
    
            candidate_points=A_O{i};
            opt_value=zeros(size(candidate_points,1),1);
            covered=false(size(candidate_points,1),1);
            
            
            for j=1:size(candidate_points,1)
                
                opt_value(j)=((candidate_points(j,:)-mu_data(i,:))*sigma_data(:,:,i)*(candidate_points(j,:)'-mu_data(i,:)'));
                                
            end
            
            
            
            
            while ~all(covered)
                
                [temp min_I]=min(opt_value);
                
                optimal_point=candidate_points(min_I,:);
                
                refined_A_O{i}=[refined_A_O{i};optimal_point];
                
                
                gradient_vec=2*sigma_data(:,:,i)*optimal_point'-sigma_data(:,:,i)*mu_data(i,:)' ;
                
                
                covered= (candidate_points-repmat(optimal_point,size(candidate_points,1),1))*gradient_vec>=0;
                
                
                candidate_points=candidate_points(~covered,:);
                opt_value=opt_value(~covered);
            end
 end
filename = ['IS_information_pedestrian_Refined_' num2str(dataNum) '.mat'];
save(filename,'refined_A_I','refined_A_O')