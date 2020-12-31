function MotionSummary(Directory)
%
% Summarizes motion data into a .mat file and .csv for easy motion viewing
%
Files=findfiles(Directory,'rp*.txt.mat');
Head={'File' 'AvgFD' 'BadVolSum' 'PercentBadVols' 'BadRun'};
Data=nan(length(Files),3);

for r = 1:length(Files)
    load(Files{r,1});
    Data(r,:)=[AvgFD BadVolSum PercentBadVols];
    clear AvgFD Bad* FD motionparams PercentBadVols R
end
%
% Now get summaries 
NumGoodRuns=sum(Data(:,3)<10);
NumBadRuns=sum(Data(:,3)>10);
PercentGoodRuns=NumGoodRuns/length(Files);
BadRuns=Data(:,3)>10;
BadRunNum=find(BadRuns);
%
% Save relevant files
save(strcat(Directory,'/MotionSummary.mat'),'Head','Files','Data','NumGoodRuns','NumBadRuns','PercentGoodRuns','BadRuns','BadRunNum');
AvgFD=Data(:,1); BadVolSum=Data(:,2); PercentBadVols=Data(:,3); BadRun=double(BadRuns);
Summary=table(Files,AvgFD,BadVolSum,PercentBadVols,BadRun);
writetable(Summary,strcat(Directory,'/MotionSummary.csv'));