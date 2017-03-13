clear

%% Download the single subject, preprocessed cambridge dataset
if ~psom_exist('single_subject_cambridge_preprocessed_nii')
    system('wget http://www.nitrc.org/frs/download.php/6784/single_subject_cambridge_preprocessed_nii.zip')
    system('unzip single_subject_cambridge_preprocessed_nii.zip')
    psom_clean('single_subject_cambridge_preprocessed_nii.zip')
end

% read the data
[hdr,vol] = niak_read_vol('single_subject_cambridge_preprocessed_nii/fmri_sub00156_session1_rest.nii.gz');

% this command visualizes the third volume, and set the min/max of the visualization
opt_v.vol_limits = [100 1200];
niak_montage(vol(:,:,:,3),opt_v)
print('fig_montage.png','-dpng')

% It is also possible to run a little movie
% here I selected only one slice
niak_visu_motion(vol(:,:,20,:),opt_v)

% It is possible to use regular matlab/octave commands to plot the activity
% not the use of squeeze to reshape data as vectors
plot(squeeze(vol(30,30,20,:)))
print('fig_plot.png','-dpng')