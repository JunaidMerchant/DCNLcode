#!/bin/bash
############################################################################
#		Full PreProcessing Script
# Takes subject ID & scan name as input & converts, organizes, & starts 
# preprocessing the data. Can be used as a bash script or qsub for the grid!
# Paths & variables that need changing are marked with "!CHANGE THIS!", 
# and include -o, CodeDir, VertDir, DcmDir, PpcDir, Func, Struct, Fmap, 
# example usage: 
# > qsub /path/to/FullPps1.sh Subject001 mprage
#
# -junaid.salim.merchant 2016.08.16
############################################################################
#
###############
# Qsub options.  
###############
# Use current working directory
#$ -cwd
# Combine job and error logs
#$ -j y
# Name of job/error log
#$ -N FullPpc
# Use bash
#$ -S /bin/bash
#$ -V
###################################################
# Define paths to directories and mri scans to use.
###################################################
# Define subject id from input 1.
SubID=$1
#
# Define scan name from input 2.
Scan=$2
#
# Define job id number (if any) from input 3.
JobNum=$3
#
#
########################################################
# Start processing the functional data: convert & clean.
########################################################
echo _________________________________________________________
echo ---------------------------------------------------------
echo working on $SubID $Scan
date _________________________________________________________
echo ---------------------------------------------------------
#
if [ $(find $SubC/*$Scan* -name *.gz | wc -l) -eq 0 ]; then
	# Convert & compress functional data using Convert.sh
	sh $Vert $SubID $Scan
fi
#
# Remove unnecessary files/folders, and compress good files
cd $SubC
#
for Dirs in $(ls -d $SubC/*${Scan}*); do 
	#FuncDir=$SubC/$Dirs
	# Define minimum number of scans in functional run to be counted good. Set to 100
	if [ $(find $Dirs -name ${Scan}* | wc -l) -lt 100 ]; then
		echo --------------------------------------
		echo Cleaning bad $dirs
		echo --------------------------------------
		rm -r $Dirs
	fi
done
#
##################################
# Make and organize PPC directory.
##################################
#
# Make ppc dir if there isnt one
if [ $(ls -d $SubP | wc -l) -eq 0 ]; then 
	echo making $SubP
	mkdir $SubP
	mkdir $SubP/ppc
	mkdir $SubP/jobsnlogs
fi
#
if [ $(find $SubP -name $Scan* | wc -l) -eq 0 ]; then
	# Copy to ppc directory
	echo --------------------------------------
	echo Copying to $Scan Ppc
	date
	echo --------------------------------------
	cp -r $SubC/*${Scan}* $SubP
	#
	# Organize ppc directory
	echo --------------------------------------
	echo Organizing $Scan Ppc
	date
	echo --------------------------------------
	# If more than 2 runs
	if [ $(ls -d $SubP/*${Scan}* | wc -l) -gt 2 ]; then
		for Dir in $(ls -d $SubP/*${Scan}*); do
			if [ $(find $Dir -name *.gz | wc -l) -lt 100 ]; then
				echo $Dir
				rm -r $Dir
			fi
		done
	fi
	# If 2 runs
	if [ $(ls -d $SubP/*${Scan}* | wc -l) -eq 2 ]; then
		mv $SubP/*${Scan}_1* $SubP/${Scan}1
		mv $SubP/${Scan}1 $SubP/ppc
		mv $SubP/*${Scan}_2* $SubP/${Scan}2
		mv $SubP/${Scan}2 $SubP/ppc
		sh $UnZip $SubP/ppc/${Scan}1
		sh $UnZip $SubP/ppc/${Scan}2
	# Else if 1 run
	else
		if [ $(ls -d $SubP/*$Scan* | wc -l) -eq 1 ]; then
			mv $SubP/*$Scan* $SubP/$Scan
			mv $SubP/$Scan $SubP/ppc
			sh $UnZip $SubP/ppc/$Scan
		fi
	fi
	###############################################################################
	# Processing functional data: make vdm, realign & unwarp using SPM12 in matlab.
	###############################################################################
	if [ $((JobNum)) -gt 0 ]; then
		qsub -hold_jid $JobNum -N Ppc2${Scan} -o $JobLogDir $FncPpc2 $SubID $Scan
	else
		qsub -N Ppc2${Scan} -o $JobLogDir $FncPpc2 $SubID $Scan
	fi
fi
