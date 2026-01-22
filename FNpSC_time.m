function [resmean, resstd, obj, de, times] = FNpSC_time(X, numClust, P, Z ,Q, k_new, gnd, Dname)

% nv = length(X);
obj = zeros(1,20);
de = obj;
Y = Q{1};
prevObjective = 0;
n = size(Z{1},1);
v = length(X);
numSamp = n;
numDim = zeros(1,v);
% times = zeros(1,20);
tic
for iter = 1:100
    
    objective = 0;
    Zq = zeros(n,numClust);
    for i = 1:v
        P{i} = updata_nP(P{i}, X{i}, Z{i}, k_new{i}); % 
        D = P{i}*X{i};
        DTD = D'*D;
        DDT = D*D';
        numDim(i) = k_new{i};
        % Z{i} = inv(D + eye(n)) * (D + Y * Q{i}');
        if numSamp < numDim(i)
            tempZ = (DTD + mu*eye(numSamp,numSamp))\eye(numSamp,numSamp);
        else 
            tempZ = eye(numSamp,numSamp) - D'*inv(eye(numDim(i),numDim(i)) + DDT)*D;
            % disp('zhixingle');
        end
        Z{i} = tempZ*(DTD + Y * Q{i}');
        Zq = Zq + Z{i}* Q{i};
    end
    [Uy, ~, Vy] = svds(Zq,numClust);
    Y = Uy*Vy';
    for i = 1:v
        Q{i} = Z{i}'*Y; 
        term1 = norm(P{i} * X{i} - P{i} * X{i} * Z{i}, 'fro')^2;
        term2 = norm(Z{i} - Y * Q{i}', 'fro')^2;
        objective = objective + term1 + term2;
    end
    obj(iter) = objective;
    de(iter) = abs(prevObjective - objective)/prevObjective;
    % fprintf('Iteration %d, Objective: %.6f, de: %.6f\n', iter, objective, de(iter));
    
    % if iter >= 3 
        times = toc;
        if (de(iter) <1e-2 || objective < 0.01) &&iter >= 3 % && iter>=20 gnamegname
            [resmax, resmean, resstd, pre_y, result] = result_y(Y, gnd, numClust);
        save(['res_' Dname],"resmax","resstd","resmean","obj","de", "times","pre_y","Y","gnd","numClust","result")
            break;
        end
    % end
    prevObjective = objective;
end

end