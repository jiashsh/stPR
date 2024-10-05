function spM=popul_shuffle_subM(spM, Nshuff)
    [len,nc]=size(spM);

    num=1;
    while num < Nshuff
        a=randperm(len,2); 
        b=randperm(nc,2);
        subM=spM(a,b);
     	if subM(1,1)==subM(2,2) && subM(1,2)==subM(2,1) && subM(1,2)~=subM(1,1)
           	subM=(subM-1)*(-1);
           	spM(a,b)=subM;
            num=num+1;
      	end
    end
end