function [Stat,BestCost,Best]=TLBO(fhd,nPop,nVar,VarMin,VarMax,MaxIt,pop)
%fhd--------objective function
%nPop-------population size
%nVar-------dimension
%VarMin-----lower limits of variables
%VarMax-----upper limits of variables
%MaxIt------the maximum number of function evaluations
%X----------initilization population
%BestCost---convergence curve
%BestValue--the optimal solution
% MaxIt=floor(MaxIt/(2*nPop));
VarSize = [1 nVar];
BestSol = inf;
for i=1:nPop
    pop_Cost(i) = fhd(pop(i,:));
end
% pdm=[];
[Best_Cost,ind]=min(pop_Cost);
% BestCost(1)=BestSol ;
Best=pop(ind(1),:);
Div=dispersion(pop);
Stat(1,:)=[Best_Cost median(pop_Cost) Div];
for it=1:fix(MaxIt/2)
    Mean=mean(pop);
    [~,la]=min(pop_Cost);
    Teacher = pop(la,:);
    for i=1:nPop
        TF = round(1+rand);
        newsol = pop(i,:)+ rand(VarSize).*(Teacher - TF*Mean);
        newsol=BC(newsol,VarMin,VarMax,nVar);
        % newsol=bound(newsol,VarMin,VarMax);
        newsol_Cost = fhd(newsol);
        if newsol_Cost<pop_Cost(i)
            pop_Cost(i) = newsol_Cost;
            pop(i,:)=newsol;
            % pdm=[pdm;newsol newsol_Cost];
        end
    end
    [BestCost,ind]=min(pop_Cost);
    Best=pop(ind(1),:);
    for i=1:nPop        
        j=randperm(nPop,1);
        while j==i
            j=randperm(nPop,1);
        end
        if pop_Cost(i)<pop_Cost(j)
            dx=(pop(i,:) -pop(j,:));
        else
            dx=(pop(j,:)-pop(i,:));
        end
        newsol = pop(i,:)+ rand(VarSize).*dx;
        newsol=BC(newsol,VarMin,VarMax,nVar);
        % newsol=bound(newsol,VarMin,VarMax);
        newsol_Cost = fhd(newsol);
        if newsol_Cost<pop_Cost(i)
            pop_Cost(i) = newsol_Cost;
            pop(i,:)=newsol;
            % pdm=[pdm;newsol newsol_Cost];
        end
    end
    [BestCost,ind]=min(pop_Cost);
    Best=pop(ind(1),:);
    % BestCost(it)=BestSol;
    Div=dispersion(pop);
    Stat(it+1,:)=[BestCost median(pop_Cost) Div];
    xiter(it+1,:)=[Best BestCost];
end
BestValue=BestCost;
end
