
nb_subject = 100; % # of subjects
nb_roi = 300;     % # of regions
nb_cluster = 3;   % # of clusters 
alpha = 0.3;      % this parameter controls the "strength" of the clustering. 

y = randn(nb_subject,nb_roi);
ind = floor(linspace(1,nb_roi,nb_cluster+1));
for cc = 1:nb_cluster
    cluster = ind(cc):ind(cc+1);
    y(:,cluster) = y(:,cluster) + alpha*repmat(randn(nb_subject,1),[1 length(cluster)]);
end

R = corr(y);
title('Spatial correlation matrix')
imagesc(R), axis square, colormap(jet), colorbar

hier = niak_hierarchical_clustering(R); % The similarity-based hierarchical clustering
part = niak_threshold_hierarchy(hier,struct('thresh',3)); % threshold the hierarchy to get 3 clusters
niak_visu_part(part) % visualize the partition

order = niak_hier2order(hier); % order the regions based on the hierarchy
subplot(1,2,1)
% Re-order the correlation matrix
title('re-ordered correlation matrix')
imagesc(R(order,order)), axis square, colorbar
subplot(1,2,2)
% Show the re-ordered partition
title('re-ordered partition')
niak_visu_part(part(order)), axis square

nb_samp = 30;
opt_b.block_length = 1; % That's a parameter for the bootstrap. We treat the subjects as independent observations. 
for ss = 1:nb_samp
    niak_progress(ss,nb_samp)
    y_s = niak_bootstrap_tseries(y,opt_b); % Bootstrap the subjects
    R_s = corr(y_s); % compute the correlation matrix for the bootstrap sample
    hier = niak_hierarchical_clustering(R_s,struct('flag_verbose',false)); % replication the hierarchical clustering
    part = niak_threshold_hierarchy(hier,struct('thresh',nb_cluster)); % Cut the hierarchy to get clusters
    mat = niak_part2mat(part,true); % convert the partition into an adjacency matrix
    if ss == 1; stab = mat; else stab = stab+mat; end; % Add all adjacency matrices
end
stab = stab / nb_samp; % Divide by the number of replications to get the stability matrix

imagesc(stab), axis square, colormap(jet), colorbar

hier_consensus = niak_hierarchical_clustering(stab); % run a hierarchical clustering on the stability matrix
part_consensus = niak_threshold_hierarchy(hier_consensus,struct('thresh',nb_cluster)); % cut the consensus hierarchy
niak_visu_part(part_consensus), axis square, colormap(jet) % visualize the consensus partition

map = mean(stab(:,part_consensus==1),2); % Stability "map" of the first consensus cluster
plot(map)
