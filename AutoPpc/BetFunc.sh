#!/bin/bash
############################################################################
#		bet functionals for 1 subject
#
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
SubP=$1
#
Func=$2
#
cd $SubP
### TO DO, STOP USING HARD CODED VARIABLE NAMES AND CHANGE THE "uaD" TO SOMETHING 
# THAT IS TAKEN FROM THE VARIABLE NAMES IN PARAMETERS
echo -----------------------------------
echo "Betting $Func"
date
for s in $(ls -d "${Func}"*); do
	cd $s
	for t in $(ls uaD*.nii meanua*.nii ); do
		bet $t b_$t
	done 
	gunzip *.gz 
	cd ..
done
echo "Betting $Func DONE!"
date
echo -----------------------------------