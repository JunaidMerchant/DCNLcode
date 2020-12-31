function RunBx(SubID, CodeDir, BxDir, Func)
%
addpath(CodeDir);
% 
if strcmp(Func,'SocStroop')
	cd(fullfile(BxDir,Func))
	Files=findfiles(fullfile(BxDir,Func),strcat(SubID(6:length(SubID)),'*.mat'));
	for f = 1:length(Files)
		SocStroopBx(Files{f,1});
	end
	SocStrpBxSummary
elseif strcmp(Func,'StopSignal')
	cd(fullfile(BxDir,Func))
	Files=findfiles(fullfile(BxDir,Func),strcat('stop-',SubID(6:length(SubID)),'.txt'));
	for f = 1:length(Files)
		StopBx(Files{f,1});
	end
	StopBxSummary
elseif strcmp(Func,'NBack')
	cd(fullfile(BxDir,Func))
	Files=findfiles(fullfile(BxDir,Func),strcat(SubID(6:length(SubID)),'*.mat'));
	for f = 1:length(Files)
		NBackBx(Files{f,1});
	end
	NBackBxSummary
end