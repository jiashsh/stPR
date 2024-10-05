function ci=popul_coupling(spdata,neu,spdatasmooth,hW)
%     if size(spdatasmooth,2)>=neu
%     spdatasmooth(:,neu)=[];
%     end
    fi = smoothdata(spdata(:,neu),'gaussian',hW);
    fi_norm=sum(spdata(:,neu));
    ci=0;
    for t=1:size(spdata,1)
        sumjt=0;
      	temp=spdatasmooth(t,:)-mean(spdatasmooth,1);
        sumjt=sum(temp);
        ci=ci+fi(t)*sumjt;
    end
    ci=ci/fi_norm;
end