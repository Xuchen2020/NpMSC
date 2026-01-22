function [P_res] = updata_nP(P, X, Z, d)

[n, p] = size(P);

manifold = stiefelfactory(n, p);

% 定义目标函数
problem.M = manifold;
problem.cost = @(P) compute_cost(P, X, Z);

% 计算目标函数的辅助函数
function f = compute_cost(P, X, Z)
     f = norm(P * X - P * X * Z, 'fro')^2;
end

% 定义梯度函数
problem.egrad = @(P) compute_gradient(P, X, Z);

% 计算梯度的辅助函数
function g = compute_gradient(P, X, Z)
    g = -2 * (X - P * X * Z) * (X * Z)';
end
% options.maxiter = 100; 
% [P_opt, ~, ~] = steepestdescent(problem);
[P_opt, ~, ~] = conjugategradient(problem);
P_res = P_opt(:, 1 : d); % 
%      problem.M  = stiefelgeneralizedfactory(d, k,Cxx); % ά�ȴ�С
% %     problem.M  = stiefelfactory(d, k,Cxx); 
%     problem.cost = @cost;
%     function f = cost(W)
%         f = trace((W'*XE-E)*Y1') + mu*norm((W'*XE-E),'fro')/2;
%     end
%     problem.egrad = @egrad;
%     function G = egrad(W)
% %         G = lambda_2*XE*(W'*XE)'+ 2*lambda_3*W'*X*Lz*X'*W;
%        G = XE*Y1' + mu*XE*(W'*XE-E)';
%     end
    % [W, costw, info1, ~] = conjugategradient(problem, W);
    
% P = W;
end

