%%% demo SCORES script
%% Grab data test
clear all
niak_gb_vars
path_data = [pwd filesep];
niak_wget('target_test_niak_mnc1'); % download demo data set
path_demo = [path_data 'target_test_niak_mnc1-' gb_niak_target_test ];

%% Get the cambridge templates
template.path = [path_demo '/demoniak_preproc/anat/template_cambridge_basc_multiscale_mnc_sym' ];
template.type =  'cambridge_template_mnc';
niak_wget(template);

%% Select a specific scale and template
scale = 7 ; % select a scale
template_data = [path_data 'template_cambridge_basc_multiscale_mnc_asym'];
template_name = sprintf('template_cambridge_basc_multiscale_sym_scale%03d.mnc.gz',scale);
system([' cp -r ' template.path filesep template_name ' ' path_demo '/demoniak_preproc/anat/']);

%% Grab the results from the NIAK fMRI preprocessing pipeline
opt_g.min_nb_vol = 10; % the demo dataset is very short, so we have to lower considerably the minimum acceptable number of volumes per run
opt_g.type_files = 'scores'; % Specify to the grabber to prepare the files for the stability FIR pipeline
files_in = niak_grab_fmri_preprocess([ path_demo '/demoniak_preproc/' ],opt_g);

%% Set pipeline options
opt.folder_out = [path_data 'demo_scores/']; % Where to store the results
opt.flag_vol = true;

%% Generate the pipeline
[pipeline, opt_scores] = niak_pipeline_scores(files_in,opt);
