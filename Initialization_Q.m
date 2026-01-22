function Fs = Initialization_Q(X, numClusters, k)
    % 使用谱嵌入初始化 Q
    v = length(X);
    Q = cell(1,v);
    % n = size(X, 2);
    % for idx = 1:v
    % 
    %     W = constructW_PKN(X{idx}',10); % similarity matrix % 相似度矩阵
    %     D = diag(sum(W, 2)); % 度矩阵
    %     L = D - W; % 拉普拉斯矩阵
    %     [V, ~] = eigs(L, numClusters, 'smallestabs');
    %     Q = V';
    % end
numsamples = size(X{1},2);
   for idx = 1:v
       A0 = constructW_PKN(X{idx},k); % similarity matrix  round(sqrt(numsamples))
       A0 = A0-diag(diag(A0));
       A10 = (A0+A0')/2;
       D10 = diag(1./sqrt(sum(A10, 2)));
       St = D10*A10*D10;
       [Ft,~,~] = svds(St,numClusters);
       Ss{idx} = St;
       Fs{idx} = Ft;
    end
end