#!/bin/bash
############################################################################
#		gets Bx for task and adds to the bx summary sheet
# -junaid.salim.merchant 2018.08.13
############################################################################
#
SubID=$1
#
CodeDir=$2
#
BxDir=$3
#
Func=$4
#
#
echo -------
echo Behavioral
matlab -nosplash -nodisplay -nodesktop -softwareopengl -r "SubID= '$SubID' ; CodeDir = '$CodeDir' ; BxDir= '$BxDir' ; Func= '$Func' ; RunBx(SubID, CodeDir, BxDir, Func); quit"