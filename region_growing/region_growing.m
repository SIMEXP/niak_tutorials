%%% demo REGION GROWING script

clear all
niak_gb_vars
path_data = [pwd filesep];

niak_wget('target_test_niak_mnc1'); % download demo data set 

%%%%%%%%%%%%%%%%%%%%%
%% Grabbing the results from the NIAK fMRI preprocessing pipeline
%%%%%%%%%%%%%%%%%%%%%
opt_g.min_nb_vol = 20;     % The minimum number of volumes for an fMRI dataset to be included. This option is useful when scrubbing is used, and the resulting time series may be too short.
opt_g.min_xcorr_func = 0; % The minimum xcorr score for an fMRI dataset to be included. This metric is a tool for quality control which assess the quality of non-linear coregistration of functional images in stereotaxic space. Manual inspection of the values during QC is necessary to properly set this threshold.
opt_g.min_xcorr_anat = 0; % The minimum xcorr score for an fMRI dataset to be included. This metric is a tool for quality control which assess the quality of non-linear coregistration of the anatomical image in stereotaxic space. Manual inspection of the values during QC is necessary to properly set this threshold.
opt_g.type_files = 'roi'; % Specify to the grabber to prepare the files for the glm_connectome pipeline
files_in = niak_grab_fmri_preprocess([path_data 'target_test_niak_mnc1-' gb_niak_target_test '/demoniak_preproc/'],opt_g); % Replace the folder by the path where the results of the fMRI preprocessing pipeline were stored. 

%%%%%%%%%%%%%
%% Options %%
%%%%%%%%%%%%%
opt.folder_out = [path_data 'region_growing/']; % Where to store the results
opt.flag_roi = true; % Only generate the ROI parcelation
opt.region_growing.thre_size = 1000; % The critical size for regions

%% Run the pipeline
opt.flag_test = false;
[pipeline_rg,opt] = niak_pipeline_stability_rest(files_in,opt);
