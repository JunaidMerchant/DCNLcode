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
matlab -nodesktop -nodisplay -r "cd('/media/jm3080/Naider/RDOC/code'); spm_jobman('initcfg'); SubID= $1 ; MakePpcBatch1(SubID); exit"