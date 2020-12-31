# AutoPpc

AutoPpc is a fully automated, end-to-end data processing pipeline for task, rest, and structural MRI protocols collected for the RDoC project. As data from new participants were collected, this pipeline did the following: 1) converted all MRI data from DICOM to NIFTI format; 2) preprocessed the fMRI data using SPM and FSL (slice-time correction, fieldmap unwarping, realignment/motion correction, skull-strip, normalized to MNI template, smooth 6mm FWHM); 3) get motion summaries for each functional run and update group-level motion summaries spreadsheet; 4) calculate all the behavioral responses for each of the 3 tasks (N-Back working memory, stop-signal behavioral inhibition, and social stroop tasks) and update group-level behavioral spreadsheets; 5) create SPM batches and run first-level fMRI models for each of the 3 tasks.

While this was very useful for the RDoC project at the time, I recommend using more standardized tools from BIDS/BIDS Apps ecosystem for anyone wanting to accomplish a similar objective. 

Nonetheless, if you find this usefull, here are descriptions for each of the functions:


BetFunc.sh - Skull-strips the functional files. Takes as input 1) subject ppc directory 2) name of functional run
BidsConvertFunc.sh - Convert functional fMRI files from DICOMS to BIDS format using dcm2niix. Takes as input 1) SubjectID, 2) name of functional scan, 3) output/BIDS folder path, & 4) Dicom/Input directory
BidsConvert.sh - Template for conversion from DICOMS to BIDS format. Not used in pipeline, and is hardcoded, but might be useful for later
BidsConvertStruct.sh - Convert structural MRI files from DICOMS to BIDS format using dcm2niix. Takes as input 1) SubjectID, 2) name of structural file, 3) output/BIDS folder path, & 4) Dicom/Input directory & 4) Dicom/Input directory
BrainMe2.jpg - Image file that pops up when you start AutoPpc. Totally unnecessary :P
Bx.sh - Runs the behavioral analysis for the tasks. Takes as input 1) Subject ID, 2) code directory, 3) behavioral data directory, 4) functional task name
Calc_FD.m - Calculates frame-wise displacement for functional run. Takes as input 1) rp text file, 2) FD threshold
ChangeNames.sh - Not part of pipeline, but is really useful if the CFMI RA’s misname the subject id of a scan, which is a huge pain because every converted MR file then has this wrong name.
Contrasts.m - Matlab file that defines the contrasts of interest for each task
Convert.sh - Converts from DICOM to nifti using MRIConvert. Takes as input 1) subject ID, 2) input directory, 3) output directory, 4) and MRI protocol to convert
findfiles.m - matlab function that is equivalent to the ‘find’ command in bash. I use this function in all of my matlab code
Fx1SpmBatch.sh - Bash script that launches matlab/spm and creates and runs first-level models, takes as input: SpmDir, SubID, SubP, CodeDir, FxBatchDir, BxDir, FxDir, MotionDir, Contrasts, Func
GunZip.sh - not used, but can be used to unzip all the gz files
GZip.sh - not used, but can be used to zip to gz files
MakeFxBatch.m - Makes and runs the first-level model SPM batch, and is called on by the Fx1SpmBatch.sh script
MakePpcBatch1.m - Makes and runs the first part of functional preprocessing, and is called by Ppc1SpmBatch.sh script. Takes as input: SpmDir, SubID, SubP, CodeDir, PpcBatchDir, Func, Fmap, Defaults (fieldmaps defaults file)
MakePpcBatch2.m - Makes and runs the second part of functional preprocessing, and is called by Ppc2SpmBatch.sh script. Takes as input: SpmDir, SubID, SubP, CodeDir, PpcBatchDir, Func, Struct
MakeStructPpc.m - Makes and runs the structrual preprocessing SPM batch, and is called by StructPpc.sh script. Takes as input: SpmDir, SubID, SubP, Template, CodeDir, PpcBatchDir, StructName
Motion.sh - Copies motion rp text files to the motion folder, runs the Calc_FD function on it. Takes as input: Subject ppc folder, the name of functional run, and the motion directory to save to
MotionSummary.m - Summarizes the motion data for all subjects of a motion directory
OrganizeFunc.sh - Organizes the functional data into preprocessing folder. Takes as input SubID, the from folder, the to folder, and the fieldmap name (if there is one)
OrganizeStruct.sh - Organizes and skull strips the structural data into the preprocessing folder. Takes as input: SubID, subject ppc folder, and name of structural
Parameters.sh - VERY IMPORTANT parameters file, where you change parameters, paths, study ID etc to make the AutoPpc pipeline work for the specific study
pm_defaults_jsm.m - SPM parameters file for converting fieldmap scans to voxel displacement maps. Consult this link to figure out what to edit: https://lcni.uoregon.edu/kb-articles/kb-0003
Ppc1SpmBatch.sh - Bash script that launches matlab/spm and creates and runs first part of ppc for functional data , takes as input: SpmDir, SubID, SubP, CodeDir, PpcBatchDir, functional run name,fieldmap name
Ppc1Sub.sh - VERY IMPORTANT wrapper script that runs the appropriate scripts in order to create the pipeline. Can be modified to fit the study.
Ppc2SpmBatch.sh - Bash script that launches matlab/spm and creates and runs second part of ppc for functional data , takes as input: SpmDir, SubID, SubP, CodeDir, PpcBatchDir, functional run name, structural scan name
RunBx.m - matlab script that runs the behavioral analysis for the task data
StructPpc.sh - bash script that launches matlab/spm and creates and runs ppc for structural data , takes as input: SpmDir, SubID, SubP, brain template, code dir, ppcbatchdir, and structural scan name.
