clear

%% Download the single subject, preprocessed cambridge dataset
if ~psom_exist('single_subject_cambridge_preprocessed_nii')
    system('wget http://www.nitrc.org/frs/download.php/6784/single_subject_cambridge_preprocessed_nii.zip')
    system('unzip single_subject_cambridge_preprocessed_nii.zip')
    psom_clean('single_subject_cambridge_preprocessed_nii.zip')
end

%% Reading volumes

% To read the data, use niak_read_vol
[hdr,vol] = niak_read_vol('single_subject_cambridge_preprocessed_nii/fmri_sub00156_session1_rest.nii.gz');

% The hdr output is a structure with a full description of the volume
% hdr.info contains some basic info found in both nifti and minc
hdr.info

% For example, the voxel size is found in 
hdr.info.voxel_size

% All the detailed information are contained in hdr.details
% This field will vary based on the format of the original volume
% Here, for nifti, each field corresponds to a nifti field
hdr.details

% The vol output is the data itself, in either a 3D or a 4D array
% Any normalization (min/max) has been applied
% It is in voxel space however, and no spatial transformation has been applied
size(vol)

%% Visualization of volumes

% this command visualizes the third volume, and set the min/max of the visualization
opt_v.vol_limits = [100 1200];
niak_montage(vol(:,:,:,3),opt_v)
print('fig_montage.png','-dpng')

% It is also possible to run a little movie
% here I selected only one slice
niak_visu_motion