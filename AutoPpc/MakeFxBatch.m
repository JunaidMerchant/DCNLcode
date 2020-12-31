function MakeFxBatch(SpmDir, SubID, SubP, CodeDir, FxBatchDir, BxDir, FxDir, MotionDir, Func)
% Script to take the subject ID and make first-level models for all the
% task functionals available
%
%% Set up all the variables based on the input of subject ID.
addpath(SpmDir);
addpath(CodeDir);
spm_jobman('initcfg');


if strcmp(Func,'SocStroop')
    f=2;
elseif strcmp(Func,'NBack')
    f=1;
elseif strcmp(Func,'StopSignal')
    f=3;
end
%


% Should change this hard-coded path
run('/media/jm3080/Naider/RDOC/code/AutoPpc/Contrasts.m');


%
CurFDirs=dir(fullfile(SubP,strcat(Func,'*')));
Vec=findfiles(fullfile(BxDir,Func),strcat('*',SubID(6:13),'*.mat'));
Rp=findfiles(fullfile(MotionDir,Func),strcat('rp*',SubID,'*.txt.mat'));


if length(CurFDirs)==1 && length(Vec)==1 && length(Rp)==1
    %
    Files=findfiles(fullfile(SubP,CurFDirs(1).name),'swb_uaD*');
    
    
    %
    CurFxSubDir=fullfile(FxDir,Func,SubID);
    if isempty(dir(CurFxSubDir))
        mkdir(CurFxSubDir);
    else
        rmdir(CurFxSubDir)
        mkdir(CurFxSubDir);
    end
    
    %
    matlabbatch{1}.spm.stats.fmri_spec.dir = {CurFxSubDir};
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 38;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 12;
    %
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).scans = Files;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi = Vec(1,1);
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi_reg = Rp(1,1);
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).hpf = 128;
    matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
    matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
    matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
    matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
    matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
    matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
    matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
    matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
    matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    for c = 1:length(Contrast(f).Name)
        matlabbatch{3}.spm.stats.con.consess{c}.tcon.name = Contrast(f).Name{c,1};
        matlabbatch{3}.spm.stats.con.consess{c}.tcon.weights = Contrast(f).Vector(c,:);
        matlabbatch{3}.spm.stats.con.consess{c}.tcon.sessrep = 'replsc';
    end
    
    
    %
    
    save(fullfile(FxBatchDir,strcat(SubID,'_',Func,'_Fx.mat')),'matlabbatch');
    spm_jobman('run',matlabbatch);
    clear matlabbatch
    %%
    %
    
    
    
elseif length(CurFDirs)==2 && length(Vec)==2 && length(Rp)==2
    
    CurFxSubDir=fullfile(FxDir,Func,SubID);
    if isempty(dir(CurFxSubDir))
        mkdir(CurFxSubDir);
    end
    Files1=findfiles(fullfile(SubP,CurFDirs(1).name),'swb_uaD*');
    
    Files2=findfiles(fullfile(SubP,CurFDirs(2).name),'swb_uaD*');
    
    
    
    %
    %
    %
    matlabbatch{1}.spm.stats.fmri_spec.dir = {CurFxSubDir};
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 38;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 12;
    %%
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).scans = Files1;
    %%
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi = Vec(1,1);
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi_reg = Rp(1,1);
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).hpf = 128;
    %%
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).scans = Files2;
    %%
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).multi = Vec(2,1);
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).multi_reg = Rp(2,1);
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).hpf = 128;
    matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
    matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
    matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
    matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
    matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
    matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
    matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
    matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
    matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    for c = 1:length(Contrast(f).Name)
        matlabbatch{3}.spm.stats.con.consess{c}.tcon.name = Contrast(f).Name{c,1};
        matlabbatch{3}.spm.stats.con.consess{c}.tcon.weights = Contrast(f).Vector(c,:);
        matlabbatch{3}.spm.stats.con.consess{c}.tcon.sessrep = 'replsc';
    end
    save(fullfile(FxBatchDir,strcat(SubID,'_',Func,'_Fx.mat')),'matlabbatch');
    spm_jobman('run',matlabbatch);
end
clear matlabbatch
end
