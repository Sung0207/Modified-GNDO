function [Stat,BestValue,XTarget]=HGNDO(fhd,n,d,lb,ub,t,x)
% [xposbest,fvalbest,Stat,pdm] =LSBWO(fobj,Npop,nD,lb,ub,Max_it,pos)
%obj--------objective function
%c-------population size
%d-------dimension of problem
%lb-----the lower limit of the variables
%ub-----the upper limit of the variables
%t------the maximum number of function evaluations
%cgcurve---the record of the convergence curves
%bestobj--the optimal fitness value
%bestsol-------the optimal solution

% Initialise the population
for i=1:n
%     X(i,:)=VarMin+rand(1,nVar).*(VarMax-VarMin); %Initial population
    fitness(i) = fhd(x(i,:));
end
FE=n;
it=1;% Initial the number of iterations
[Best_Cost,ind]=min(fitness);
Div=dispersion(x);
Stat(it,:)=[Best_Cost median(fitness) iqr(fitness) Div];
XTarget=x(ind,:);%pdm=[];
% [cgcurve(1),ind]=min(fitness);%
% XTarget=x(ind,:);
M_X=0.8;
for it=1:t   
    % mo= mean(x);
    [~,indx]=sort(fitness);
    % minf=fitness(indx(1));
    bestSol=x(indx(1),:);
    % newsol=bestSol+rand(1,d).*(2*M_X-1);
    worst=x(indx(end),:);
    M=mean(x);
    for ii=1:n;
        P(indx(ii))=ii/n;
    end
    for i=1:n
            [v1,v2,a,b]=selectionx(x,i,n,fitness);
            if rand<P(i)^2
                if rand>(1-it/t)
                    M_X=4*M_X*(1-M_X);
                    newsol=x(i,:)+M_X*(bestSol-worst);
                else
                    newsol=x(i,:);
                end
            else 
                beta=rand;
                 newsol= x(i,:) +beta*randn.*v1+(1-beta)*randn.*v2;
            end   
        newsol= BC(newsol,lb,ub,d);
        newfitness =fhd(newsol);
        if newfitness<fitness(i)  %Eq. 27
            x(i,:) = newsol;
            fitness(i)=newfitness;
            % pdm=[pdm;x(i,:) fitness(i)];
        end
    end
    % cgcurve(it)=min(fitness);
    [Best_Cost,ind]=min(fitness);
    Div=dispersion(x);
    Stat(it+1,:)=[Best_Cost median(fitness) iqr(fitness) Div];
    XTarget=x(ind,:);
%     disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(bestFitness,15)]);
end
BestValue=min(fitness);
end
