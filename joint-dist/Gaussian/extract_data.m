load('Velocity_Data.mat')
load('InvRAll_mat.mat')
load('InvTTC_mat.mat')
mixture_data=[Data.vL Data.InvRange -Data.InvTTC];
all(mixture_data>0)
all(mixture_data>=1/75)
all(mixture_data>=5)
mixture_data(mixture_data(:,1)<5 |mixture_data(:,1)>35,: )=[];