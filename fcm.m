function [U,V] = fcm(X,c,m,Var_X)
% inputs:
% X - [N x d] array of feature vectors
% nc - number of clusters
% m - fuzzifier
% sigma - variance of data
% outputs:
% U - [c x N] partition matrix
% V - [c x d] cluster center vectors

% get the number of elements and feature length
[N,d] = size(X);

% set the centres of the clusters at (0,0) initially
V = initfcm(c, d);

for iter = 1:100
    
    %calculate the partition matrix
    for  i = 1:N
        for j =1: c
            % compute partition matrix entries
            U(j,i) = membership(X(k,:), V, j, m, c,Var_X);
        end
    end
     
    
    % calculate the new centres
    for j = 1:c
        V(j,:) = calc_center(U(j,:), X, m, N);
    end
    
    % calculate the objective function and print the results
    OJ = 0;
    for i = 1:N
        for j = 1:c
            OJ = OJ + (U(j,i)^m)*dist(X(i,:), V(j,:),Var_X);
        end       
    end
    
    fprintf('\n Iteration Count = %d, OJ = %4.4f',iter, OJ);
    
    %stopping condition
    if iter ==1
       Jold =OJ; 
    else
        if abs(Jold-OJ)<0.0001
           break; 
        else
            Jold = OJ;
        end
    end
    
end

end

function Uji = membership(Xi, Z, j, m, c, sigma)
    
    % Partition matrix calculation
    Uji = 0;  
    for j = 1:c    
       Uji = Uji + (dist(Xk,Z(j,:), sigma)/dist(Xk,Z(j,:),sigma))^(2/(m-1));
    end
    
    Uji = Uji^-1;
end

function vi = calc_center(Ui, X, m, N)
    
    % Updating cluster centers
    vi = X(1,:)*0; % initializing with zero
    
    for k = 1:N
       for j = 1:length(X(k,:))
            if ~isnan(X(k,:))
                vi(1,j) = vi(1,j) + (Ui(k)^m)*X(k,j); 
            end
       end
    end
    
    %calculate the demoninator function
    U = 0;
    for k = 1: N
        U = U + Ui(k)^m;
    end
    
    vi = vi/U;
end

function d = dist(x1, x2, sigma)
   
    % Euclidean distance
    d = 0;
    for j = 1:length(x1)
       % compute distance only for non NaN entries
       if ~isnan(x1(j)) && ~isnan(x2(j)) 
          d = d + ((x1(j)-x2(j))/sigma(j))^2;
       end
    end
    
    d = sqrt(d);

end