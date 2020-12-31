Contrast=struct('Name',{},'Vector',[]);
%
Contrast(1).Name={'2Back>1Back'
'1Back>2Back'
'1Back'
'2Back'}; 
Contrast(1).Vector=[-1 1
1 -1
1 0
0 1];
%
Contrast(2).Name={'C>I'
'I>C'
'CI>II'
'CI>CC'
'IC>CC'
'II>IC'
'Switch>Same'
'Interaction1'
'Congruent'
'Incongruent'
'CI'
'II'
'IC'
'CC'};
Contrast(2).Vector=[-1 -1 1 1 
1 1 -1 -1 
1 -1 0 0 
1 0 0 -1
0 0 1 -1
0 1 -1 0
1 -1 1 -1
1 -1 -1 1
0 0 1 1
1 1 0 0
1 0 0 0 
0 1 0 0 
0 0 1 0
0 0 0 1];
% Might want to reconsider these for 
Contrast(3).Name={'Stop>Go'
'Go>Stop'
'CorrectGo>IncorrectGo'
'IncorrectGo>CorrectGo'
'CorrectStop>FailStop'
'FailStop>CorrectStop'
'Correct>Incorrect'
'Incorrect>Correct'
'Intraction1'
'Interaction2'
'CorrectGo'
'IncorrectGo'
'CorrectStop'
'FailStop'};
Contrast(3).Vector=[-1 -1 1 1
1 1 -1 -1
1 -1 0 0 
-1 1 0 0 
0 0 1 -1
0 0 -1 1
1 -1 1 -1
-1 1 -1 1
1 -1 -1 1
-1 1 1 -1
1 0 0 0
0 1 0 0 
0 0 1 0
0 0 0 1];
