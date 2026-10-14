function [Stat,BestValue,XTarget]=EGNDO(fhd,n,d,lb,ub,t,x)
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

%Sungkono, S., Rochman, J.P.G.N., Saifuddin et al. Enhanced generalized normal distribution optimization 
%for interpreting magnetic data caused by subsurface mineral deposits. Earth Sci Inform 18, 451 (2025). 
%https://doi.org/10.1007/s12145-025-01948-0

% Initialise the population
for i=1:n
    % x(i,:)=lb+rand(1,d).*(ub-lb); %Initial population
    fitness(i) = fhd(x(i,:));
end
FE=n;MaxFE=n*(t+1);
it=1;% Initial the number of iterations
[Best_Cost,ind]=min(fitness);
Div=dispersion(x);
Stat(it,:)=[Best_Cost median(fitness) iqr(fitness) Div];
XTarget=x(ind,:);%pdm=[];
M_X=rand(1,d);
% [cgcurve(1),ind]=min(fitness);%
% XTarget=x(ind,:);
for it=1:t   
    mo= mean(x);
    [~,indx]=sort(fitness);
    minf=fitness(indx(1));
    bestSol=x(indx(1),:);
    worst=x(indx(end),:);M=mean(x);
    for ii=1:n;
        P(indx(ii))=ii/n;
    end
    for i=1:n
        if i~=indx(1)
            [v1,v2,a,b]=selectionx(x,i,n,fitness);
            if rand<P(i)
                if rand<=0.5
                    newsol=Randn(bestSol,x(i,:),d);
                else
                    [F1,F2]=Fscales(i,a,b,P);
                    newsol=x(i,:)+ F1.*(bestSol-x(i,:))+F2.*(x(a,:)-x(b,:));
                end 
            else
                beta=rand;
                newsol= x(i,:) +beta*abs(randn).*v1+(1-beta)*abs(randn).*v2;
            end
        else
            M_X=4*M_X.*(1-M_X);newsol=bestSol+rand(1,d).*(2*M_X-1);
        end 
        % end
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

function X=Randn(Xbest,X,nvar)
meang=(Xbest+X)/2;
stdg=abs(Xbest-X);
X=meang+randn(1,nvar).*stdg;
end

function [F1,F2]=Fscales(i,j,k,uF);
[F1,F2]=F1F2(i,j,k,uF);
while F1<=0|| F1>1
    F1=uF(i)+0.1*randn;
end
while F2<=0|| F2>1
    F2=uF(i)+0.1*randn;
end
end
function [F1,F2]=F1F2(i,j,k,uF);
if rand<0.5
    F1=uF(j)+0.1*randn;
    F2=uF(k)+0.1*randn;
else
    F1=uF(i)+0.1*randn;
    F2=uF(i)+0.1*randn;
end
end