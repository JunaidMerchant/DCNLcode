#!/bin/bash
############################################################################
# Convert T1 structural data to BIDS folder
# Takes as input: SubjectID, name of structural file, output/BIDS folder path, 
# & Dicom/Input directory. 
# -junaid.salim.merchant 2018.07.30
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
#$ -N BidsConvertStruct
# Directory where job/error logs are written. !CHANGE THIS!
#$ -o ~/Desktop
# Use bash
#$ -S /bin/bash
#$ -V
#
if [ $# -ne 4 ]; then
	echo "This is script is to convert T1 structural MRI data into BIDS format"
	echo ""
	echo "Takes as input: 1) SubjectID, 2) name of structural file, 3) output/BIDS folder path, & 4) Dicom/Input directory"
	echo ""
	echo "USAGE: ./script.sh <SubjectID> <Structural file name> <Output directory> <Input dicom directory>"
	exit; 
fi
#
if [ `which dcm2niix | wc -l` -eq 0 ]; then
	echo "Missing dcm2niix... Make sure it's in your path!"
	exit;
fi
#
# Take in the subject ID from first input, but remove any dashes or special characters
subid=${1//[-._]/}
#
# Take in structural file from input 2
struct=$2
#
# assign output directory from input 3, and make directories
outdir=$3sub-${subid}
if [ ! -d $outdir ]; then
	mkdir $outdir
fi
#
if [ ! -d $outdir/anat ]; then
	mkdir $outdir/anat
fi
#
# Take input/dicom directory from input 4, and assign as input directory
indir=$(find $4 -type d -name $struct*)
#
#
dcm2niix -o $outdir/anat/ -f sub-${subid}_T1w -b y -ba y -z y $indir

