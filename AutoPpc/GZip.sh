#!/bin/bash
#$ -cwd
#$ -j y
#$ -S /bin/bash
#$ -V
#$ -N GZip
# Takes path to directory, and GZips all the nii's in it.
#
# Define path to directory
CurPath=$1
CurSubDirsNum=$(ls -d $CurPath/*/ | wc -l)
if [ $CurSubDirsNum -gt 0 ]; then
for CDir in $(ls -d $CurPath/*/)
do
find $CDir -name *.nii | xargs gzip
done
fi
if  [ $CurSubDirsNum -eq 0 ]; then
find $CurPath -name *.nii | xargs gzip
fi
