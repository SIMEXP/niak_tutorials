
clear
path_data = [pwd filesep];
[status,msg,data_fmri] = niak_wget('single_subject_cambridge_preprocessed_nii');

files_in = struct;
files_in.fmri.subject1.sess1.rest = [data_fmri.path filesep 'fmri_sub00156_session1_rest.nii.gz'];

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

file_dmn   = [opt.folder_out filesep 'rmap_seeds' filesep 'rmap_subject1_DMN.nii.gz'];
file_motor = [opt.folder_out filesep 'rmap_seeds' filesep 'rmap_subject1_MOTOR.nii.gz'];
[hdr,rmap_dmn]   = niak_read_vol(file_dmn);
[hdr,rmap_motor] = niak_read_vol(file_motor);
size(rmap_dmn)
size(rmap_motor)

% The default-mode network
coord = linspace(-20,40,10)';
coord = repmat(coord,[1 3]);
opt_v = struct;
opt_v.type_view = 'axial';
img_dmn = niak_vol2img(hdr,rmap_dmn,coord,opt_v);
imshow(img_dmn,[0,1])

% The sensorimotor network
img_motor = niak_vol2img(hdr,rmap_motor,coord,opt_v);
imshow(img_motor,[0,1])

file_mask_dmn   = [opt.folder_out filesep 'rmap_seeds' filesep 'mask_DMN.nii.gz'];
[hdr,mask_dmn]   = niak_read_vol(file_mask_dmn);
img_mask_dmn = niak_vol2img(hdr,mask_dmn,coord,opt_v);
imshow(img_mask_dmn,[0,1])
