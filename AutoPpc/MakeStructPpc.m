function MakeStructPpc(SpmDir, SubID, SubP, Template, CodeDir, PpcBatchDir, StructName)

%% Set up all the variables based on the input of subject ID.
addpath(SpmDir);
addpath(CodeDir);
spm_jobman('initcfg');

Rage=findfiles(SubP,strcat(SubID,'_',StructName,'.nii'));
bRage=findfiles(SubP,strcat('b_',StructName,'.nii'));
%
%% Start with structurals--coregister structurals to template & segment.
% Coregister MPRAGE to MNI template
try
    matlabbatch{1}.spm.spatial.coreg.estimate.ref = {Template};
    matlabbatch{1}.spm.spatial.coreg.estimate.source = bRage;
    matlabbatch{1}.spm.spatial.coreg.estimate.other = Rage;
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [8 4 2 1];
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
    matlabbatch{2}.spm.spatial.preproc.channel.vols = Rage;
    
    matlabbatch{2}.spm.spatial.preproc.channel.biasreg = 0.001;
    matlabbatch{2}.spm.spatial.preproc.channel.biasfwhm = 60;
    matlabbatch{2}.spm.spatial.preproc.channel.write = [1 1];
    matlabbatch{2}.spm.spatial.preproc.tissue(1).tpm = {strcat(SpmDir,'/tpm/TPM.nii,1')};
    matlabbatch{2}.spm.spatial.preproc.tissue(1).ngaus = 2;
    matlabbatch{2}.spm.spatial.preproc.tissue(1).native = [1 1];
    matlabbatch{2}.spm.spatial.preproc.tissue(1).warped = [1 1];
    matlabbatch{2}.spm.spatial.preproc.tissue(2).tpm = {strcat(SpmDir,'/tpm/TPM.nii,2')};
    matlabbatch{2}.spm.spatial.preproc.tissue(2).ngaus = 2;
    matlabbatch{2}.spm.spatial.preproc.tissue(2).native = [1 1];
    matlabbatch{2}.spm.spatial.preproc.tissue(2).warped = [1 1];
    matlabbatch{2}.spm.spatial.preproc.tissue(3).tpm = {strcat(SpmDir,'/tpm/TPM.nii,3')};
    matlabbatch{2}.spm.spatial.preproc.tissue(3).ngaus = 2;
    matlabbatch{2}.spm.spatial.preproc.tissue(3).native = [1 1];
    matlabbatch{2}.spm.spatial.preproc.tissue(3).warped = [1 1];
    matlabbatch{2}.spm.spatial.preproc.tissue(4).tpm = {strcat(SpmDir,'/tpm/TPM.nii,4')};
    matlabbatch{2}.spm.spatial.preproc.tissue(4).ngaus = 3;
    matlabbatch{2}.spm.spatial.preproc.tissue(4).native = [0 0];
    matlabbatch{2}.spm.spatial.preproc.tissue(4).warped = [0 0];
    matlabbatch{2}.spm.spatial.preproc.tissue(5).tpm = {strcat(SpmDir,'/tpm/TPM.nii,5')};
    matlabbatch{2}.spm.spatial.preproc.tissue(5).ngaus = 4;
    matlabbatch{2}.spm.spatial.preproc.tissue(5).native = [0 0];
    matlabbatch{2}.spm.spatial.preproc.tissue(5).warped = [0 0];
    matlabbatch{2}.spm.spatial.preproc.tissue(6).tpm = {strcat(SpmDir,'/tpm/TPM.nii,6')};
    matlabbatch{2}.spm.spatial.preproc.tissue(6).ngaus = 2;
    matlabbatch{2}.spm.spatial.preproc.tissue(6).native = [0 0];
    matlabbatch{2}.spm.spatial.preproc.tissue(6).warped = [0 0];
    matlabbatch{2}.spm.spatial.preproc.warp.mrf = 1;
    matlabbatch{2}.spm.spatial.preproc.warp.cleanup = 1;
    matlabbatch{2}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
    matlabbatch{2}.spm.spatial.preproc.warp.affreg = 'mni';
    matlabbatch{2}.spm.spatial.preproc.warp.fwhm = 0;
    matlabbatch{2}.spm.spatial.preproc.warp.samp = 2;
    matlabbatch{2}.spm.spatial.preproc.warp.write = [1 1];
    save(fullfile(PpcBatchDir,strcat(SubID,'_StructPpc.mat')),'matlabbatch');
    spm_jobman('run',matlabbatch);
    clear matlabbatch
end
end