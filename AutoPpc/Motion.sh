#!/bin/bash
############################################################################
#		gets motion for task and adds to the motion summary sheet
# -junaid.salim.merchant 2018.08.13
############################################################################
#
SubP=$1
#
Func=$2
#
MotionDir=$3
#
echo -------
echo Motion
Rps=()
for s in $(ls -d ${SubP}/${Func}*); do
	Rps+=( $(ls ${SubP}/${Func}*/rp*.txt) )
	cp $s/rp*.txt $MotionDir$Func
done
#
for r in ${Rps[@]}; do
	Current=$MotionDir$Func/${r##*/}
	matlab -nosplash -nodisplay -nodesktop -softwareopengl -r "rp_file = '$Current' ; Calc_FD(rp_file, 1.5); quit"
done
#
# Summarize motion
Directory=$MotionDir$Func
matlab -nosplash -nodisplay -nodesktop -softwareopengl -r "Directory = '$Directory' ; MotionSummary(Directory); quit"