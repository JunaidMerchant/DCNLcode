#!/bin/bash
############################################################################
#		First level models for 1 subject/task
#
# -junaid.salim.merchant 2017.02.07
############################################################################
#
############################################
# Qsub options.  Change only the -o option #
############################################
# Use current working directory
#$ -cwd
# Combine job and error logs
#$ -j y
# Name of job/error lo
#$ -N FullPpc
# Directory where job/error logs are written. !CHANGE THIS!
#$ -o /home/research/sanlab/Studies/CHIVES/subjects/logs
# Use bash
#$ -S /bin/bash
#$ -V
# Required inputs: SpmDir, SubID, SubP, CodeDir, FxBatchDir, BxDir, FxDir, MotionDir, Contrasts, Func
echo ---------------------------------------------------------
echo First-level model $2 $9
date 
#
#
# Start matlab, and use SPM to coregister and segment 
matlab -nosplash -nodisplay -nodesktop -softwareopengl -r "SpmDir= '$1' ; SubID= '$2' ;  SubP= '$3' ; CodeDir= '$4' ; FxBatchDir= '$5' ; BxDir= '$6' ; FxDir= '$7' ; MotionDir= '$8' ; Func= '$9' ; MakeFxBatch(SpmDir, SubID, SubP, CodeDir, FxBatchDir, BxDir, FxDir, MotionDir, Func); exit"
#
echo First-level model $2 $9 DONE!
date 
echo ---------------------------------------------------------