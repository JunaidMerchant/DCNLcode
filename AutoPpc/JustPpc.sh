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
# Name of job/error log
#$ -N FullPpc
# Directory where job/error logs are written. !CHANGE THIS!
#$ -o /home/research/sanlab/Studies/CHIVES/subjects/logs
# Use bash
#$ -S /bin/bash
#$ -V
#
#
# Define Subject ID from input 1
if [ $# -eq 0 ]; then
	SubID=$(zenity --entry --title="Please enter the subject ID!")
else
	SubID=$1
fi
#
# Define the rest of the variables by sourcing the Parameter.sh file
source /media/jm3080/Naider/RDOC/code/AutoPpc/Parameters.sh
#
# Start the first part of Ppc
$Ppc1 "'${SubID}'"
#
# Bet all the functional files
$Bet $SubP
#
# Start the second part of Ppc
$Ppc2 "'${SubID}'"
#
# Start Fx
$Fx "'${SubID}'"