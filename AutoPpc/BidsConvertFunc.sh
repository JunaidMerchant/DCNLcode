#!/bin/bash
############################################################################
# Convert functional MRI data to BIDS folder
# Takes as input: SubjectID, name of functional file, output/BIDS folder path, 
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
#$ -N BidsConvertFunc
# Directory where job/error logs are written. !CHANGE THIS!
#$ -o ~/Desktop
# Use bash
#$ -S /bin/bash
#$ -V
#
if [ $# -ne 4 ]; then
	echo "This is script is to convert functional MRI data into BIDS format"
	echo ""
	echo "Takes as input: 1) SubjectID, 2) name of functional scan, 3) output/BIDS folder path, & 4) Dicom/Input directory"
	echo ""
	echo "USAGE: ./script.sh <SubjectID> <functional scan name> <Output directory> <Input dicom directory>"
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
# Take in functional file name from input 2
func=$2
#
# assign output directory from input 3, and make directories
outdir=$3sub-${subid}
if [ ! -d $outdir ]; then
	mkdir $outdir
fi
#
if [ ! -d $outdir/func ]; then
	mkdir $outdir/func
fi
#
# Take input/dicom directory from input 4, and assign as input directory
indir=$(find $4 -type d -name $func*)
indirnum=$(find $4 -type d -name $func* | wc -l)
#
# Make sure the func directory exists

# Only in cases where there is one directory for this functional 
if [ "$indirnum" -eq 1 ]; then
	#
	# If the functional is rest, then label it rest
	if [[ $func = *"REST"* ]]; then
		dcm2niix -o $outdir/func/ -f sub-${subid}_task-rest_bold -b y -ba y -z y $indir
	else
		# If not functional then label by protocol name
		dcm2niix -o $outdir/func/ -f sub-${subid}_task-%p_bold -b y -ba y -z y $indir
	fi
	# if more than 1 run, loop through	
elif [ "$indirnum" -gt 1 ]; then
	Runs=($(find $4 -type d -name $func*))
	for f in ${Runs[@]}; do
		# If not functional then label by protocol name
		dcm2niix -o $outdir/func/ -f sub-${subid}_task-%p_bold -b y -ba y -z y $f
	done
else
	echo "$indir doesnt exist"
fi
