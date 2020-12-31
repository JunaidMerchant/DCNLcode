#!/bin/bash
############################################################################
# In case the CFMI staff names the participants improperly, here's 
# a quick script change the names of all the converted imaging files. 
# Usage: ./ChangeNames.sh <directory to search> <string to replacein file names> <new string to change to>
# -junaid.salim.merchant 2018.07.31
############################################################################
#
if [ $# -lt 3 ]; then
	echo "This is script is an easy way to change a regular expression string for all file names in a directory"
	echo "For example, in case the CFMI staff names the participant improperly."
	echo ""
	echo "USAGE: ./ChangeName.sh <directory-to-search> <string-to-replace-in-file-names> <new-string-to-change-to>"
	echo ""
	exit;
else
	Dir=$1
	#
	# Define bad regular expression in file name to be changed. 
	Bad=$2
	#
	# Define good regular expression in file name to be changed to. 
	Good=$3

	for s in $(find $Dir -type f -name "$Bad*"); do 
		mv $s ${s/$Bad/$Good} 
	done
fi