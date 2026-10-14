function [Stat,BestValue,XTarget]=GNDOExploration(fhd,nPop,nVar,VarMin,VarMax,t,x)
%obj--------objective function
%c-------population size
%d-------dimension of problem
%lb-----the lower limit of the variables
%ub-----the upper limit of the variables
%t------the maximum number of function evaluations
%cgcurve---the record of the convergence curves
%bestobj--the optimal fitness value
%bestsol-------the optimal solution
% XTarget,BestValue,Stat,pdm

% Initialise the population
for i=1:nPop
%     X(i,:)=VarMin+rand(1,nVar).*(VarMax-VarMin); %Initial population
    f(i) = fhd(x(i,:));
end
gen=1;% Initial the number of iterations
[Best_Cost,ind]=min(f);
Div=dispersion(x);
Stat(gen,:)=[Best_Cost median(f) iqr(f) Div];
XTarget=x(ind,:);%pdm=[];
% [BestCost(1),ind]=min(f);%
% XTarget=x(ind,:);
for gen=1:t
    [cuk,index]=sort(f);
    Best=x(index(1),:);M= mean(x);
    for i=1:nPop
        [v1,v2,~,~]=selectionx(x,i,nPop,f);
        if rand<=0.5
            newsol =Local_GNDO(i,x,Best,M,nVar);
        else
            beta=rand;
            if rand<=0
            newsol= x(i,:) +beta*abs(randn).*v1 ...   %Eq. 23
                                    +(1-beta)*abs(randn).*v2;
            else 
             newsol=x(i,:)+beta*randn(1,nVar).*(Best-0.01*Levy(nVar).*M);
            end 
        end
        newsol= BC(newsol,VarMin,VarMax,nVar);
        fnew = fhd(newsol);
        if(fnew<f(i))
            x(i,:) = newsol;
            f(i) = fnew;
            % pdm=[pdm;x(i,:) f(i)];
        end
    end
    [Best_Cost,ind]=min(f);
    % XTarget=x(ind);
    Div=dispersion(x);
    Stat(gen+1,:)=[Best_Cost median(f) iqr(f) Div];
    XTarget=x(ind,:);
end
BestValue=min(f);
end
