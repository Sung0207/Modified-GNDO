clear all;clc
path = pwd;
path11=strcat(path,filesep);
addpath(strcat(pwd,filesep,'GOM'));
addpath(strcat(pwd,filesep,'Data'));
addpath(strcat(pwd,filesep,'Source code'));
problems={'F1','F2','F3','F4','F5','F6','F7','F8','F9','F10','F11','F12','F13'};
no=30; % Number of search agents
Max_iteration=500; % Maximum numbef of iterations
probLeng=length(problems);
totalrun=30;
for ii=1:probLeng
    % Load details of the selected benchmark function
    Function_name=problems{ii};
    fprintf('Running on %s...\n',Function_name);
    [lb,ub,dim,fobj]=BF(Function_name);
    for i=1:no;
        x(i,:)=lb*ones(1,dim)+rand(1,dim)*(ub-lb);
    end 
    Objbest1=[];Objbest2=[];Objbest3=[];Objbest4=[];Objbest5=[];Objbest6=[];Objbest7=[];
    for i=1:totalrun;
        [Stat1,BestValue1,XTarget1]=PSO(fobj,no,dim,lb,ub,Max_iteration,x);
        [Stat2,BestValue2,XTarget2]=TLBO(fobj,no,dim,lb,ub,Max_iteration,x);
        [Stat3,BestValue3,XTarget3]=GNDO(fobj,no,dim,lb,ub,Max_iteration,x);
        [Stat4,BestValue4,XTarget4]=HGNDO(fobj,no,dim,lb,ub,Max_iteration,x);
        [Stat5,BestValue5,XTarget5]=EGNDO(fobj,no,dim,lb,ub,Max_iteration,x);
        [Stat6,BestValue6,XTarget6]=MGNDO(fobj,no,dim,lb,ub,Max_iteration,x);
        All1(i).Stat=Stat1;All2(i).Stat=Stat2;All3(i).Stat=Stat3;All4(i).Stat=Stat4;
        All5(i).Stat=Stat5;All6(i).Stat=Stat6;
        All1(i).xbest=XTarget1;All2(i).xbest=XTarget2;All3(i).xbest=XTarget3;All4(i).xbest=XTarget4;
        All5(i).xbest=XTarget5;All6(i).xbest=XTarget6;
        Objbest1=[Objbest1 BestValue1];Objbest2=[Objbest2 BestValue2];
        Objbest3=[Objbest3 BestValue3];Objbest4=[Objbest4 BestValue4];
        Objbest5=[Objbest5 BestValue5];Objbest6=[Objbest6 BestValue6];
        % if j==totalrun
        % end
    end
     cd Hasil
        eval(['save Hasil30_1' sprintf(Function_name)])
     cd ..
end


