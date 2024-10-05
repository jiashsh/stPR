function sta=popul_stPR(PR,sp, neuid,addL)
%     if size(PR,2)>=neuid
%     PR(:,neuid)=[];
%     end
    ncell=size(PR,2);
    PR=sum(PR,2)'-mean(PR,2)'; % baseline
    PR=PR/ncell;
    sp(1:addL)=0;
    sp(end-addL+1:end)=0;
    spt=find(sp>0);
	stsppr=[];
	for it =1:length(spt)
      	stsppr=[stsppr;PR( spt(it)-addL:spt(it)+addL)];
    end
	sta=mean(stsppr,1);
end