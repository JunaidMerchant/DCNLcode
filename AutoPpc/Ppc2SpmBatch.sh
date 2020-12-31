#!/bin/bash
############################################################################
#		Full PreProcessing for 1 subject
# Takes subject ID converts, organizes, & starts preprocessing all the data.
# Can be used as a bash script or qsub for the grid!
# Paths & variables that need changing are marked with "!CHANGE THIS!", 
# and include -o, CodeDir, VertDir, DcmDir, PpcDir, Fmap, Struct, & Func. 
# example usage: 
# > qsub /path/to/FullPps1.sh
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
#
echo ---------------------------------------------------------
echo Ppc pt2 $SubID $6
date 
matlab -nosplash -nodisplay -nodesktop -softwareopengl -r "SpmDir= '$1' ; SubID= '$2' ;  SubP= '$3' ; CodeDir= '$4' ; PpcBatchDir = '$5' ; Func = '$6' ; Struct = '$7' ; MakePpcBatch2(SpmDir, SubID, SubP, CodeDir, PpcBatchDir, Func, Struct); quit"
echo Ppc pt2 $SubID $6 DONE!
date 
echo ---------------------------------------------------------