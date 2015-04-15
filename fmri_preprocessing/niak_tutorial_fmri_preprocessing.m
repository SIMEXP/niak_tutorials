
%% Fetch a lightweight dataset
clear
niak_gb_vars
niak_wget('data_test_niak_mnc1');

%% Setting input/output files

% All data locations are relative to the current folder
path_data = [pwd filesep];
% Structural scan
files_in.subject1.anat                = [path_data 'data_test_niak_mnc1/anat_subject1.mnc.gz'];       
% fMRI run 1
files_in.subject1.fmri.session1.motor = [path_data 'data_test_niak_mnc1/func_motor_subject1.mnc.gz']; 

%% Pipeline options

% Where to store the results
opt.folder_out  = [path_data 'fmri_preprocess/'];    

%% Pipeline manager 
% See http://psom.simexp-lab.org/psom_configuration.html for more details on PSOM configuration
% Use up to four threads
opt.psom.max_queued = 4;       

%% Slice timing correction (niak_brick_slice_timing)
opt.slice_timing.type_acquisition = 'interleaved ascending'; 
opt.slice_timing.type_scanner     = 'Bruker';                
opt.slice_timing.delay_in_tr      = 0;                       
 
%% resampling in stereotaxic space
% The voxel size to use in the stereotaxic space
opt.resample_vol.voxel_size    = 10;

%% Linear and non-linear fit of the anatomical image in the stereotaxic
% space (niak_brick_t1_preprocess)
% Parameter for non-uniformity correction. 200 is a suggested value for 1.5T images, 75 for 3T images. 
opt.t1_preprocess.nu_correct.arg = '-distance 75'; 

%% Temporal filtering (niak_brick_time_filter)
% Cut-off frequency for high-pass filtering, or removal of low frequencies (in Hz). 
% A cut-off of -Inf will result in no high-pass filtering.
opt.time_filter.hp = 0.01; 
% Cut-off frequency for low-pass filtering, or removal of high frequencies (in Hz). 
% A cut-off of Inf will result in no low-pass filtering.
opt.time_filter.lp = Inf;  

%% Regression of confounds and scrubbing (niak_brick_regress_confounds)
% Apply global signal regression          
opt.regress_confounds.flag_gsc = true; 
opt.regress_confounds.flag_scrubbing = true;     
% The threshold on frame displacement for scrubbing 
opt.regress_confounds.thre_fd = 0.5;             

%% Spatial smoothing (niak_brick_smooth_vol)
% Full-width at maximum (FWHM) of the Gaussian blurring kernel, in mm.
opt.smooth_vol.fwhm      = 6;  

%% Run the fmri_preprocess pipeline 
niak_pipeline_fmri_preprocess(files_in,opt);