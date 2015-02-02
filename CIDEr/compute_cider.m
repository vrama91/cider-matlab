% function that computes CIDEr metric
function [ci_scr] = compute_cider(docF, num_docs, cands, refs)

refs_image = {refs.image};

% index images for against which candidates are to be scored
for i = 1:length(cands)
	cands_image = find(ismember(refs_image, cands(i).image)==1);
	cands(i).image_id = cands_image;
	assert(length(cands_image)==1);
end

% convert document frequencies to inverse document frequencies
idf = df2idf(docF, num_docs);
for it = 1:length(idf)
	if(~isempty(idf{it}))
		inv_df{it} = cell2mat(values(idf{it}));
		dic{it} = keys(idf{it});
	else
		inv_df{it} = [];
		dic{it} = [];
	end
end

idf = inv_df;

% Compute CIDEr metric
for i = 1:length(cands)
	[candFC, refFC] = load_cands_refs(cands, i);
	scr_cider_se  = func_cider(candFC, refFC, idf, dic);
	scr{i}= pool_cider(scr_cider_se);
	fprintf('Calculated CIDEr for %d\n', i);
end

ci_scr = all_cider(scr);
