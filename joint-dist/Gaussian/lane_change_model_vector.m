function [ nCrashL_mat ] = lane_change_model_vector(  vLIni_mat,X_InvTTC_mat,X_InvR_mat )
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here
N_vec=length(vLIni_mat);
nCrashL_mat=zeros(N_vec,1);
for i=1:N_vec
    nCrashL_mat(i)=lane_change_model_one_run(  vLIni_mat(i),X_InvTTC_mat(i),X_InvR_mat(i) );
    disp(i)
end

end

