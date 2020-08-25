function X = reconstruct(X,Ui,m,V)

%RECONSTRUCT Function to reconstruct the data

% inputs:

% X - data vector

% Ui - partition entry value

% V - centres

% m - fuzzifier index

% outputs:

% X - reconstructed data point



d = length(X);  % dimension of the vector

c = length(V(:,1)); % number of classes / clusters



for value = 1:d



    if isnan(X(value)) % if its a missing value

       X(value) =  0; 

       den = 0;

       for j = 1:c

          X(value) = X(value) + (Ui(j)^m)*V(j,value); 

          den = den + (Ui(j)^m);

       end

       if den>0

         X(value) = X(value)/den;

       end

    end

    if isnan(X(value))

        X(value) =0;

    end

end



end



