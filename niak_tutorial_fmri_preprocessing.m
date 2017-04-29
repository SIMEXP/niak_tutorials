
clear
niak_wget('data_test_niak_nii');

path_data = [pwd filesep];
% Structural scan subject 1
files_in.subject1.anat = ...
    [path_data 'data_test_niak_nii/anat_subject1.nii.gz'];       
% fMRI run 1 subject 1
files_in.subject1.fmri.session1.motor = ...
    [path_data 'data_test_niak_nii/func_motor_subject1.nii.gz'];
% Structural scan subject 2
files_in.subject2.anat = ...
    [path_data 'data_test_niak_nii/anat_subject2.nii.gz'];       
% fMRI run 1 subject 2
files_in.subject2.fmri.session1.motor = ...
    [path_data 'data_test_niak_nii/func_motor_subject2.nii.gz'];

% Where to store the results
opt.folder_out  = [path_data 'fmri_preprocess/'];

% Use up to 2 threads
opt.psom.max_queued = 2;

opt.slice_timing.type_acquisition = 'interleaved ascending'; 
opt.slice_timing.type_scanner     = 'Bruker';                
opt.slice_timing.delay_in_tr      = 0;

% Center the functional volumes on the brain center-of-mass (true/false)
opt.slice_timing.flag_center = false;
% Suppress some volumes at the beginning of the run
opt.slice_timing.suppress_vol = 3;

% The voxel size to use in the stereotaxic space
opt.resample_vol.voxel_size    = 10;

% Parameter for non-uniformity correction. 
% 200 is a suggested value for 1.5T images, 
% 75 for 3T images. 
opt.t1_preprocess.nu_correct.arg = '-distance 75';

% Cut-off frequency for high-pass filtering, 
% or removal of low frequencies (in Hz). 
opt.time_filter.hp = 0.01; 
% Cut-off frequency for low-pass filtering, 
% or removal of high frequencies (in Hz). 
opt.time_filter.lp = 0.1;
% Remove slow time drifts (true/false)
opt.regress_confounds.flag_slow = true;
% Remove high frequencies (true/false)
opt.regress_confounds.flag_high = false;
% Apply regression of motion parameters (true/false)
opt.regress_confounds.flag_motion_params = true;
% Reduce the dimensionality of motion parameters with PCA (true/false)
opt.regress_confounds.flag_pca_motion = true;
% How much variance of motion parameters (with squares) to retain
opt.regress_confounds.pct_var_explained = 0.95;
% Apply average white matter signal regression (true/false)         
opt.regress_confounds.flag_wm = true;
% Apply average ventricle signal regression (true/false)         
opt.regress_confounds.flag_vent = true;
% Apply anat COMPCOR (white matter+ventricles, true/false)
% We recommend not using FLAG_WM and FLAG_VENT together with FLAG_COMPCOR
opt.regress_confounds.flag_compcor = false;
% Apply global signal regression (true/false)         
opt.regress_confounds.flag_gsc = true; 
% Apply scrubbing (true/false)
opt.regress_confounds.flag_scrubbing = true;     
% The threshold on frame displacement for scrubbing 
opt.regress_confounds.thre_fd = 0.5;    

% Full-width at maximum (FWHM) of the Gaussian blurring kernel, in mm.
opt.smooth_vol.fwhm      = 6;

niak_pipeline_fmri_preprocess(files_in,opt);
% Check the content of fmri_preprocess/logs/PIPE_history.txt to monitor the progress of the pipeline
