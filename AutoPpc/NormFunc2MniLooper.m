addpath('/vxfsvol/home/research/sanlab/matlab/NeuroElf_v09c');
SubDir='/vxfsvol/home/research/sanlab/Studies/CHIVES/subjects';
cd(SubDir);
Subs=dir('CH*');
% subsToProcess = [55,57,76,85];
subsToProcess = [84];
DartelTemplate='/vxfsvol/home/research/sanlab/Studies/CHIVES/dartel/DartelTemplate_92s_6.nii';
for s=1:length(Subs)
    sub=Subs(s).name;
    str2num(sub(end-2:end))
    if find(subsToProcess==str2num(sub(end-2:end)))
        str2num(sub(end-2:end))
        Funcs=findfiles(fullfile(SubDir,sub,'/ppc/picture2'),'b_u_*.nii');
        FlowField=fullfile(SubDir, sub,'ppc/struct/u_rc1b_mprage_DartelTemplate_92s.nii');
        if (length(Funcs)>100)&(length(FlowField)>100)
            JobDir=fullfile(SubDir,sub,'jobsnlogs');
            matlabbatch{1}.spm.tools.dartel.mni_norm.template = {DartelTemplate};
            matlabbatch{1}.spm.tools.dartel.mni_norm.data.subj.flowfield = {FlowField};
            %%
            matlabbatch{1}.spm.tools.dartel.mni_norm.data.subj.images = Funcs;
            %%
            matlabbatch{1}.spm.tools.dartel.mni_norm.vox = [2 2 2];
            matlabbatch{1}.spm.tools.dartel.mni_norm.bb = [-90 -126 -72
                90 90 108];
            matlabbatch{1}.spm.tools.dartel.mni_norm.preserve = 0;
            matlabbatch{1}.spm.tools.dartel.mni_norm.fwhm = [4 4 4];
            save(strcat(JobDir,'/',sub,'_NormFunc2MNI.mat'),'matlabbatch');
        end
    end
end