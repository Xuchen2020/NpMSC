function [resmax, res_mean, res_std, label, result]= result_y(Y,gnd,numclass)

stream = RandStream.getGlobalStream;
reset(stream);
U_normalized = Y ./ repmat(sqrt(sum(Y.^2, 2)), 1,size(Y,2));
maxIter = 50;
label = [];
for iter = 1:maxIter
    indx = litekmeans(U_normalized,numclass,'MaxIter',100, 'Replicates',1);
    y = kmeans(U_normalized,numclass,'maxiter',1000,'replicates',20,'EmptyAction','singleton');
    label(iter,:) = y;
%     indx = kmeans(U_normalized,numclass,'MaxIter',100, 'Replicates',1);
    indx = indx(:);
    result(iter,:) = Clustering8Measure(gnd,y);
end
resmax = max(result,[],1);
res_mean = mean(result,1);
res_std = std(result,1);
% PreY = map_Y{max_index};