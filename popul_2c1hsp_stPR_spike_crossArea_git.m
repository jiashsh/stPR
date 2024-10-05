close all
clear all
awan={'awake','anaesthesia'};
wn={'aw','an'};
area={'V1','M1','CA1'};
NO=9;
parid=1;
shuffle=0; % 0 no shuffle , 1 sub matrix shuffle
Nshuff=50000;
fre =10;
addL=10;
smooth=1;
hW=6;
for state =1:2

    load(['.\data\V1CA1M1_',awan{state},'_spontaneous.mat']);
    
    alldata=[];
    flag=0;
    cname={};
    Ampallx={};
    target=[];
    figure;
    set(gcf,'Position',[50 50 850 850])
    frow=3;
    fcol=3;

    for ari = 1:size(area,2)
        for arj = 1:size(area,2)
            spdata_1=[];
            spdata_2=[];
            spdata_1=data{ari,2};
            spdata_2=data{arj,2};

            % shuffle
            if shuffle
                spdata_1(spdata_1>0)=1;
                spdata_2(spdata_2>0)=1;
                spdata_1=popul_shuffle_subM(spdata_1, Nshuff);
                spdata_2=popul_shuffle_subM(spdata_2, Nshuff);
            end
            % smooth all
            spdata_1smooth=[];
            spdata_2smooth=[];
            for jj=1:size(spdata_1,2)
                spdata_1smooth(:,jj) = smoothdata(spdata_1(:,jj),'gaussian',hW); 
            end
            for jj=1:size(spdata_2,2)
                spdata_2smooth(:,jj) = smoothdata(spdata_2(:,jj),'gaussian',hW);
            end
            
            % padding
            spdata_1=[zeros(addL,size(spdata_1,2));spdata_1;zeros(addL,size(spdata_1,2))];
            spdata_2=[zeros(addL,size(spdata_2,2));spdata_2;zeros(addL,size(spdata_2,2))];
            spdata_1smooth=[zeros(addL,size(spdata_1smooth,2));spdata_1smooth;zeros(addL,size(spdata_1smooth,2))];
            spdata_2smooth=[zeros(addL,size(spdata_2smooth,2));spdata_2smooth;zeros(addL,size(spdata_2smooth,2))];
            
            ncell=size(spdata_1,2);
            Amp=[];
            stsppr_all=[];
            PR=[];
            spdata=[];
            for neu =1:ncell
                PR=spdata_2smooth;
                spdata=spdata_1;
                titlename=[area{ari},'SP',area{arj},'PR'];
                if ari==arj
                    PR(:,neu)=[];
                end
                ci_all(neu)=popul_coupling(spdata,neu,PR,hW);
                
                sp=spdata(:,neu);
            	if sum(sp)==0
                 	Amp(neu,:)=[0,0];
                   	stsppr_all=[stsppr_all;zeros(1,2*addL+1)];
                 	continue
            	end
                
                sta=popul_stPR(PR,sp, neu,addL);

                [maxy,maxx]=max(sta);
                Amp(neu,:)=[maxy,maxx];
                stsppr_all=[stsppr_all;sta];
            end    
            Ampallx{(ari-1)*3+arj,1}=[area{ari},'SP',area{arj},'PR'];
            Ampallx{(ari-1)*3+arj,2}=Amp(:,2)';
            
            subplot(frow,fcol,(ari-1)*fcol+arj);
            alldata=[alldata;stsppr_all];
            flag=flag+1;
            target=[target;ones(size(stsppr_all,1),1)*flag];
            cname{flag}=strrep(titlename,'_',' ');
            temp=stsppr_all;

            [x y]=find(temp==max(Amp(:,1)));
            xx=([1:1:size(temp,2)]-addL-1)/fre;
            
            for neu =1:ncell
                hold on;
                if neu ==x
                    plot(xx',temp(neu,:),'Linewidth',2);
                else
                    plot(xx',temp(neu,:));
                end
            end 
            title([strrep(titlename,'_',' '),' Neuron ',num2str(x(1))]);
            xlim([xx(1) xx(end)]);
            ylim([0 0.30])
            set(gca,'tickdir','out')
        end   
    end
    
end







