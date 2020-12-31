#!/bin/bash
############################################################################
#		Full PreProcessing Structural
# Takes subject ID as input & converts, organizes, & starts preprocessing
# the structural data. Can be used as a bash script or qsub for the grid!
# Paths & variables that need changing are marked with "!CHANGE THIS!", 
# and include -o, CodeDir, VertDir, DcmDir, PpcDir, Func, Struct, Fmap, 
# example usage: 
# > qsub /path/to/FullPps1.sh Subject001 mprage
#
# -junaid.salim.merchant 2017.02.07
############################################################################
#
###############
# Qsub options.
###############
# Use current working directory
#$ -cwd
# Combine job and error logs
#$ -j y
# Use bash
#$ -S /bin/bash
#$ -V
#
##############################################
# Start processing the structural data
##############################################
#
# Required inputs: SpmDir, SubID, SubP, Template, CodeDir, PpcBatchDir, StructName
echo ---------------------------------------------------------
echo Ppc $SubID structurals
date 
#
#
# Start matlab, and use SPM to coregister and segment 
matlab -nosplash -nodisplay -nodesktop -softwareopengl -r "SpmDir= '$1' ; SubID= '$2' ;  SubP= '$3' ; Template= '$4' ; CodeDir= '$5' ; PpcBatchDir= '$6' ; StructName= '$7' ; MakeStructPpc(SpmDir, SubID, SubP, Template, CodeDir, PpcBatchDir, StructName); exit"
#
echo Ppc $SubID structurals DONE!
date 
echo ---------------------------------------------------------