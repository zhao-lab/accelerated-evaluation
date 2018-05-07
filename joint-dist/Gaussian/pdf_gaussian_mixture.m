function [ pdf_outarg ] = pdf_gaussian_mixture( data, K, eta_hat, mu_hat, sigma_hat, astar,bstar )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

    g_num_fun= @(data,mu_g,sigma_g) mvnpdf(data,mu_g,sigma_g)/((mvncdf([bstar(1),bstar(2),bstar(3)],mu_g,sigma_g)-mvncdf([astar(1),bstar(2),bstar(3)],mu_g,sigma_g))...
                                                              +(mvncdf([bstar(1),astar(2),astar(3)],mu_g,sigma_g)-mvncdf([astar(1),astar(2),astar(3)],mu_g,sigma_g))...
                                                              -(mvncdf([bstar(1),astar(2),bstar(3)],mu_g,sigma_g)-mvncdf([astar(1),astar(2),bstar(3)],mu_g,sigma_g))...
                                                              -(mvncdf([bstar(1),bstar(2),astar(3)],mu_g,sigma_g)-mvncdf([astar(1),bstar(2),astar(3)],mu_g,sigma_g))...
                                                              );
    pdf_outarg=zeros(size(data,1),1);
    for j=1:K
        part_pdf=eta_hat(j)*g_num_fun(data,mu_hat(j,:),sigma_hat(:,:,j));
        pdf_outarg=pdf_outarg+part_pdf;
    end                                                      
                
                                             
                                                      

end

