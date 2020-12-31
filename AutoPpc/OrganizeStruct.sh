#!/bin/bash
# Script to copy structural data into ppc and bet
#
SubID=$1
#
SubP=$2
#
Name=$3
#
#
Folders=($(ls -d *$Name*))
#
File=${SubID}_${Name}.nii
#
#
for f in ${Folders[@]}; do
	cp ${f}/${File} ${SubP}/struct/${File}
done
#
bet ${SubP}/struct/${File} ${SubP}/struct/b_${Name} -R 
gunzip ${SubP}/struct/*.gz