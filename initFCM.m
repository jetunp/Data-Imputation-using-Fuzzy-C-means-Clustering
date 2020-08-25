function V = initFCM(X,cntr,type)

%INITFCM Function to initialize the centres of FCM

d = length(X(1,:)); %dimension of the incomplete given dataset

switch type 

    case 'zeros'

        % centres at origin

        V = zeros(cntr,d);

    case 'random'

        % centres at random

        V = rand(cntr,d);

    case 'gaussian'

        %gaussian with zero mean and 1 variance

        V = normrnd(0,1,cntr,d);

    case 'sample'

        % choose centres with random vectors

        d = length(X(:,1));

        for i =1:cntr

            idx = randperm(d,1);

            V(i,:) = X(idx,:);

        end
end

end



