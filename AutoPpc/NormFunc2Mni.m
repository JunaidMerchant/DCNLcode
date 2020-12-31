%-----------------------------------------------------------------------
% Job saved on 17-Aug-2016 02:00:57 by cfg_util (rev $Rev: 6134 $)
% spm SPM - SPM12 (6225)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
JobDir=fullfile(SubP,'/jobsnlogs');
% Define functional files
Funcs=findfiles(fullfile(SubP,'/ppc/',strcat(Func,'*')),'b_u_*.nii');
FlowField={fullfile(SubP,'ppc/struct/u_rc1b_mprage_DartelTemplateChives.nii')};
DartelTemplate={'/home/research/sanlab/Studies/CHIVES/dartel/DartelTemplateChives_6.nii'};

matlabbatch{1}.spm.tools.dartel.mni_norm.template = DartelTemplate;
matlabbatch{1}.spm.tools.dartel.mni_norm.data.subj.flowfield = FlowField;
%%
matlabbatch{1}.spm.tools.dartel.mni_norm.data.subj.images = Funcs;
%%
matlabbatch{1}.spm.tools.dartel.mni_norm.vox = [2 2 2];
matlabbatch{1}.spm.tools.dartel.mni_norm.bb = [-90 -126 -72
                                               90 90 108];
matlabbatch{1}.spm.tools.dartel.mni_norm.preserve = 0;
matlabbatch{1}.spm.tools.dartel.mni_norm.fwhm = [4 4 4];
save(strcat(JobDir,'/',CurSub,'_Norm2MNI_',Func,'.mat'),'matlabbatch');
