#!/bin/bash
############################################################################
#	Realign/Unwarp-Bet-Coregister2Structural Functionals 
# Takes subject ID, subject ppc directory, & functional scans as input,  
# & makes vdm, realigns, unwarps, skull-strips, and coregisters functional
# files to structural
#
# Can be used as a bash script or qsub for the grid!
#
# Paths & variables that need changing are marked with "!CHANGE THIS!"
# 
# Including -o (output directory for the qsub log) & Path to RunPpc1Func1.m,
# ZipBetGun.sh, & RunPpc1Func2.m
#
# example usage: 
# > qsub /path/to/Qsub_SPmPpc1Func_job.sh Sub001 /path/to/subjects/ppc/Sub001 Picture1
# Or as from FullPpc.sh: 
# > qsub $FncPpc $SubID $SubP $f
#
# -junaid.salim.merchant 2016.08.16
############################################################################
#
###############
# Qsub options.
###############
# Use current working directory
#$ -cwd
# Combine job and error logs
#$ -j y
# Use bash
#$ -S /bin/bash
#$ -V
#
#
###################################################
# Define paths to directories and mri scans to use.
###################################################
# Define subject id from input 1
SubID=$1
#
# Define functional scan name from input 2
Scan=$2
#
# Unload and Load matlab
module unload matlab
module load matlab/R2016a
#
# Run first part of Ppc
echo ---------------------------------------------------------
echo Realign and Unwarp $SubID $Scan
date
echo ---------------------------------------------------------
# Run RunPpc1Func1.m by defining the path to script 
# matlab -nosplash -nodisplay -nodesktop -r "clear; addpath('/vxfsvol/home/research/junaid/matlab/spm12'); addpath('/home/research/sanlab/matlab/NeuroElf_v09c'); spm_jobman('initcfg'); CurSub= '$1'; SubP= '$SubP'; Func= '$Scan'; run('$FncPpc3'); spm_jobman('run',matlabbatch); exit"
matlab -nosplash -nodisplay -nodesktop -r "clear; addpath('/vxfsvol/home/research/sanlab/matlab/spm12_jsm'); addpath('/home/research/sanlab/matlab/NeuroElf_v09c'); spm_jobman('initcfg'); CurSub= '$1'; SubP= '$SubP'; Func= '$Scan'; run('$FncPpc3'); spm_jobman('run',matlabbatch); exit"
#
#
CurP=$SubP/ppc
#
# Change into subject ppc directory
cd $CurP
#
# Zip, bet, and gunzip functionals using ZipBetGun.sh
echo ---------------------------------------------------------
echo Zip, Bet, and Gunzip $SubID $Scan
date
echo ---------------------------------------------------------
for F in $(ls -d $Scan*); do
	CurF=$CurP/$F
	# Run ZipBetGun.sh 
	sh $ZipBetGun $SubID $F
done
#
# Run second part of Ppc
echo ---------------------------------------------------------
echo Coregister $SubID $Scan to structural
date
echo ---------------------------------------------------------
# Run RunPpc1Func2.m 
# matlab -nosplash -nodisplay -nodesktop -r "clear; addpath('/vxfsvol/home/research/junaid/matlab/spm12'); addpath('/home/research/sanlab/matlab/NeuroElf_v09c'); spm_jobman('initcfg'); CurSub= '$1'; SubP= '$SubP'; Func= '$Scan'; run('$FncPpc4'); spm_jobman('run',matlabbatch); clear matlabbatch; run('$Norm'); exit"
matlab -nosplash -nodisplay -nodesktop -r "clear; addpath('/vxfsvol/home/research/sanlab/matlab/spm12_jsm'); addpath('/home/research/sanlab/matlab/NeuroElf_v09c'); spm_jobman('initcfg'); CurSub= '$1'; SubP= '$SubP'; Func= '$Scan'; run('$FncPpc4'); spm_jobman('run',matlabbatch); clear matlabbatch; run('$Norm'); exit"