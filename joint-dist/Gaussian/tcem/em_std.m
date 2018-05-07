function param = em_std(x, K, init)

str_start.mu = init.mu;
str_start.Sigma = init.C;
str_start.PComponents = init.pp;

res_obj = gmdistribution.fit(x, K, 'Start', str_start);

param.pp = res_obj.PComponents;
param.mu = res_obj.mu;
param.C = res_obj.Sigma;
