%% demo BASC script for regular grid of resolutions

clear all
niak_gb_vars
path_data = [pwd filesep];

niak_wget('target_test_niak_mnc1'); % download demo data set


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Setting input/output files %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

files_in = niak_grab_region_growing([path_data 'target_test_niak_mnc1-' gb_niak_target_test '/demoniak_region_growing']);
%files_in.infos = [path_data 'model_group.csv']; % A file of comma-separeted values describing additional information on the subjects, this can be omitted
%files_in.atoms = [path_data 'region_growing/rois/brain_rois.mnc.gz'];

%%%%%%%%%%%%%
%% Options %%
%%%%%%%%%%%%% 

opt.folder_out = [path_data 'basc/']; % Where to store the results
opt.grid_scales = 5:5:30; % Search for stable clusters in the range 5 to 30
% opt.scales_maps = repmat(opt.grid_scales,[1 3]); % The scales that will be used to generate the maps of brain clusters and stability. 
%                                                  % In this example the same number of clusters are used at the individual (first column), 
%                                                  % group (second column) and consensus (third and last colum) levels.
opt.scales_maps = [5 5 5;...
10 10 10;...
15 15 15;...
20 20 20;...
25 25 25;...
30 30 30];

opt.stability_tseries.nb_samps = 100; % Number of bootstrap samples at the individual level. 100: the CI on indidividual stability is +/-0.1
opt.stability_group.nb_samps = 1000; % Number of bootstrap samples at the group level. 500: the CI on group stability is +/-0.05

opt.flag_ind = false;   % Generate maps/time series at the individual level
opt.flag_mixed = false; % Generate maps/time series at the mixed level (group-level networks mixed with individual stability matrices).
opt.flag_group = true;  % Generate maps/time series at the group level

%%%%%%%%%%%%%%%%%%%%%%
%% Run the pipeline %%
%%%%%%%%%%%%%%%%%%%%%%  
opt.flag_test = false; % Put this flag to true to just generate the pipeline without running it. Otherwise the region growing will start. 
%opt.psom.qsub_options= '-A gsf-624-aa -q sw -l nodes=1:ppn=2 -l walltime=30:00:00';
%opt.psom.max_queued = 10; % Uncomment and change this parameter to set the number of parallel threads used to run the pipeline
pipeline = niak_pipeline_stability_rest(files_in,opt); 
