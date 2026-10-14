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