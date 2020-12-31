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
#$ -o /home/
# Use bash
#$ -S /bin/bash
#$ -V
#
#
# For testing purposes, you could source this directly below:
# source /media/jm3080/Naider/RDOC/code/AutoPpc_working/Parameters.sh
#
# THE ABOVE COULD BE CHANGED TO BE MORE ELEGANT SO THAT YOU ONLY MODIFY THE PARAMETERS FILE
#
#
# Define name of script to variable 'me'
me="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
#
# Define Subject ID from input 1
if [ $# -lt 2 ]; then
	echo "This is script is the automated data processing pipeline for the $StudyName study, and requires two input parameters, which are the Subject ID, and the parameters file."
	echo ""
	echo "USAGE: ./$me <SubjectID> <Parameters>"
	echo ""
	echo "Author: $Author"
	echo "Last updated on $LatestUpdate by $LastUpdater"
	exit;
else
	SubID=$1
	Parameters=$2
	source $Parameters
	echo --------------------------------------
	if [ `which figlet | wc -l` -eq 1 ]; then
		figlet AutoPpc
	fi
	echo ""
	echo "This is script is the automated data processing pipeline for the $StudyName study."
	echo "Author: $Author"
	echo "Last updated on $LatestUpdate by $LastUpdater"
	echo --------------------------------------
	if [ `which eog | wc -l` -eq 1 ]; then
		eog $BrainMe &
	fi
fi
#
# Look for FSL and exit if not in path
if [ `which fsl | wc -l` -eq 0 ]; then
	echo "Missing FSL... Make sure it's in your path!"
	exit;
fi
#
# Look for matlab and exit if not in path
if [ `which matlab | wc -l` -eq 0 ]; then
	echo "Missing Matlab... Make sure it's in your path!"
	exit;
fi
#
# Look for mcverter and exit if not in path
if [ `which mcverter | wc -l` -eq 0 ]; then
	echo "Missing mcverter... Make sure it's in your path!"
	exit;
fi
#
# Look for dcm2niix and exit if not in path
if [ `which dcm2niix | wc -l` -eq 0 ]; then
	echo "Missing dcm2niix... Make sure it's in your path!"
	exit;
fi
#
#
# Unzip file into subject dicom directory
#mkdir $SubD
if [ ! -d $SubD ]; then # This can be changed out using new techniques learned in: http://tldp.org/LDP/abs/html/fto.html
	echo --------------------------------------
	echo Unzipping $SubID
	date
	echo --------------------------------------
	for s in ${SubZ[@]}; do
		unzip -q "$s" -d $SubD
	done
	unset s
fi

# Convert all the files into the converted folder
if [ ! -d $SubC ]; then
	echo --------------------------------------
	echo Converting $SubID
	date
	for x in ${All[@]}; do
		echo - $x
		$Vert $SubID $SubD $VertDir $x
	done
	unset x
fi
echo --------------------------------------
#
#

### BIDS FORK  #########################################
# Now Convert into BIDS directory
echo --------------------------------------
echo Creating BIDS file organization
date
# first the mprage
$BidsS $SubID ${Struct[0]} $BidsDir $SubD
#
# then the functional files. 
# Note, that for the functional file name, we capitilize it (using ^^)
# before feeding it in because the dicom directories are in all caps. 
# Used: https://unix.stackexchange.com/questions/51983/how-to-uppercase-the-command-line-argument
# The script assumes a specific file organization. 
for s in ${Func[@]}; do
	$BidsF $SubID ${s^^} $BidsDir $SubD
done
unset s
# TO DO: ADD IN AND FIGURE OUT HOW TO INCORPORATE FIELDMAPS
# TO DO: ADD IN TSV FILES FOR TASK FMRI
echo --------------------------------------
### END BIDS FORK  #########################################
#
#
#
#
echo --------------------------------------
echo Organizing $SubID for Ppc
date
# Create the Ppc directory for the subject if there isn't one
if [ ! -d $SubP ]; then
	mkdir $SubP
	
fi
#
# Change into the subject's converted folder
cd $SubC
#
# Clean up and Organize:
#
# Organize/copy structural files into subject's ppc folder, and bet the MPRAGE
if [ ! -d $SubP/struct ]; then 
	echo - structurals
	mkdir $SubP/struct
	for s in ${Struct[@]}; do
		if [ $(ls -d *"$s"* | wc -l) -gt 0 ]; then
			$OrgS $SubID $SubP $s
		fi
	done
	unset s
fi
#
# Start loop to eliminate any functional runs that weren't completed (i.e. have less than 100 volumes)
echo - functionals
for y in ${Func[@]}; do
	for z in $(ls -d *"$y"*); do
		if [ $(ls $z/*.nii 2>/dev/null | wc -l) -lt $MinScn ]; then
			rm -r $z
		fi
	done
	unset z
done
unset y
#
# Start loop to consolidate phase and magnitude images of a fmap into the same folder
# First, list all folders into array
Folders=($(ls))
# Get number indices of each folder, consolidate into one, and delete the other.
FolderNums=$(seq 0 $((${#Folders[@]}-1)))
for x in ${FolderNums[@]}; do
	if [ $x -gt 0 ]; then
		if [[ ${Folders[x]} == *"$Fmap"* ]] && [[ ${Folders[$((${x}-1))]} == *"$Fmap"* ]]; then
			cp ${Folders[$((${x}-1))]}/*.nii ${Folders[x]}
			cp ${Folders[$((${x}-1))]}/*.txt ${Folders[x]}/${Folders[$((${x}-1))]}.txt
			rm -r ${Folders[$((${x}-1))]}
		fi
	fi
done
unset Folders FolderNums x 
#
#
# Now copy in scans/fieldmap and organize into the subject's ppc folder
for f in ${Func[@]}; do
	FuncFolders=($(ls -d *"$f"*))
	if [ ${#FuncFolders[@]} -gt 1 ]; then
		for x in $(seq 1 ${#FuncFolders[@]}); do
			mkdir ${SubP}/${f}${x}
			$OrgF $SubID ${FuncFolders[$((${x}-1))]} ${SubP}/${f}${x} $Fmap
		done
		unset x
	elif [ ${#FuncFolders[@]} -eq 1 ]; then
		mkdir ${SubP}/${f}
		$OrgF $SubID ${FuncFolders} ${SubP}/${f} $Fmap
	fi
done
unset f
echo --------------------------------------
#
#
#
# Gzip/compress the files in the converted folder
#### COMMENTED THIS OUT FOR NOW, BUT I RECOMMEND PERIODICALLY ZIPPING
# NIFTI FILES TO SAVE DISK SPACE ####
# echo --------------------------------------
# echo Zipping .nii files
# date
# find $SubC -name *.nii | xargs gzip
# echo --------------------------------------
#
#
# Change back into the code directory
cd $CodeDir
#
#
# Preprocess structural data. Coregister to template and segmentation/Normalization. Uses only MPRAGE and betted MPRAGE data
$StrctPpc1 $SpmDir $SubID $SubP $MNI $CodeDir $PpcBatchDir $Struct
#
# Loop through the functional scan list and do the following:
# 1) preprocess part1: slice-time correction, calcluate voxel displacement map (if fieldmap exist), and realign and unwarp
# 2) process behavioral data
# 3) get summary, and update motion summary sheets
# 4) skull strip realign/unwarped and mean data
# 5) preprocess part 2: coregister to structural data, normalize using structural normalization parameters, and smooth to 6mm FWHM
# 6) create first level models for the task fMRI data
#
# NOTE: FOR EACH OF THESE STEPS, YOU MUST MODIFY THE CODE TO SUIT THE PARAMETERS OF YOUR STUDY, INCLUDING (BUT NOT LIMITED TO): 
# slice-timing parameters, fieldmap parameters, behavioral data processing scripts, and first-level model/contrast files
#
for f in ${Func[@]}; do
	if [ $(ls -d $SubP/$f* 2>/dev/null | wc -l) -gt 0 ]; then
		$Ppc1 $SpmDir $SubID $SubP $CodeDir $PpcBatchDir $f $Fmap $FmapPm
		$Motion $SubP $f $MotionDir
		$Bet $SubP $f
		$Ppc2 $SpmDir $SubID $SubP $CodeDir $PpcBatchDir $f $Struct
		if [[ $f != "Resting" ]]; then
			$Bx $SubID $CodeDir $BxDir $f
			$Fx $SpmDir $SubID $SubP $CodeDir $FxBatchDir $BxDir $FxDir $MotionDir $f
		fi
	fi
done
#
# Run script to calculate SSRT for every subjects as summary results.csv and SSRT.csv
R < $SSRT --no-save > rlog.txt

# run fMRIprep
