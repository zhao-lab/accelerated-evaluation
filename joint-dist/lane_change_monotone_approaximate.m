function [ outer_approx inner_approx ] = lane_change_monotone_approaximate( vLIni_mat,X_Rdot_mat,X_InvR_mat,S_0,S_1,monotone_direction)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    outer_approx=true(size(vLIni_mat,1),1);

    for i=1:size(S_0)
        not_legit_for_i= vLIni_mat< monotone_direction(1)*S_0(i,1) && X_Rdot_mat < monotone_direction(2)*S_0(i,2) && X_InvR_mat < monotone_direction(3)*S_0(i,3); 
        outer_approx(~not_legit_for_i)=false;
        
    end


    inner_approx=true(size(vLIni_mat,1),1);

    for i=1:size(S_1)
        legit_for_i= vLIni_mat> monotone_direction(1)*S_1(i,1) && X_Rdot_mat > monotone_direction(2)*S_1(i,2) && X_InvR_mat > monotone_direction(3)*S_1(i,3); 
        inner_approx(~legit_for_i)=false;
        
    end




end

