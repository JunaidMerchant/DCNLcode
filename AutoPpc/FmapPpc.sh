#!/bin/bash
############################################################################
#		Full PreProcessing Fieldmap
# Takes subject ID as input & converts, organizes, & starts preprocessing
# the structural data. Can be used as a bash script or qsub for the grid!
# Paths & variables that need changing are marked with "!CHANGE THIS!", 
# and include -o, CodeDir, VertDir, DcmDir, PpcDir, Func, Struct, Fmap, 
# example usage: 
# > qsub /path/to/FullPps1.sh Subject001 mprage
#
# -junaid.salim.merchant 2016.08.16
############################################################################
#
############################################
# Qsub options.  Change only the -o option #
############################################
# Use current working directory
#$ -cwd
# Combine job and error logs
#$ -j y
# Use bash
#$ -S /bin/bash
#$ -V
#############################################################
# Define paths to directories and mri scans to use. Change: #
# StudyDir, VertDir, DcmDir, PpcDir, Scans & CodeDir.       #
#############################################################
# Define subject id from input 1.
SubID=$1
#
#
echo _________________________________________________________
echo ---------------------------------------------------------
echo working on $SubID Fieldmap
echo _________________________________________________________
echo ---------------------------------------------------------
############################
# Convert & compress fieldmap
############################
if [ $(find $SubC/*$Fmap* -name *.gz | wc -l) -eq 0 ]; then
	sh $Vert $SubID $Fmap
fi
#
echo --------------------------------------
echo Organizing fieldmaps ppc
date
echo --------------------------------------
#
# Make ppc dir if there isnt one
if [ $(find $SubP | wc -l) -eq 0 ]; then 
	echo making $SubP
	mkdir $SubP
	mkdir $SubP/ppc
	mkdir $SubP/jobsnlogs
fi

#
# Copy fieldmap directories into subject ppc dir
if [ $(find $SubP -name *$Fmap* | wc -l) -lt 3 ]; then
	cp -r $SubC/*$Fmap* $SubP
	echo Copying fieldmaps from converted to sub folder
	# 
	# If 2 sets of fieldmaps
	if [ $(ls -d $SubP/*$Fmap* | wc -l) -eq 4 ]; then
		echo Copying 2 field maps into fmap1 and fmap2
		mkdir $SubP/fmap1
		mkdir $SubP/fmap2
		cp $(ls $SubP/*$Fmap*/*.gz | head -2) $SubP/fmap1
		cp $(ls $SubP/*$Fmap*/*.gz | tail -2) $SubP/fmap2
		rm -r $SubP/*$Fmap*
	else
		# If 1 set of fieldmaps
		if [ $(ls -d $SubP/*$Fmap* | wc -l) -eq 2 ]; then
			echo Copying 1 field map into ppc/fmap1
			mkdir $SubP/fmap1
			cp $SubP/*$Fmap*/*.gz $SubP/fmap1
			rm -r $SubP/*$Fmap*
		fi
	fi
	mv $SubP/fmap* $SubP/ppc
fi
echo ---------------------------------------------------------
echo Finshed $SubID $Fmap
date _________________________________________________________
echo ---------------------------------------------------------
