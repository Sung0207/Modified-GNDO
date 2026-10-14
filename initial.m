function X=initial(pop,nvar)
global XMax XMin 
X=zeros(pop,nvar);
X=repmat(XMin,pop,1)+ rand(pop,nvar).*repmat((XMax-XMin),pop,1);