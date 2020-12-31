function MakePpcBatch1(SubID)
% This script creates and runs the entire preprocessing for a single
% subject.
%
%% Set up all the variables based on the input of subject ID.
spm_jobman('initcfg');
SubP=fullfile('/media/jm3080/Naider/RDOC/ppc/',SubID);
Rage=findfiles(SubP,strcat(SubID,'_MPRAGE.nii'));
bRage=findfiles(SubP,'b*MPRAGE.nii');
T2=findfiles(SubP,'*t2_structural.nii');
%
Funcs={'NBack' 'Resting' 'SocStroop' 'StopSignal'};
CodeDir='/media/jm3080/Naider/RDOC/code/PpcBatches';
%
%% Start with structurals--coregister structurals to template & segment.
% Coregister MPRAGE to MNI template
if length(Rage)==1 && length(T2)==1
    matlabbatch{1}.spm.spatial.coreg.estimate.ref = {'/media/jm3080/Naider/RDOC/code/MNI152_T1_1mm_brain.nii,1'};
    matlabbatch{1}.spm.spatial.coreg.estimate.source = bRage;
    matlabbatch{1}.spm.spatial.coreg.estimate.other = Rage;
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [8 4 2 1];
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
    %
    % Coregister T2 to MPRAGE (Need to alter this section to accomodate a
    % dependency for subjects without T2 structurals)
    matlabbatch{2}.spm.spatial.coreg.estimate.ref = Rage;
    matlabbatch{2}.spm.spatial.coreg.estimate.source = T2;
    matlabbatch{2}.spm.spatial.coreg.estimate.other = {''};
    matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
    matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.sep = [4 2 1];
    matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
    matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
    %
    % Segment both structural files
    if length(T2)==1
        matlabbatch{3}.spm.spatial.preproc.channel.vols = {Rage{1,1}; T2{1,1}};
    else
        matlabbatch{3}.spm.spatial.preproc.channel.vols = Rage;
    end
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
    save(fullfile(CodeDir,strcat(SubID,'_StructPpc.mat')),'matlabbatch');
    spm_jobman('run',matlabbatch);
    clear matlabbatch
    %
    %%
elseif length(Rage)==1 && length(T2)==0
    matlabbatch{1}.spm.spatial.coreg.estimate.ref = {'/media/jm3080/Naider/RDOC/code/MNI152_T1_1mm_brain.nii,1'};
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
    matlabbatch{2}.spm.spatial.preproc.tissue(1).tpm = {'/home/jm3080/Documents/MATLAB/spm12/tpm/TPM.nii,1'};
    matlabbatch{2}.spm.spatial.preproc.tissue(1).ngaus = 2;
    matlabbatch{2}.spm.spatial.preproc.tissue(1).native = [1 1];
    matlabbatch{2}.spm.spatial.preproc.tissue(1).warped = [1 1];
    matlabbatch{2}.spm.spatial.preproc.tissue(2).tpm = {'/home/jm3080/Documents/MATLAB/spm12/tpm/TPM.nii,2'};
    matlabbatch{2}.spm.spatial.preproc.tissue(2).ngaus = 2;
    matlabbatch{2}.spm.spatial.preproc.tissue(2).native = [1 1];
    matlabbatch{2}.spm.spatial.preproc.tissue(2).warped = [1 1];
    matlabbatch{2}.spm.spatial.preproc.tissue(3).tpm = {'/home/jm3080/Documents/MATLAB/spm12/tpm/TPM.nii,3'};
    matlabbatch{2}.spm.spatial.preproc.tissue(3).ngaus = 2;
    matlabbatch{2}.spm.spatial.preproc.tissue(3).native = [1 1];
    matlabbatch{2}.spm.spatial.preproc.tissue(3).warped = [1 1];
    matlabbatch{2}.spm.spatial.preproc.tissue(4).tpm = {'/home/jm3080/Documents/MATLAB/spm12/tpm/TPM.nii,4'};
    matlabbatch{2}.spm.spatial.preproc.tissue(4).ngaus = 3;
    matlabbatch{2}.spm.spatial.preproc.tissue(4).native = [0 0];
    matlabbatch{2}.spm.spatial.preproc.tissue(4).warped = [0 0];
    matlabbatch{2}.spm.spatial.preproc.tissue(5).tpm = {'/home/jm3080/Documents/MATLAB/spm12/tpm/TPM.nii,5'};
    matlabbatch{2}.spm.spatial.preproc.tissue(5).ngaus = 4;
    matlabbatch{2}.spm.spatial.preproc.tissue(5).native = [0 0];
    matlabbatch{2}.spm.spatial.preproc.tissue(5).warped = [0 0];
    matlabbatch{2}.spm.spatial.preproc.tissue(6).tpm = {'/home/jm3080/Documents/MATLAB/spm12/tpm/TPM.nii,6'};
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
    save(fullfile(CodeDir,strcat(SubID,'_StructPpc.mat')),'matlabbatch');
    spm_jobman('run',matlabbatch);
    clear matlabbatch
