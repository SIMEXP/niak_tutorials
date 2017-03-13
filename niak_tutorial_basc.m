
clear
path_data = [pwd filesep];
[status,msg,data_fmri] = niak_wget('cobre_lightweight20_nii');

file_pheno = [data_fmri.path filesep 'phenotypic_data.tsv.gz'];
tab = niak_read_csv_cell(file_pheno);
list_subject = tab(2:end,1);
files_in = struct;
for ss = 1:5
    files_in.data.(list_subject{ss}).sess1.rest = [data_fmri.path filesep 'fmri_' list_subject{ss} '.nii.gz'];
end

%% Prepare the analysis mask
% load global niak variables
niak_gb_vars
% the AAL template in niak
in.source = [GB_NIAK.path_niak filesep 'template' filesep 'roi_aal_3mm.mnc.gz'];
% Use fMRI data from the first subject as target
in.target = files_in.data.(list_subject{1}).sess1.rest;
% Where to write the resampled mask 
out = [path_data 'roi_aal_cobre.nii.gz'];
% resample the data
niak_brick_resample_vol(in,out);

% Specify the mask of brain areas for the pipeline
files_in.areas = out;

% Where to store the results
opt.folder_out = [path_data 'basc'];

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
