function [ pdf_outarg ] = pdf_gaussian_mixture_sampling( data, K, eta_hat, A_I, A_O,rho , sigma_hat, astar,bstar )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

    g_num_fun= @(data,mu_g,sigma_g) mvnpdf(data,mu_g,sigma_g)/((mvncdf([bstar(1),bstar(2),bstar(3)],mu_g,sigma_g)-mvncdf([astar(1),bstar(2),bstar(3)],mu_g,sigma_g))...
                                                              +(mvncdf([bstar(1),astar(2),astar(3)],mu_g,sigma_g)-mvncdf([astar(1),astar(2),astar(3)],mu_g,sigma_g))...
                                                              -(mvncdf([bstar(1),astar(2),bstar(3)],mu_g,sigma_g)-mvncdf([astar(1),astar(2),bstar(3)],mu_g,sigma_g))...
                                                              -(mvncdf([bstar(1),bstar(2),astar(3)],mu_g,sigma_g)-mvncdf([astar(1),bstar(2),astar(3)],mu_g,sigma_g))...
                                                              );
    pdf_outarg=zeros(size(data,1),1);
    
    
    for j=1:K
        for k=1:size(A_I{j},1)
            part_pdf=eta_hat(j)*(1/size(A_I{j},1))*g_num_fun(data,A_I{j}(k,:),sigma_hat(:,:,j));
            pdf_outarg=pdf_outarg+part_pdf;
        end
        
        for k=1:size(A_O{j},1)
            part_pdf=eta_hat(j)*(1/size(A_O{j},1))*g_num_fun(data,A_O{j}(k,:),sigma_hat(:,:,j));
            pdf_outarg=pdf_outarg+part_pdf;
        end
        
    end                                                      
                
                                                      
                                                      

end

