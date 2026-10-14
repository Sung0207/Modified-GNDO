function [Stat,BestValue,XTarget]=MGNDO(fhd,n,d,lb,ub,t,x)
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
    fitness(i) = fhd(x(i,:));
end
FE=n;
it=1;% Initial the number of iterations
[Best_Cost,ind]=min(fitness);
Div=dispersion(x);
Stat(it,:)=[Best_Cost median(fitness) iqr(fitness) Div];
XTarget=x(ind,:);% [cgcurve(1),ind]=min(fitness);%
% XTarget=x(ind,:);
for it=1:t   
    % mo= mean(x);
    [~,indx]=sort(fitness);
    % minf=fitness(indx(1));
    bestSol=x(indx(1),:);
    kl=randi([2 5]);Elite=x(indx(kl),:);
    M=mean(x);
    for ii=1:n;
        P(indx(ii))=ii/n;
    end
    for i=1:n
        [v1,v2,a,b]=selectionx(x,i,n,fitness);
        % if i~=indx(1)
        if rand<P(i)
            if rand<0.5
                D1=bestSol+randn*abs(2*rand(1,d).*bestSol-x(i,:));
                D2=x(indx(2))+randn*abs(2*rand(1,d).*x(indx(2))-x(i,:));
                D3=x(indx(3))+randn*abs(2*rand(1,d).*x(indx(3))-x(i,:));
                mu=(D1+D2+D3)/3;
                deta=sqrt(1/3*((bestSol-mu).^2+(x(indx(2))-mu).^2+(x(indx(3))-mu).^2));
                newsol=mu+randn(1,d).*deta; 
            else
                [F1,F2]=Fscales(i,a,b,P);
                newsol=x(i,:)+ F1.*(bestSol-x(i,:))+F2.*(x(a,:)-x(b,:));
            end
        else 
            beta=rand;
            if rand<0.5
               newsol= x(i,:) +beta*randn*v1+(1-beta)*(randn)*v2;
            else 
                newsol=x(i,:)+beta*randn(1,d).*(bestSol-0.01*Levy(d).*M);
            end  
        end
        newsol= BC(newsol,lb,ub,d);
        newfitness =fhd(newsol);
        FE=FE+1;
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
