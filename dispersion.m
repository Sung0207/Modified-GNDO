function Div=dispersion(X);
[nP,dim]=size(X);
mx=median(X);
mxsize=abs(repmat(mx,nP,1)-X);
Divj=mean(mxsize);
Div=mean(Divj);
% for ii= 1:dim
%     for jj = 1:nP
%         Divj2(ii,jj) = abs((median(X(ii,:))-X(ii,jj)));
%     end 
%         Divj(ii,:) = (1/SearchAgents_no)*sum(Divj2(ii,:));
%     end
%     Div(iter,:)=(1/dim)*sum(Divj);