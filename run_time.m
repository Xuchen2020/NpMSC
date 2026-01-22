clc;
clear;

addpath(genpath('manopt'))
addpath ClusteringMeasure

addpath other_function

ds = {'ORL','bbcsport','handwritten_mv'};
for dsi= 1:length(ds)
    Dname = ds{dsi};
    load(Dname);

gnd = Y;
nv = length(X);
n = length(gnd);
acc_index = 1;

numClust = length(unique(gnd));

for nv_idx = 1 : nv
     X{nv_idx} = normc(X{nv_idx});
end
P = {};
Z = {};
k_new = {};
nv = length(X);

for init = 1:nv
    Z{init} = zeros(size(X{1},2));
    
   % [~, s, V] = svd(X{init}, 'econ');
   %  s = diag(s);
   %  k_new{init} = length(find(s > 1));
   %  X{init} = bsxfun(@minus,X{init}, mean(X{init},2));
   %  C = cov(X{init}*X{init}');
   %  [eigvector,~]=eigs(C,k_new{init}); 
   %  X{init} = eigvector'*X{init};
   %  P{init} = eye(size(X{init},1)); 
end
% Q = Initialization_Q(X, numClust,10);
load(['init_' Dname]);

iter_max = 3;
for iter_index = 1:length(iter_max)
tic;

%% iter -- acc
for v = 1 : length(Z)
    Z{v} = zeros(size(X{1},2));
end
[resmean, resstd, obj, de, times] = FNpSC_time(X, numClust, P, Z ,Q, k_new, gnd, Dname); 
resmean
times
end
end