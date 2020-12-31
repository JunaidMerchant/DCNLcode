function MakePpcBatch2(SubID)
% This script creates and runs the entire preprocessing for a single
% subject.
%
%% Set up all the variables based on the input of subject ID.
spm_jobman('initcfg');
SubP=fullfile('/media/jm3080/Naider/RDOC/ppc/',SubID);
yRage=findfiles(SubP,'y*MPRAGE.nii');
bRage=findfiles(SubP,'b*MPRAGE.nii');
Funcs={'NBack' 'Resting' 'SocStroop' 'StopSignal'};
%Funcs={'NBack' 'Resting'};
CodeDir='/media/jm3080/Naider/RDOC/code/PpcBatches';
%
for f = 1:length(Funcs)
    CurFDirs=dir(fullfile(SubP,strcat(Funcs{1,f},'*')));
    if length(CurFDirs)>0
        Files=findfiles(fullfile(SubP),strcat('b_ua',SubID,'_',Funcs{1,f},'*.nii'));
        Mean=findfiles(fullfile(SubP),strcat('b_meanua',SubID,'_',Funcs{1,f},'*.nii'));
        %
        %
        matlabbatch{1}.spm.spatial.coreg.estimate.ref = bRage;
        matlabbatch{1}.spm.spatial.coreg.estimate.source = Mean;
        matlabbatch{1}.spm.spatial.coreg.estimate.other = Files;
        matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
        matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [8 4 2 1];
        matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
        matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
        %
        matlabbatch{2}.spm.spatial.normalise.write.subj.def = yRage;
        matlabbatch{2}.spm.spatial.normalise.write.subj.resample(1) = cfg_dep('Coregister: Estimate: Coregistered Images', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','cfiles'));
        matlabbatch{2}.spm.spatial.normalise.write.woptions.bb = [-90 -126  -72
            90   90  108];
        matlabbatch{2}.spm.spatial.normalise.write.woptions.vox = [3 3 3];
        matlabbatch{2}.spm.spatial.normalise.write.woptions.interp = 4;
        matlabbatch{2}.spm.spatial.normalise.write.woptions.prefix = 'w';
        %
        matlabbatch{3}.spm.spatial.smooth.data(1) = cfg_dep('Normalise: Write: Normalised Images (Subj 1)', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{1}, '.','files'));
        matlabbatch{3}.spm.spatial.smooth.fwhm = [6 6 6];
        matlabbatch{3}.spm.spatial.smooth.dtype = 0;
        matlabbatch{3}.spm.spatial.smooth.im = 0;
        matlabbatch{3}.spm.spatial.smooth.prefix = 's';
        save(fullfile(CodeDir,strcat(SubID,'_Func2Ppc_',Funcs{1,f},'.mat')),'matlabbatch');
        spm_jobman('run',matlabbatch);
        clear matlabbatch
    end
end