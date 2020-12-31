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
SubID=$1

Fmap=("GRE_FIELD_MAPPING")

Struct=("MPRAGE")

Func=("NBACK" "STOPSIGNAL" "SOCSTROOP1" "SOCSTROOP2")


outdir=/media/jm3080/Naider/RDOC/BIDS2_convert2bids/test/sub-${SubID:11:12}
mkdir $outdir
mkdir $outdir/func
mkdir $outdir/anat
#mkdir $outdir/fmap

indir="/media/jm3080/Naider/RDOC/BIDS2_convert2bids/dicoms/*$SubID/*/"

# First do structural
for a in ${Struct[@]}; do
	dcm2niix -o $outdir/anat/ -f sub-${SubID:11:12}_T1w -b y -ba n -z y $indir$a*
done

# convert task fmri
for f in ${Func[@]}; do
	dcm2niix -o $outdir/func/ -f sub-${SubID:11:12}_task-%p_bold -b y -ba n -z y $indir$f*
done

dcm2niix -o $outdir/func/ -f sub-${SubID:11:12}_task-rest_bold -b y -ba n -z y $indir/RESTING*

#for f in ${Fmap[@]}; do
#	dcm2niix -o $outdir/fmap/ -f sub-%n_ses1_%p_fmap -b y -ba n -z y $indir$f*
#done
