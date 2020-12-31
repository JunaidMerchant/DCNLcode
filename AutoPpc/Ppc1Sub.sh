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
####  !!!   ATTENTION   !!!    #######################
# THIS IS THE ONLY THING THAT NEEDS TO BE CHANGED IN THIS FILE
source /media/jm3080/Naider/RDOC/code/AutoPpc_working/Parameters.sh
#
# THE ABOVE COULD BE CHANGED TO BE MORE ELEGANT SO THAT YOU ONLY MODIFY THE PARAMETERS FILE
#
#
# Define name of script to variable 'me'
me="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
#
# Define Subject ID from input 1
if [ $# -eq 0 ]; then
	echo "This is script is the automated data processing pipeline for the $StudyName study, and requires one input parameter, which is the Subject ID."
	echo ""
	echo "USAGE: ./$me <SubjectID>"
	echo ""
	echo "Author: $Author"
	echo "Last updated on $LatestUpdate by $LastUpdater"
	exit;
else
	SubID=$1
	source $CodeDir/Parameters.sh
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
	exit;
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
	unzip -q $SubZ -d $SubD
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
# Organize/copy structural files inot subject's ppc folder
if [ ! -d $SubP/struct ]; then 
	echo - structurals
	mkdir $SubP/struct
	for s in ${Struct[@]}; do
		if [ -d *$s* ]; then
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
# Start loop to consolidate phase and mag images of a fmap into the same folder
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
	else
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
echo --------------------------------------
echo Zipping .nii files
date
find $SubC -name *.nii | xargs gzip
echo --------------------------------------
#
#
# Change back into the code directory
cd $CodeDir
#
#
# Start preprocessing structural data
$StrctPpc1 $SpmDir $SubID $SubP $MNI $CodeDir $PpcBatchDir $Struct
#
# Start preprocessing functional data
# THE THING THAT IS HARDCODED IN HERE IS THE SLICE TIME PARAMETERS. I DON'T KNOW HOW TO READ THOSE IN EASILY
for f in ${Func[@]}; do
	if [ $(ls -d $SubP/$f* 2>/dev/null | wc -l) -gt 0 ]; then
		$Ppc1 $SpmDir $SubID $SubP $CodeDir $PpcBatchDir $f $Fmap $FmapPm
		$Bet $SubP $f
		$Ppc2 $SpmDir $SubID $SubP $CodeDir $PpcBatchDir $f $Struct
	fi
done
#
#
# Start Fx
$Fx "'${SubID}'"
#
# Run script to calculate SSRT
R < $SSRT --no-save
