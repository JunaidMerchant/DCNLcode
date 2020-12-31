#!/bin/bash
############################################################################
#		Convert Dicoms Script
# Takes subjectID, output/convert directory path, dicom directory path, 
# & scan/sequence name as input & converts the dicoms to nii files.
# Can be used as a bash script or qsub for the grid!
# Paths & variables that need changing are marked with "!CHANGE THIS!", 
# and only include -o (output directory for the qsub log).
# example usage: 
# > qsub /path/to/Convert.sh Sub001 /path/to/output /path/to/dicoms "mprage"
# Or as from FullPpc.sh: 
# > sh $Vert $SubID $VertDir $DcmDir $f1
#
# -junaid.salim.merchant 2017.02.06
############################################################################
#
#################
# Qsub options. #
#################
# Use current working directory
#$ -cwd
# Combine job and error logs
#$ -j y
# Use bash
#$ -S /bin/bash
#$ -V
#
##########################
# Define SubID and Paths #
##########################
# Define subject id from input 1
SubID=$1
#
# Define input dicom directory from input 2
In=$2
#
# Define output directory from input 3
Out=$3
#
# Define current scan to convert from input 4
Cur=$4
#
#################
# Convert scans #
#################
#
mcverter -o ${Out} -f nifti -j -x -n -m ${Cur} -F +PatientName-PatientId-SeriesDate-SeriesTime-StudyId-StudyDescription-SeriesNumber-SequenceName+ProtocolName-SeriesDescription ${In}




