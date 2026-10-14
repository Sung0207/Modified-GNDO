clc;clear all;close all
path = pwd;
path11=strcat(path,filesep);
addpath(strcat(pwd,filesep,'GOM'));
addpath(strcat(pwd,filesep,'Data'));
addpath(strcat(pwd,filesep,'Source code'));
addpath(strcat(pwd,filesep,'Statistical Analysis'));
problems={'F1','F2','F3','F4','F5','F6','F7','F8','F9','F10','F11','F12','F13'};
% no=30; % Number of search agents
Origin={'PSO','TLBO','GNDO','HGNDO','EGNDO','MGNDO'};
Statistik=[];pa=[];R=[];
for ii=1:length(problems);
    Function_name=problems{ii};
    cd Hasil
    eval(['load Hasil30_1' sprintf(Function_name)])
    cd .. 
    for jj=1:totalrun;
        ConvPSO(:,jj)=All1(jj).Stat(:,1);
        ConvTLBO(:,jj)=All2(jj).Stat(:,1);
        ConvGNDO(:,jj)=All3(jj).Stat(:,1);
        ConvHGNDO(:,jj)=All4(jj).Stat(:,1);
        ConvEGNDO(:,jj)=All5(jj).Stat(:,1);
        ConvMGNDO(:,jj)=All6(jj).Stat(:,1);
    end
    if ii>=2
        conPSO=mean(ConvPSO');conTLBO=mean(ConvTLBO');
        conGNDO=mean(ConvGNDO');conHGNDO=mean(ConvHGNDO');
        conEGNDO=mean(ConvEGNDO');conMGNDO=mean(ConvMGNDO');
        m1=(0:length(conPSO)-1).*no;
        m2=(0:length(conTLBO)-1).*2*no;
        % if ii==2
            figure(1)
        % end
        subplot(4,3,ii-1)
        semilogy(m1,conPSO,'r-','linewidth',1.5');hold on
        semilogy(m2,conTLBO,'k--','linewidth',1.5);
        semilogy(m1,conGNDO,'b:','linewidth',1.5);
        semilogy(m1,conHGNDO,'g-.','linewidth',1.5);
        semilogy(m1,conEGNDO,'c-','linewidth',1.5);
        semilogy(m1,conMGNDO,'m.','linewidth',1.5);
        ylabel('Fitness Value','fontsize',12,'fontweight','bold','fontname','Times')
        xlabel('Number of Evaluation','fontsize',12,'fontweight','bold','fontname','Times')
        title([sprintf(Function_name)],'fontsize',12,'fontweight','bold','fontname','Times')
        if ii==length(problems)
            legend('PSO','TLBO','GNDO','HGNDO','EGNDO','MGNDO')
        end
    end
    po=[min(Objbest1) max(Objbest1) mean(Objbest1) std(Objbest1);
        min(Objbest2) max(Objbest2) mean(Objbest2) std(Objbest2);
        min(Objbest3) max(Objbest3) mean(Objbest3) std(Objbest3);
        min(Objbest4) max(Objbest4) mean(Objbest4) std(Objbest4);
        min(Objbest5) max(Objbest5) mean(Objbest5) std(Objbest5);
        min(Objbest6) max(Objbest6) mean(Objbest6) std(Objbest6)];
    data=[Objbest1;Objbest2;Objbest3;Objbest4;Objbest5;Objbest6]';
    if ii>=2      
    figure(2)
    subplot(4,3,ii-1)
    h=boxplot(data,'notch','on','Labels',Origin,'Widths',0.3)
    set(h,'LineWidth', 2)
    ax = gca;ax.XAxis.FontWeight = 'bold';
    ylabel('Fitness Value','fontsize',12,'fontweight','bold','fontname','Times')
    title([sprintf(Function_name)],'fontsize',14,'fontweight','bold','fontname','Times');
    end
    [~, ~, ~, ~, ~, ~, ranks] = friedmanranks(data,0.05);
    R=[R;ranks];
    [p,indx]=min(ranks);
    % if indx==6
     [p1,h1] = signrank(Objbest1,Objbest6);
     [p2,h2] = signrank(Objbest2,Objbest6);
     [p3,h3] = signrank(Objbest3,Objbest6);
     [p4,h4] = signrank(Objbest4,Objbest6);
     [p5,h5] = signrank(Objbest5,Objbest6);
    pa=[pa;p1 p2 p3 p4 p5];
    Statistik=[Statistik;po ranks'];
end
x=["PSO" "TLBO" "GNDO" "HGNDO" "EGNDO" "MGNDO"]
figure
b=bar(x,mean(R))
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(b(1).YData);
text(xtips1,ytips1,labels1,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom','fontsize',12,'fontweight','bold','fontname','Times')
ylabel('The Average Rank','fontsize',12,'fontweight','bold','fontname','Times')
ylim([0 6])
xlabel('Benchmark Algoritms','fontsize',12,'fontweight','bold','fontname','Times')
