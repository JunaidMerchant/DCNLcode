# DCNL code

Code I wrote for the Developmental Cognitive Neuroscience Lab (DCNL) at Georgetown University. 
This was all towards the RDoC R01 grant awarded to Chandan Vaidya (PI: DCNL; Georgetown U) and Lauren Kenworthy (Director: Center for Autism Spectrum Disorders; Children's National Medical Center). 

## AutoPpc
AutoPpc is a fully automated, end-to-end data processing pipeline for task, rest, and structural MRI protocols collected for the RDoC project. As data from new participants were collected, this pipeline did the following: 1) converted all MRI data from DICOM to NIFTI format; 2) preprocessed the fMRI data using SPM and FSL (slice-time correction, fieldmap unwarping, realignment/motion correction, skull-strip, normalized to MNI template, smooth 6mm FWHM); 3) get motion summaries for each functional run and update group-level motion summaries spreadsheet; 4) calculate all the behavioral responses for each of the 3 tasks (N-Back working memory, stop-signal behavioral inhibition, and social stroop tasks) and update group-level behavioral spreadsheets; 5) create SPM batches and run first-level fMRI models for each of the 3 tasks. 

## ShinyApps 
These are a collection of web apps I created using ShinyR to help RAs score clinical measures and to perform 3-way classification based on behavioral profiles of executive dysfunction (in collaboration with Xiaozhen You).
