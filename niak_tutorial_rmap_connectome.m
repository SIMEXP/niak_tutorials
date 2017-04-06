
clear
path_data = [pwd filesep];
[status,msg,data_fmri] = niak_wget('cobre_lightweight20_nii');

file_pheno = [data_fmri.path filesep 'phenotypic_data.tsv.gz'];
tab = niak_read_csv_cell(file_pheno);
list_subject = tab(2:end,1);
files_in = struct;
for ss = 1:length(list_subject)
    files_in.fmri.(list_subject{ss}).sess1.rest = [data_fmri.path filesep 'fmri_' list_subject{ss} '.nii.gz'];
end

[status,msg,data_template] = niak_wget('cambridge_template_mnc1');

files_in.network = [data_template.path filesep 'template_cambridge_basc_multiscale_sym_scale007.mnc.gz'];

files_in.seeds = [path_data 'list_seeds.csv'];
opt_csv.labels_x = { 'MOTOR' , 'DMN' }; % The labels for the network
opt_csv.labels_y = { 'index' };
tab = [3 ; 5];
niak_write_csv(files_in.seeds,tab,opt_csv);

opt.folder_out = [path_data 'connectome'];

opt.flag_p2p = false; % No parcel-to-parcel correlation values
opt.flag_global_prop = false; % No global graph properties
opt.flag_local_prop  = false; % No local graph properties
opt.flag_rmap = true; % Generate correlation maps

opt.flag_test = false; 
[pipeline,opt] = niak_pipeline_connectome(files_in,opt); 

file_dmn   = [opt.folder_out filesep 'rmap_seeds' filesep 'average_rmap_DMN.nii.gz'];
file_motor = [opt.folder_out filesep 'rmap_seeds' filesep 'average_rmap_MOTOR.nii.gz'];
[hdr,rmap_dmn]   = niak_read_vol(file_dmn);
[hdr,rmap_motor] = niak_read_vol(file_motor);
size(rmap_dmn)
size(rmap_motor)

% The default-mode network
opt_v = struct;
opt_v.vol_limits = [0.25 0.7];
opt_v.type_color = 'hot_cold';
niak_montage(rmap_dmn,opt_v)

% The sensorimotor network
opt_v = struct;
opt_v.vol_limits = [0.25 0.7];
opt_v.type_color = 'hot_cold';
niak_montage(rmap_motor,opt_v)

file_mask_dmn   = [opt.folder_out filesep 'rmap_seeds' filesep 'mask_DMN.nii.gz'];
[hdr,mask_dmn]   = niak_read_vol(file_mask_dmn);
opt_v = struct;
opt_v.vol_limits = [0 1];
opt_v.type_color = 'hot_cold';
niak_montage(mask_dmn,opt_v)

file_dmn_40003   = [opt.folder_out filesep 'rmap_seeds' filesep 'rmap_40003_DMN.nii.gz'];
[hdr,rmap_dmn_40003]   = niak_read_vol(file_dmn_40003);
opt_v = struct;
opt_v.vol_limits = [0.4 1];
opt_v.type_color = 'hot_cold';
niak_montage(rmap_dmn_40003,opt_v)
