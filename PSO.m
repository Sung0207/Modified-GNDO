function [Stat,BestValue,xbest]=PSO(fhd,nPop,nVar,VarMin,VarMax,MaxIt,X)
% fun,nPop,nVar,VarMin,VarMax,MaxIt,M
% (X,nP,maxIt,lb,ub,dim);
% fhd,nPop,nVar,VarMin,VarMax,MaxIt,X
%%Input parameters
%%fhd----------------objective function
%%nPop---------------population size 
%%nVar---------------the number of variables
%%VarMin-------------the lower boundaries of variables
%%VarMin-------------the upper boundaries of variables
%%MaxIt--------------the maximum number of iterations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Output parameters
%%BestCost-----------convergence curve
%%BestValue----------the optimal fitness value
%%XTarget------------the optimal solution
for ii=1:nPop
    f(ii) = fhd(X(ii,:));
end
gen=1;% Initial the number of iterations
[Best_Cost,ind]=min(f);
Div=dispersion(X);
Stat(gen,:)=[Best_Cost median(f) Div];
xiter(1,:)=[X(ind(1),:) f(ind(1))];
% pdm=[];
xnew=X;V=zeros(size(X));
for gen=1:MaxIt % Main loop
    [t,tindex]=sort(f);
    Best=X(tindex(1),:); 
    % xnew=zeros(nPop,nVar);
    for i=1:nPop
        [xnew(i,:),Vnew(i,:)]=RRPSOmove(i,V,Best,X,xnew,nVar);
        [xnew(i,:),V(i,:)]= BCPSO(xnew(i,:),X(i,:),Vnew(i,:),VarMin,VarMax,nVar);% boundary limit
        fnew(i,:) = fhd(xnew(i,:));
    end
    for i=1:nPop
        if(fnew(i)<f(i))
            X(i,:) = xnew(i,:);
            f(i) = fnew(i);
            % pdm=[pdm;X(i,:) f(i)];
        end
    end
    [Best_Cost,ind]=min(f);
    Div=dispersion(X);
    Stat(gen+1,:)=[Best_Cost median(f) Div];
    xiter(gen+1,:)=[X(ind(1),:) f(ind(1))];
end
BestValue=min(f);
xbest=X(ind(1),:);
end

function [newsol,V]=RRPSOmove(i,V,Best,popbest,pop,nVar)
cp=1/3*6.97;w=3.9;
cg=1/6*6.97;c=cp+cg;
if rand<0.5
    dt=0.9;
else
    dt=1.1;
end
V =(V(i,:) + dt*cp*rand(1,nVar).*(popbest(i,:)-pop(i,:)) +dt*cg*rand(1,nVar).*(Best-pop(i,:)))./(1+(1-w)*dt+c*dt^2);
newsol=pop(i,:)+ V*dt;
end

function [X,V] = BCPSO(X,Xbest,V,lb,ub,dim)
for j=1:dim
    if length(lb)==1;
        if X(j)<lb||X(j)>ub
            X(j) = lb+rand*(ub-lb);
            V(j) =X(j)-Xbest(j);
        end
    else
        if X(j)<lb(j)||X(j)>ub(j)
            X(j) = lb(j)+rand*(ub(j)-lb(j));
            V(j) =X(j)-Xbest(j);
        end 
    end
end  
end