end
%
%% Process functionals part1:
% slice time, make vdms, realign & unwarp
%
% First, create a structure for each functional scan.

for f = 1:length(Funcs)
    CurFDirs=dir(fullfile(SubP,strcat(Funcs{1,f},'*')));
    if length(CurFDirs)==2
        Files1=findfiles(fullfile(SubP,CurFDirs(1).name),strcat(SubID,'_',CurFDirs(1).name(1:length(CurFDirs(1).name)-1),'*.nii'));
        Files2=findfiles(fullfile(SubP,CurFDirs(2).name),strcat(SubID,'_',CurFDirs(2).name(1:length(CurFDirs(2).name)-1),'*.nii'));
        Fmap0_1=findfiles(fullfile(SubP,CurFDirs(1).name),strcat(SubID,'_gre_field_mapping.nii'));
        Fmap1_1=findfiles(fullfile(SubP,CurFDirs(1).name),strcat(SubID,'_gre_field_mapping_01.nii'));
        Fmap0_2=findfiles(fullfile(SubP,CurFDirs(2).name),strcat(SubID,'_gre_field_mapping.nii'));
        Fmap1_2=findfiles(fullfile(SubP,CurFDirs(2).name),strcat(SubID,'_gre_field_mapping_01.nii'));
        First1=findfiles(fullfile(SubP,CurFDirs(1).name),strcat(SubID,'_',CurFDirs(1).name(1:length(CurFDirs(1).name)-1),'*0001.nii'));
        First2=findfiles(fullfile(SubP,CurFDirs(2).name),strcat(SubID,'_',CurFDirs(2).name(1:length(CurFDirs(2).name)-1),'*0001.nii'));
        % Make Batch
        matlabbatch{1}.spm.temporal.st.scans = {Files1; Files2};
        matlabbatch{1}.spm.temporal.st.nslices = 38;
        matlabbatch{1}.spm.temporal.st.tr = 2;
        matlabbatch{1}.spm.temporal.st.ta = 1.947368421;
        matlabbatch{1}.spm.temporal.st.so = [1004.99999998 0 1057.5 54.99999999 1109.99999999 107.49999998 1162.49999998 160 1215 212.49999999 1269.99999999 264.99999998 1322.49999998 317.49999998 1375 370 1427.49999999 422.49999999 1479.99999998 477.49999998 1532.5 530 1584.99999999 582.49999999 1639.99999998 634.99999998 1692.49999998 687.5 1745 739.99999999 1797.49999999 792.49999998 1849.99999998 847.5 1902.5 899.99999999 1954.99999999 952.49999998];
        matlabbatch{1}.spm.temporal.st.refslice = 265;
        matlabbatch{1}.spm.temporal.st.prefix = 'a';
        matlabbatch{2}.spm.tools.fieldmap.calculatevdm.subj(1).data.presubphasemag.phase = Fmap0_1;
        matlabbatch{2}.spm.tools.fieldmap.calculatevdm.subj(1).data.presubphasemag.magnitude = Fmap1_1;
        matlabbatch{2}.spm.tools.fieldmap.calculatevdm.subj(1).defaults.defaultsfile = {'/home/jm3080/Documents/MATLAB/spm12/toolbox/FieldMap/pm_defaults_jsm.m'};
        matlabbatch{2}.spm.tools.fieldmap.calculatevdm.subj(1).session.epi = First1;
        matlabbatch{2}.spm.tools.fieldmap.calculatevdm.subj(1).matchvdm = 1;
        matlabbatch{2}.spm.tools.fieldmap.calculatevdm.subj(1).sessname = CurFDirs(1).name;
        matlabbatch{2}.spm.tools.fieldmap.calculatevdm.subj(1).writeunwarped = 0;
        matlabbatch{2}.spm.tools.fieldmap.calculatevdm.subj(1).anat = '';
        matlabbatch{2}.spm.tools.fieldmap.calculatevdm.subj(1).matchanat = 0;
        matlabbatch{2}.spm.tools.fieldmap.calculatevdm.subj(2).data.presubphasemag.phase = Fmap0_2;
        matlabbatch{2}.spm.tools.fieldmap.calculatevdm.subj(2).data.presubphasemag.magnitude = Fmap1_2;
        matlabbatch{2}.spm.tools.fieldmap.calculatevdm.subj(2).defaults.defaultsfile = {'/home/jm3080/Documents/MATLAB/spm12/toolbox/FieldMap/pm_defaults_jsm.m'};
        matlabbatch{2}.spm.tools.fieldmap.calculatevdm.subj(2).session.epi = First2;
        matlabbatch{2}.spm.tools.fieldmap.calculatevdm.subj(2).matchvdm = 1;
        matlabbatch{2}.spm.tools.fieldmap.calculatevdm.subj(2).sessname = CurFDirs(1).name;
        matlabbatch{2}.spm.tools.fieldmap.calculatevdm.subj(2).writeunwarped = 0;
        matlabbatch{2}.spm.tools.fieldmap.calculatevdm.subj(2).anat = '';
        matlabbatch{2}.spm.tools.fieldmap.calculatevdm.subj(2).matchanat = 0;
        matlabbatch{3}.spm.spatial.realignunwarp.data(1).scans(1) = cfg_dep('Slice Timing: Slice Timing Corr. Images (Sess 1)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{1}, '.','files'));
        matlabbatch{3}.spm.spatial.realignunwarp.data(1).pmscan(1) = cfg_dep('Calculate VDM: Voxel displacement map (Subj 1, Session 1)', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{1}, '.','vdmfile', '{}',{1}));
        matlabbatch{3}.spm.spatial.realignunwarp.data(2).scans(1) = cfg_dep('Slice Timing: Slice Timing Corr. Images (Sess 2)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{2}, '.','files'));
        matlabbatch{3}.spm.spatial.realignunwarp.data(2).pmscan(1) = cfg_dep('Calculate VDM: Voxel displacement map (Subj 2, Session 1)', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{2}, '.','vdmfile', '{}',{1}));
        matlabbatch{3}.spm.spatial.realignunwarp.eoptions.quality = 1;
        matlabbatch{3}.spm.spatial.realignunwarp.eoptions.sep = 3;
        matlabbatch{3}.spm.spatial.realignunwarp.eoptions.fwhm = 5;
        matlabbatch{3}.spm.spatial.realignunwarp.eoptions.rtm = 1;
        matlabbatch{3}.spm.spatial.realignunwarp.eoptions.einterp = 4;
        matlabbatch{3}.spm.spatial.realignunwarp.eoptions.ewrap = [0 1 0];
        matlabbatch{3}.spm.spatial.realignunwarp.eoptions.weight = '';
        matlabbatch{3}.spm.spatial.realignunwarp.uweoptions.basfcn = [12 12];
        matlabbatch{3}.spm.spatial.realignunwarp.uweoptions.regorder = 1;
        matlabbatch{3}.spm.spatial.realignunwarp.uweoptions.lambda = 100000;
        matlabbatch{3}.spm.spatial.realignunwarp.uweoptions.jm = 0;
        matlabbatch{3}.spm.spatial.realignunwarp.uweoptions.fot = [4 5];
        matlabbatch{3}.spm.spatial.realignunwarp.uweoptions.sot = [];
        matlabbatch{3}.spm.spatial.realignunwarp.uweoptions.uwfwhm = 4;
        matlabbatch{3}.spm.spatial.realignunwarp.uweoptions.rem = 1;
        matlabbatch{3}.spm.spatial.realignunwarp.uweoptions.noi = 5;
        matlabbatch{3}.spm.spatial.realignunwarp.uweoptions.expround = 'Average';
        matlabbatch{3}.spm.spatial.realignunwarp.uwroptions.uwwhich = [2 1];
        matlabbatch{3}.spm.spatial.realignunwarp.uwroptions.rinterp = 4;
        matlabbatch{3}.spm.spatial.realignunwarp.uwroptions.wrap = [0 0 0];
        matlabbatch{3}.spm.spatial.realignunwarp.uwroptions.mask = 1;
        matlabbatch{3}.spm.spatial.realignunwarp.uwroptions.prefix = 'u';
        save(fullfile(CodeDir,strcat(SubID,'_Func1Ppc_',Funcs{1,f},'.mat')),'matlabbatch');
        spm_jobman('run',matlabbatch);
        clear matlabbatch
    elseif length(CurFDirs)==1
        Files1=findfiles(fullfile(SubP,CurFDirs(1).name),strcat(SubID,'_',CurFDirs(1).name,'*.nii'));
        Fmap0_1=findfiles(fullfile(SubP,CurFDirs(1).name),strcat(SubID,'_gre_field_mapping.nii'));
        Fmap1_1=findfiles(fullfile(SubP,CurFDirs(1).name),strcat(SubID,'_gre_field_mapping_01.nii'));
        First1=findfiles(fullfile(SubP,CurFDirs(1).name),strcat(SubID,'_',CurFDirs(1).name,'_0001.nii'));
        % Make Batch
        matlabbatch{1}.spm.temporal.st.scans = {Files1};
        matlabbatch{1}.spm.temporal.st.nslices = 38;
        matlabbatch{1}.spm.temporal.st.tr = 2;
        matlabbatch{1}.spm.temporal.st.ta = 1.947368421;
        matlabbatch{1}.spm.temporal.st.so = [1004.99999998 0 1057.5 54.99999999 1109.99999999 107.49999998 1162.49999998 160 1215 212.49999999 1269.99999999 264.99999998 1322.49999998 317.49999998 1375 370 1427.49999999 422.49999999 1479.99999998 477.49999998 1532.5 530 1584.99999999 582.49999999 1639.99999998 634.99999998 1692.49999998 687.5 1745 739.99999999 1797.49999999 792.49999998 1849.99999998 847.5 1902.5 899.99999999 1954.99999999 952.49999998];
        matlabbatch{1}.spm.temporal.st.refslice = 265;
        matlabbatch{1}.spm.temporal.st.prefix = 'a';
        matlabbatch{2}.spm.tools.fieldmap.calculatevdm.subj(1).data.presubphasemag.phase = Fmap0_1;
        matlabbatch{2}.spm.tools.fieldmap.calculatevdm.subj(1).data.presubphasemag.magnitude = Fmap1_1;
        matlabbatch{2}.spm.tools.fieldmap.calculatevdm.subj(1).defaults.defaultsfile = {'/home/jm3080/Documents/MATLAB/spm12/toolbox/FieldMap/pm_defaults_jsm.m'};
        matlabbatch{2}.spm.tools.fieldmap.calculatevdm.subj(1).session.epi = First1;
        matlabbatch{2}.spm.tools.fieldmap.calculatevdm.subj(1).matchvdm = 1;
        matlabbatch{2}.spm.tools.fieldmap.calculatevdm.subj(1).sessname = CurFDirs(1).name;
        matlabbatch{2}.spm.tools.fieldmap.calculatevdm.subj(1).writeunwarped = 0;
        matlabbatch{2}.spm.tools.fieldmap.calculatevdm.subj(1).anat = '';
        matlabbatch{2}.spm.tools.fieldmap.calculatevdm.subj(1).matchanat = 0;
        matlabbatch{3}.spm.spatial.realignunwarp.data.scans(1) = cfg_dep('Slice Timing: Slice Timing Corr. Images (Sess 1)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{1}, '.','files'));
        matlabbatch{3}.spm.spatial.realignunwarp.data.pmscan(1) = cfg_dep('Calculate VDM: Voxel displacement map (Subj 1, Session 1)', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{1}, '.','vdmfile', '{}',{1}));
        matlabbatch{3}.spm.spatial.realignunwarp.eoptions.quality = 1;
        matlabbatch{3}.spm.spatial.realignunwarp.eoptions.sep = 3;
        matlabbatch{3}.spm.spatial.realignunwarp.eoptions.fwhm = 5;
        matlabbatch{3}.spm.spatial.realignunwarp.eoptions.rtm = 1;
        matlabbatch{3}.spm.spatial.realignunwarp.eoptions.einterp = 4;
        matlabbatch{3}.spm.spatial.realignunwarp.eoptions.ewrap = [0 1 0];
        matlabbatch{3}.spm.spatial.realignunwarp.eoptions.weight = '';
        matlabbatch{3}.spm.spatial.realignunwarp.uweoptions.basfcn = [12 12];
        matlabbatch{3}.spm.spatial.realignunwarp.uweoptions.regorder = 1;
        matlabbatch{3}.spm.spatial.realignunwarp.uweoptions.lambda = 100000;
        matlabbatch{3}.spm.spatial.realignunwarp.uweoptions.jm = 0;
        matlabbatch{3}.spm.spatial.realignunwarp.uweoptions.fot = [4 5];
        matlabbatch{3}.spm.spatial.realignunwarp.uweoptions.sot = [];
        matlabbatch{3}.spm.spatial.realignunwarp.uweoptions.uwfwhm = 4;
        matlabbatch{3}.spm.spatial.realignunwarp.uweoptions.rem = 1;
        matlabbatch{3}.spm.spatial.realignunwarp.uweoptions.noi = 5;
        matlabbatch{3}.spm.spatial.realignunwarp.uweoptions.expround = 'Average';
        matlabbatch{3}.spm.spatial.realignunwarp.uwroptions.uwwhich = [2 1];
        matlabbatch{3}.spm.spatial.realignunwarp.uwroptions.rinterp = 4;
        matlabbatch{3}.spm.spatial.realignunwarp.uwroptions.wrap = [0 0 0];
        matlabbatch{3}.spm.spatial.realignunwarp.uwroptions.mask = 1;
        matlabbatch{3}.spm.spatial.realignunwarp.uwroptions.prefix = 'u';
        save(fullfile(CodeDir,strcat(SubID,'_Func1Ppc_',Funcs{1,f},'.mat')),'matlabbatch');
        spm_jobman('run',matlabbatch);
        clear matlabbatch
    end
end
end