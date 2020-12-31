#!/bin/bash

matlab -nodesktop -nodisplay -softwareopengl -r "CodeDir= $1 ; spm_jobman('initcfg'); SubID= $2 ; SubP = $3 ; PpcBatchDir = $4 ; MNI = $5 ; disp(CodeDir); disp(SubID); disp(SubP); disp(PpcBatchDir); disp(MNI); quit"