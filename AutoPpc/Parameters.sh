#!/bin/bash
############################################################################
#	Define & Export Study Parameters
# Change the the study variables and paths below to match your study to use
# the automated preprocessing. 
#
# -junaid.salim.merchant 2017.02.07
############################################################################



#########################################################
## YOU NEED TO CHANGE THESE VARIABLES FOR EACH STUDY!! ##
#########################################################

## Export Subject ID
export SubID=$SubID

## Export Study name
export StudyName="RDOC"

## Export latest update
export LatestUpdate="August 13 2018"

## Export last person to update
export LastUpdater="Junaid -- merchantjs@gmail.com"

## Author
export Author="junaid.salim.merchant | merchantjs@gmail.com"

## Export path to the code directory where this & associated scripts reside.
export CodeDir="/media/jm3080/Naider/RDOC/code/AutoPpc"

## Image
export BrainMe=$CodeDir/BrainMe2.jpg

## Export study directory
export StudyDir="/media/jm3080/Naider/RDOC/"

## Export path to SPM directory
export SpmDir=/home/jm3080/Documents/MATLAB/spm12

## Export BIDS directory
export BidsDir="/media/jm3080/Naider/RDOC/BIDS/"

## Export fMRIprep directory
export FmriPrepDir="/media/jm3080/Naider/RDOC/fMRIprep/"

## Export path to dicoms directory.
export DcmDir="/media/jm3080/Naider/RDOC/dicoms/"

# Export path to converted directory.
export VertDir="/media/jm3080/Naider/RDOC/converted/"

# Export path to ppc directory.
export PpcDir="/media/jm3080/Naider/RDOC/ppc/"

# Export path to zipped download directory.
export ZipDir="/media/jm3080/Naider/RDOC/zippedownloads/"

# Export path to motion directory.
export MotionDir="/media/jm3080/Naider/RDOC/motion/"

# Export path to behavioral directory.
export BxDir="/media/jm3080/Naider/RDOC/bx/"

# Export path to first level modelsdirectory.
export FxDir="/media/jm3080/Naider/RDOC/fx/"

# Export path to R script to calculate SSRT.
export SSRT="/media/jm3080/Naider/RDOC/bx/StopSignal/analyse_stop.R"

# Export path to fieldmap parameters file for calculating VDMs
# MUST BE ADJUSTED TO MATCHING SCANNING PARAMETERS. CONSULT THIS: 
# https://lcni.uoregon.edu/kb-articles/kb-0003
export FmapPm=$CodeDir/pm_defaults_jsm.m

# Export fieldmap scans you want to convert from dicoms
export Fmap=("field_mapping")

# Export structural scans you want to convert from dicoms
export Struct=("MPRAGE" "t2_structural")

# Export functional scans you want to convert from dicoms
export Func=("Resting" "NBack" "StopSignal" "SocStroop")

# Export All scans you want to convert from dicoms
export All=(${Fmap[@]} ${Struct[@]} ${Func[@]})

# Export minimum number of scans in functional run to be counted good.
MinScn=100

# Export path to MNI template used for coregistration
export MNI="/media/jm3080/Naider/RDOC/code/MNI152_T1_1mm_brain.nii"

# Export path to directory where PPC batches are saved
export PpcBatchDir="/media/jm3080/Naider/RDOC/code/PpcBatches"

# Export path to directory where Fx batches are saved
export FxBatchDir="/media/jm3080/Naider/RDOC/code/FxBatches"

#####################################################################
## Export PATHS TO SUBJECT SPECIFIC DIRECTORIES: DO NOT CHANGE THESE!
#####################################################################

# Export subject path to dicom directory
# SubD=$(zenity --file-selection --directory --title="Choose the input DICOM directory for this subject")
# export $SubD
export SubD=$DcmDir$SubID

# Export subject path to converted directory
export SubC=$VertDir$SubID

# Export subject path to ppc directory
export SubP=$PpcDir$SubID

# Export subject path to zipped directory
export SubZ=$ZipDir*"$SubID"*

# Export subject path to bids directory
export SubB=$BidsDir$SubID

# Export subject path to fmriprep directory
export SubF=$FmriPrepDir$SubID

################################################
## Export PATHS TO SCRIPTS: DO NOT CHANGE THESE!
################################################
## Export path to Name header
export BidsF=${CodeDir}/BidsConvertFunc.sh

## Export path to Name header
export BidsS=${CodeDir}/BidsConvertStruct.sh

## Export path to Name header
export NameHeader=${CodeDir}/JSM_name_header.sh

# Export path to process fieldmaps script
export FmpPpc=${CodeDir}/FmapPpc.sh

# Export path to process structural script part 1
export StrctPpc1=${CodeDir}/StructPpc.sh

# Export path to process structural spm script part 2
export StrctPpc2=${CodeDir}/MakeStructPpc.m

# Export path to create dartel spm job
export Dartel=${CodeDir}/DartelCreateTemplate.m

# Export path to process functionals script part 1
export FncPpc1=${CodeDir}/FuncPpc1.sh

# Export path to process functionals qsub script part 2
export FncPpc2=${CodeDir}/FuncPpc2.sh

# Export path to convert script
export Vert=${CodeDir}/Convert.sh

# Export path to organize functionals script
export OrgF=${CodeDir}/OrganizeFunc.sh

# Export path to organize structurals script
export OrgS=${CodeDir}/OrganizeStruct.sh

# Export path to gzip/compress script
export Zip=${CodeDir}/GZip.sh

# Export path to unzip/extract script
export UnZip=${CodeDir}/GunZip.sh

# Export path to clean/organize converted script
export ClnVrt=${CodeDir}/CleanVert.sh

# Export path to Zip/Bet/Gunzip functionals script
export ZipBetGun=${CodeDir}/ZipBetGun.sh

# Export path to motion bash wrapper file
export Motion=${CodeDir}/Motion.sh

# Export path to behavioral summary bash wrapper file
export Bx=${CodeDir}/Bx.sh

# Export path to Calc_FD file
export FD=${CodeDir}/Calc_FD.m

# Export path to motion summary file
export MotSum=${CodeDir}/MotionSummary.m

# Export path to Normalize file
export Norm=${CodeDir}/NormFunc2Mni.m

# Export path to Ppc1 file
export Ppc1=${CodeDir}/Ppc1SpmBatch.sh

# Export path to Ppc1 file
export Ppc2=${CodeDir}/Ppc2SpmBatch.sh

# Export path to Bet func file
export Bet=${CodeDir}/BetFunc.sh

# Export path to Fx func file
export Fx=${CodeDir}/Fx1SpmBatch.sh

# Export path to contrasts for first level model file
export Contrasts=${CodeDir}/Contrasts.m