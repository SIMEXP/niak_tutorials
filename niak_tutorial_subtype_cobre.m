
cd
build_path niak psom
cd /home/pbellec/git/niak_tutorials/connectome

path_cobre = [pwd filesep 'cobre_lightweight20'];
file_pheno = [path_cobre filesep 'phenotypic_data.tsv.gz'];
tab = niak_read_csv_cell(file_pheno);

list_subject = tab(2:end,1);
patient = strcmp(tab(2:end,5),'Patient');
age = str2double(tab(2:end,2)); 
FD = str2double(tab(2:end,9));
opt_csv.labels_x = list_subject; % Labels for the rows
opt_csv.labels_y = { 'age' , 'patient' , 'fd' };
niak_write_csv('model_patient.csv', [age patient FD] , opt_csv);

files_in.model = [pwd filesep 'model_patient.csv'];

path_connectome = [pwd filesep 'connectome'];
files_conn = niak_grab_connectome(path_connectome);
files_in.data = files_conn.rmap;

files_in.mask = files_conn.network_rois;

%% General
opt.folder_out = [pwd filesep 'subtype'];    

% a list of variable names to be regressed out
% If unspecified or left empty, no confounds are regressed
opt.stack.regress_conf = {'fd'};     

%% Subtyping
opt.subtype.nb_subtype = 2;        % the number of subtypes to extract
opt.subtype.sub_map_type = 'mean'; % the model for the subtype maps (options are 'mean' or 'median')

% scalar number for the level of acceptable false-discovery rate (FDR) for the t-maps
opt.association.patient.fdr = 0.05;                           
% turn on/off normalization of covariates in model (true: apply / false: don't apply)
opt.association.patient.normalize_x = false;                   
% turn on/off normalization of all data (true: apply / false: don't apply)
opt.association.patient.normalize_y = false;                  
% turn on/off adding a constant covariate to the model
opt.association.patient.flag_intercept = true;     
% To test a main effect of a variable
opt.association.patient.contrast.patient = 1; % scalar number for the weight of the variable in the contrast
opt.association.patient.contrast.fd = 0;      % scalar number for the weight of the variable in the contrast
opt.association.patient.contrast.age = 0;     % scalar number for the weight of the variable in the contrast
% type of data for visulization (options are 'continuous' or 'categorical')
opt.association.patient.type_visu = 'continuous'; 

% string name of the column in files_in.model on which the contigency table will be based
opt.chi2 = 'patient';    

opt.flag_test = false;  % Put this flag to true to just generate the pipeline without running it.
pipeline = niak_pipeline_subtype(files_in,opt);
