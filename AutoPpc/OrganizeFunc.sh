#!/bin/bash
#
#
# Get sub ID from input 1
SubID=$1
#
# Get the func folder from which to copy from input 2
From=$2
#
# Get the ppc folder where to copy data to from input 3
To=$3
#
# Get the name of fieldmap files/folder from input 4
Fmap=$4
#
#
#
# First copy the functional files from the 'From' dir to the 'To' dir
cp $From/*.nii $To
#
# Now, see if there are 0 or 1 fieldmap scans. In either case, we can skip the
# complicated assesment of which fieldmap scan to use below. 
if [ $(ls -d *"$Fmap"* 2>/dev/null | wc -l) -eq 0 ]; then 
	echo "No Fieldmaps"
	exit; 
elif [ $(ls -d *"$Fmap"* 2>/dev/null | wc -l) -eq 1 ]; then
	echo "Copying from $(ls -d *"$Fmap"*) to $To"
	cp $(ls -d *"$Fmap"*)/*.nii $To
	exit;
fi
#
# If more than 1 fieldmap scans, must go through and figure which is the closest in time
# to the functional scan of interest. To do this we'll first create an array of the folders,
# and an array of the folder numbers. Then, go through and mark any folders that match the 
# Func folder name or fmap folder name. From this, we can find the first, smallest absolute 
# value between the folder num corresponding with the func folder and the fieldmaps!
#
#
# List all folders into array
Folders=($(ls))
#
# Get number indices of each folder
FolderNums=$(seq 0 $((${#Folders[@]}-1)))
#
# Create variable for the number indices for fieldmap folders, and the From folder
FmapNums=()
FuncNum=()
#
# Loop through and find indices for each
for x in ${FolderNums[@]}; do
	# Fmaps
	if [[ ${Folders[x]} == *"$Fmap"* ]]; then
		FmapNums+=( $x )
	fi
	# and From func
	if [[ ${Folders[x]} == "$From" ]]; then
		FuncNum+=( $x )
	fi
done
unset x
#
#
# Then find absolute differences between FuncNum and each FmapNums to find the best match
# FYI, syntax for absolute differences in bash: https://stackoverflow.com/questions/29223313/absolute-value-of-a-number
#
# First create empty variables for match number and best subtraction (aka the smallest absolute difference)
Match=()
BestSub=()
#
# Loop through. The first time there is a difference of 1 (i.e. fmap either directly pre/proceeded functional), copy it and 
# exit out of the program. Otherwise, go through and keep updating to get the closest fieldmap.
for x in ${FmapNums[@]}; do
	Subtraction=$((${FuncNum}-${x}))
	if [ ${Subtraction#-} -eq 1 ]; then
		echo "Copying from ${Folders[x]} to $To"
		cp ${Folders[x]}/*.nii $To
		exit;
	elif ([ -z $Match ] && [ $Subtraction -ne 1 ]) || ([ ! -z $Match ] && [ ${Subtraction#-} -lt $BestSub ]); then
		BestSub=${Subtraction#-}
		Match=$x
	fi
	unset Subtraction
done
#
# If you've made it this far, you can now use match to copy the appropriate fieldmap
echo "Copying from ${Folders[$Match]} to $To"
cp ${Folders[$Match]}/*.nii $To