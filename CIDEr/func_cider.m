% caculate the cider score
function cider_score = func_cider(candtf, reftf, idf, d)

parameters;
ngrams = params.ngrams;
sigma = params.sigma;

% (1-4)(1-4)(1-4)..
candtf_all = candtf(:);
cider_score = zeros(length(ngrams), size(candtf,2), size(reftf,2));

for it = 1:length(candtf_all)
	[n, cand_id] = ind2sub(size(candtf), it);
	% multiply tf by idf
    candvec = candtf{n, cand_id}.*idf{ngrams(n)};
    len_cand = sum(candtf{1,cand_id});
	reftf_n = reftf(n,:);
	for ref_id = 1:length(reftf_n)
		% multiply tf by idf
        refvec = reftf_n{ref_id}.*idf{ngrams(n)};
        len_ref = sum(reftf{1, ref_id});

        % clipping, between each candidate and reference
		cider_score(n,cand_id,ref_id) = dot(min(candvec,refvec),refvec)./(norm(candvec)*norm(refvec));
		% cider score will be zero if refvec or candvec are all zero, but that should actually
		% never have happend
		if(isnan(cider_score(n,cand_id, ref_id)))
			cider_score(n, cand_id, ref_id) = 0;
		end
		assert(abs(cider_score(n,cand_id, ref_id))<=1+10^-5 );
		% length based gaussian penalty
		delta = len_cand-len_ref;
		cider_score(n,cand_id,ref_id) = gaussmf(delta, [sigma 0]) * cider_score(n,cand_id, ref_id);
	end
end
