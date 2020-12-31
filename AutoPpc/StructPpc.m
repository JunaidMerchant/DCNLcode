%-----------------------------------------------------------------------
% Job saved on 07-Feb-2017 13:18:54 by cfg_util (rev $Rev: 6460 $)
% spm SPM - SPM12 (6906)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
Pwd=pwd;
Rage=findfiles(Pwd,'MPRAGE.nii');
bRage=findfiles(Pwd,'b_MPRAGE.nii');
T2=findfiles(Pwd,'t2_structural.nii');
matlabbatch{1}.spm.spatial.coreg.estimate.ref = {'/media/jm3080/Naider/RDOC/code/MNI152_T1_1mm_brain.nii,1'};
matlabbatch{1}.spm.spatial.coreg.estimate.source = bRage;
matlabbatch{1}.spm.spatial.coreg.estimate.other = Rage;
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [64 32 16 8 4 2 1];
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
matlabbatch{2}.spm.spatial.coreg.estimate.ref = Rage;
matlabbatch{2}.spm.spatial.coreg.estimate.source = T2;
matlabbatch{2}.spm.spatial.coreg.estimate.other = {''};
matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.sep = [64 32 16 8 4 2 1];
matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
matlabbatch{3}.spm.spatial.preproc.channel.vols = {
                                                   '/media/jm3080/Naider/RDOC/ppc/DCNL-RDOC-003/struct/MPRAGE.nii,1'
                                                   '/media/jm3080/Naider/RDOC/ppc/DCNL-RDOC-003/struct/t2_structural.nii,1'
                                                   };
matlabbatch{3}.spm.spatial.preproc.channel.biasreg = 0.001;
matlabbatch{3}.spm.spatial.preproc.channel.biasfwhm = 60;
matlabbatch{3}.spm.spatial.preproc.channel.write = [1 1];
matlabbatch{3}.spm.spatial.preproc.tissue(1).tpm = {'/home/jm3080/Documents/MATLAB/spm12/tpm/TPM.nii,1'};
matlabbatch{3}.spm.spatial.preproc.tissue(1).ngaus = 2;
matlabbatch{3}.spm.spatial.preproc.tissue(1).native = [1 1];
matlabbatch{3}.spm.spatial.preproc.tissue(1).warped = [1 1];
matlabbatch{3}.spm.spatial.preproc.tissue(2).tpm = {'/home/jm3080/Documents/MATLAB/spm12/tpm/TPM.nii,2'};
matlabbatch{3}.spm.spatial.preproc.tissue(2).ngaus = 2;
matlabbatch{3}.spm.spatial.preproc.tissue(2).native = [1 1];
matlabbatch{3}.spm.spatial.preproc.tissue(2).warped = [1 1];
matlabbatch{3}.spm.spatial.preproc.tissue(3).tpm = {'/home/jm3080/Documents/MATLAB/spm12/tpm/TPM.nii,3'};
matlabbatch{3}.spm.spatial.preproc.tissue(3).ngaus = 2;
matlabbatch{3}.spm.spatial.preproc.tissue(3).native = [1 1];
matlabbatch{3}.spm.spatial.preproc.tissue(3).warped = [1 1];
matlabbatch{3}.spm.spatial.preproc.tissue(4).tpm = {'/home/jm3080/Documents/MATLAB/spm12/tpm/TPM.nii,4'};
matlabbatch{3}.spm.spatial.preproc.tissue(4).ngaus = 3;
matlabbatch{3}.spm.spatial.preproc.tissue(4).native = [0 0];
matlabbatch{3}.spm.spatial.preproc.tissue(4).warped = [0 0];
matlabbatch{3}.spm.spatial.preproc.tissue(5).tpm = {'/home/jm3080/Documents/MATLAB/spm12/tpm/TPM.nii,5'};
matlabbatch{3}.spm.spatial.preproc.tissue(5).ngaus = 4;
matlabbatch{3}.spm.spatial.preproc.tissue(5).native = [0 0];
matlabbatch{3}.spm.spatial.preproc.tissue(5).warped = [0 0];
matlabbatch{3}.spm.spatial.preproc.tissue(6).tpm = {'/home/jm3080/Documents/MATLAB/spm12/tpm/TPM.nii,6'};
matlabbatch{3}.spm.spatial.preproc.tissue(6).ngaus = 2;
matlabbatch{3}.spm.spatial.preproc.tissue(6).native = [0 0];
matlabbatch{3}.spm.spatial.preproc.tissue(6).warped = [0 0];
matlabbatch{3}.spm.spatial.preproc.warp.mrf = 1;
matlabbatch{3}.spm.spatial.preproc.warp.cleanup = 1;
matlabbatch{3}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
matlabbatch{3}.spm.spatial.preproc.warp.affreg = 'mni';
matlabbatch{3}.spm.spatial.preproc.warp.fwhm = 0;
matlabbatch{3}.spm.spatial.preproc.warp.samp = 2;
matlabbatch{3}.spm.spatial.preproc.warp.write = [1 1];
