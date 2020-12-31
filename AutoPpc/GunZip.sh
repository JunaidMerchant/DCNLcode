#!/bin/bash
#$ -cwd
#$ -j y
# #$ -N GunZip
#$ -S /bin/bash
#$ -V
# Takes path to directory, and GunZips all the gz's in it.
#
# Define path to directory
CurPath=$1
CurSubDirsNum=$(ls -d $CurPath/*/ | wc -l)
#
if [ $CurSubDirsNum -gt 0 ]; then
	for CDir in $(ls -d $CurPath/*/); do
		echo --------------------------------------
		echo GunZipping $CDir
		date
		echo --------------------------------------
		find $CDir -name *.gz | xargs gunzip
	done
fi
#
#
if  [ $CurSubDirsNum -eq 0 ]; then
	echo --------------------------------------
	echo GunZipping $CurPath
	date
	echo --------------------------------------
find $CurPath -name *.gz | xargs gunzip
fi
