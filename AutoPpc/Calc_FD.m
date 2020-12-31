function Calc_FD(rp_file, fd_threshold)




%Find and load motion param file

motionparams = load(rp_file);


FD=zeros(size(motionparams,1),1);



for i = 2:size(motionparams,1)
    FD(i) = abs(motionparams(i,1) - motionparams(i-1,1)) + abs(motionparams(i,2) - motionparams(i-1,2)) + abs(motionparams(i,3) - motionparams(i-1,3)) + ...
        abs(sin(motionparams(i,4)/2)*100 - sin(motionparams(i-1,4)/2)*100) + abs(sin(motionparams(i,5)/2)*100 - sin(motionparams(i-1,5)/2)*100) + abs(sin(motionparams(i,6)/2)*100 - sin(motionparams(i-1,6)/2)*100);
    
    
end


Badvols=FD>=fd_threshold;

AvgFD=mean(FD);

BadVolSum=sum(Badvols);

PercentBadVols=(BadVolSum/length(Badvols))*100;

if sum(Badvols)>0
    R=[motionparams double(Badvols)];
else
    R=motionparams;
end

save(strcat(rp_file,'.mat'),'FD','Badvols','AvgFD','BadVolSum','PercentBadVols','motionparams','R');

end