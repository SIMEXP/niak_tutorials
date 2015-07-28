%%% demo GLM CONNECTOME SCRIPT 

clear all
niak_gb_vars
path_data = [pwd filesep];

niak_wget('target_test_niak_mnc1'); % download demo data set

%%%%%%%%%%%%
%% Grabbing the results from BASC
%%%%%%%%%%%%
files_in = niak_grab_stability_rest([path_data 'target_test_niak_mnc1-' gb_niak_target_test '/demoniak_stability_rest/']); 

%%%%%%%%%%%%%%%%%%%%%
%% Grabbing the results from the NIAK fMRI preprocessing pipeline
%%%%%%%%%%%%%%%%%%%%%
opt_g.min_nb_vol = 20;     % The minimum number of volumes for an fMRI dataset to be included. This option is useful when scrubbing is used, and the resulting time series may be too short.
opt_g.min_xcorr_func = 0; % The minimum xcorr score for an fMRI dataset to be included. This metric is a tool for quality control which assess the quality of non-linear coregistration of functional images in stereotaxic space. Manual inspection of the values during QC is necessary to properly set this threshold.
opt_g.min_xcorr_anat = 0; % The minimum xcorr score for an fMRI dataset to be included. This metric is a tool for quality control which assess the quality of non-linear coregistration of the anatomical image in stereotaxic space. Manual inspection of the values during QC is necessary to properly set this threshold.
opt_g.type_files = 'glm_connectome'; % Specify to the grabber to prepare the files for the glm_connectome pipeline
opt_g.filter.session = {'session1'}; % Just grab session 1
files_in.fmri = niak_grab_fmri_preprocess([path_data 'target_test_niak_mnc1-' gb_niak_target_test '/demoniak_preproc/'],opt_g).fmri; % Replace the folder by the path where the results of the fMRI preprocessing pipeline were stored. 


%%%%%%%%%%%%
%% Set the model
%%%%%%%%%%%%

%% Group
files_in.model.group = [path_data 'target_test_niak_mnc1-' gb_niak_target_test '/glm_connectome_unit/data/group.csv'];

%%%%%%%%%%%%
%% Options 
%%%%%%%%%%%%
opt.folder_out = [path_data 'glm_connectome']; % Where to store the results
opt.fdr = 0.1; % The maximal false-discovery rate that is tolerated both for individual (single-seed) maps and whole-connectome discoveries, at each particular scale (multiple comparisons across scales are addressed via permutation testing)
opt.fwe = 0.05; % The overall family-wise error, i.e. the probablity to have the observed number of discoveries, agregated across all scales, under the global null hypothesis of no association.
opt.nb_samps = 1000; % The number of samples in the permutation test. This number has to be multiplied by OPT.NB_BATCH below to get the effective number of samples
opt.nb_batch = 10; % The permutation tests are separated into NB_BATCH independent batches, which can run on parallel if sufficient computational resources are available
opt.flag_rand = false; % if the flag is false, the pipeline is deterministic. Otherwise, the random number generator is initialized based on the clock for each job.


%%%%%%%%%%%%
%% Tests
%%%%%%%%%%%%

%% Group differences

%%% group 1 vs group 2

opt.test.onevstwo.group.contrast.group = 1; % define contrast of interest
opt.test.onevstwo.group.contrast.age = 0; % regress out confounding variable


%% Group averages

%%% group one average connectivity

opt.test.avg_one.group.contrast.intercept = 1; % define contrast of interest
opt.test.avg_one.group.contrast.age = 0; % regress out confounding variable 
opt.test.avg_one.group.select.label = 'group'; % select subset of subjects
opt.test.avg_one.group.select.values = 1; % criteria to select subset of subjects

%%% group two average connectivity
opt.test.avg_two.group.contrast.intercept = 1; % define contrast of interest
opt.test.avg_two.group.contrast.age = 0; % regress out confounding variable 
opt.test.avg_two.group.select.label = 'group'; % select subset of subjects
opt.test.avg_two.group.select.values = 2; % criteria to select subset of subjects


%%%%%%%%%%%%
%% Run the pipeline
%%%%%%%%%%%%
opt.flag_test = false; % Put this flag to true to just generate the pipeline without running it. Otherwise the region growing will start.
% opt.psom.max_queued = 10; % Uncomment and change this parameter to set the number of parallel threads used to run the pipeline
[pipeline,opt] = niak_pipeline_glm_connectome(files_in,opt);  
