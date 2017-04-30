
% Where to find data
clear
path_data = [pwd filesep];
path_preprocess = [path_data 'fmri_preprocess'];

% That option tells the grabber to prepare files for BASC
opt_g.type_files = 'rest'; 

% Minimum number of volumes per run - typically aim at 2 mns
% Shorther here because the test dataset is really small
opt_g.min_nb_vol = 20;

% Grab the "motor" run
opt_g.filter.run = {'motor'}; % Just grab the "motor" runs

% if uncommented, this option would exclude subject1
% opt_g.exclude_subject = {'subject1'};

% Grab the data
files_in = niak_grab_fmri_preprocess(path_preprocess,opt_g)

% Where to store the results
opt.folder_out = [path_data 'basc_test_niak'];

% the size of the regions, when they stop growing. 
opt.region_growing.thre_size = 2000; 

% Search for stable clusters in the range 10 to 30
opt.grid_scales = [10:10:30]'; 

% Scale parameters to generate stability maps and consensus clusters
opt.scales_maps = [];

% Number of bootstrap samples at the individual level.
opt.stability_tseries.nb_samps = 20;
% Number of bootstrap samples at the group level. 
opt.stability_group.nb_samps = 20; 

opt.stability_group.min_subject = 2;

% Generate maps/time series at the individual level
opt.flag_ind = false;   
% Generate maps/time series at the mixed level (group-level networks mixed with individual stability matrices).
opt.flag_mixed = false; 
% Generate maps/time series at the group level
opt.flag_group = true;  

niak_pipeline_stability_rest(files_in,opt);

file_msteps = [opt.folder_out filesep 'stability_group' filesep 'msteps_group_table.csv'];
[tab,lx,ly] = niak_read_csv(file_msteps);
tab

opt.scales_maps = tab;

niak_pipeline_stability_rest(files_in,opt);

path_sc8 = [opt.folder_out filesep 'stability_group' filesep 'sci10_scg7_scf8' filesep];
parcel_sc8 =  [path_sc8 'brain_partition_consensus_group_sci10_scg7_scf8.nii.gz'];
[hdr,sc8] = niak_read_vol(parcel_sc8);
niak_montage(sc8)
