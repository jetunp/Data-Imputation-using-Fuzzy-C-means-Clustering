clear
close all
clc
warning off
%The initialization of output for code to select the excel
%file from the computer 
%Input as the excel dataset for the information containing missing values.
 
%We will select the missing dataset file and read it%
[Dataset_name,path] = uigetfile('*.xlsx','Select the dataset containing missing instances');
Dataset_name = strcat(path,Dataset_name);  

% calculate the dimensions of the data

 [~,~,raw] = xlsread(Dataset_name);  % get both the numerical and text data 
 [X]= process(raw);

X1 = X;  % save copy of incomplete data
Imputed_values=[]; % variable to store imputed data values
Orig =[]; % variable to store original data values
[N,~] = size(X);

% remove the Null Values displayed by NaN

i1 = 1;
 while(i1<=length(X(1,:)))
     if sum(isnan(X(:,i1)))==N
        X(:,i1) =[];
     else
      i1=i1+1;
     end
end

[~,d] = size(X);

fprintf('Total number of Instances %d Final count of features %d \n', N, d);

%We have to find the missing points instances as we have to know the application
%to apply the Fuzzy C Means Clustering application
%We will be seperating data with tru data and incompleted data and 
%on the incompleted data wel will calculate the centre points

complete_data = [];   %initialize processed X variable
incomplete_data = []; %initialize missing value variable

for i1 = 1:N

    if sum(isnan(X(i1,:)))>0
        fprintf('\n The null data is founded in this location %d Instance: ',i1);
        for jj = 1:d
            if isnan(X(i1,jj))
                fprintf('%d ',jj);
            end
        end

        incomplete_data = [incomplete_data i1];
    else
        complete_data = [complete_data; X(i1,:)];
    end
end

Var_X = var(complete_data); % calculate the variance of existing data without missing values

%Step(3): Get the Partition Matrix and cluster centroids through Fuzzy C-Means Clustering

m = 1.75; % fuzzification coefficient

nc = 10;   % Number of clusters

[U,V] = fcm(X,nc,1.75,Var_X);

%Step(4): Reconstruction process of the missing data

ln = length(incomplete_data);  % total number of missing data entries

for i1 = 1:ln
    fprintf('\nData Instance %d Before reconstruction',incomplete_data(i1));
    X(incomplete_data(i1),:)
    % reconstruct data points
    X(incomplete_data(i1),:) = reconstruct(X(incomplete_data(i1),:),U(:,incomplete_data(i1)),m, V);
    fprintf('After Reconstruction');
    Imputed_values=[Imputed_values X(incomplete_data(i1),:)];
    X(incomplete_data(i1),:)
end

%step(4): Calculate Normalized_RMS, AE, Get the original file path and Imputed data
%file path

[Dataset_name,path] = uigetfile('*.xlsx','Select the dataset with original values');
Dataset_name = strcat(path,Dataset_name);
[~,~,raw] = xlsread(Dataset_name);
[X_orig]= process(raw);

% remove unnecessary NaN

i1 = 1;

%while(i1<=length(X_orig(1,:)))
 % if sum(isnan(X_orig(:,i1)))==N
  %    X_orig(:,i1) =[];
  %else
   %   i1=i1+1;
 % end
%end

Normalized_RMS = [];

AE =[];

for i1 = 1:length(incomplete_data)

    for j = 1:d

        X_pr = X(incomplete_data(i1),j)/max(X(:,j));  % normalization of imputed value

        X_og = X_orig(incomplete_data(i1),j)/max(X(:,j)); % normalization of original value
%         C_N= X(incomplete_data(i1),j);
%         XC_pr = Categories(C_N);
        
        Orig = [Orig X_og*max(X(:,j))];

        Normalized_RMS = [Normalized_RMS sqrt((sum((X_pr -X_og).^2))/d)];

        AE = [AE abs(X_pr -X_og)];

    end

end

% exclude missing data with values as zeros

Imputed_values(Normalized_RMS==0)=[];

Orig(Normalized_RMS==0)=[];

AE(Normalized_RMS==0) = [];

Normalized_RMS(Normalized_RMS==0) = [];

fprintf('\n\n Output of Normalizated Root Mean Square Error value is %4.4f',mean(Normalized_RMS));

fprintf('\nThe average error is %4.4f',mean(AE));

% store the output in excel file

fpath = uigetdir(pwd,'Store the predicted values or imputed value file at the location of file');

Dataset_name = strcat(fpath,'\Imputed.xlsx');

%delete(Dataset_name);

xlswrite(Dataset_name,X1,'Dataset with missing values');

xlswrite(Dataset_name,X,'Predicted Values Dataset');

xlswrite(Dataset_name,X_orig,'Real Dataset');

xlswrite(Dataset_name,Imputed_values,'Imputed values');

xlswrite(Dataset_name,Orig,'Original values');

xlswrite(Dataset_name,Normalized_RMS,'Normalized_RMS Error Values');

k=length(Normalized_RMS)+2;

xlswrite(Dataset_name,cellstr('mean Normalized_RMS Error'),'Normalized_RMS Error',sprintf('A%d:A%d',k,k));

xlswrite(Dataset_name,mean(Normalized_RMS),'Normalized_RMS',sprintf('A%d:A%d',k+1,k+1));

xlswrite(Dataset_name,AE','AE');

k=length(AE)+2;

xlswrite(Dataset_name,cellstr('mean AE'),'AE',sprintf('A%d:A%d',k,k));

xlswrite(Dataset_name,mean(AE),'AE',sprintf('A%d:A%d',k+1,k+1));

% plot Missing Data points and Normalized_RMS 

%figure(1)

%bar(Normalized_RMS);

%title('Normalized Root Mean Square Error');

%xlabel('Missing Data Points');

%ylabel('Normalized_RMS ');






