% caculate the cider score
function cider_score = func_cider(candtf, reftf, idf, d)

parameters;
ngrams = params.ngrams;

% (1-4)(1-4)(1-4)..
candtf_all = candtf(:);
cider_score = zeros(length(ngrams), size(candtf,2), size(reftf,2));

for it = 1:length(candtf_all)
	[n, cand_id] = ind2sub(size(candtf), it);
	% multiply tf by idf
    candvec = candtf{n, cand_id}.*idf{ngrams(n)};

	reftf_n = reftf(n,:);
	for ref_id = 1:length(reftf_n)
		% multiply tf by idf
        refvec = reftf_n{ref_id}.*idf{ngrams(n)};

		cider_score(n,cand_id,ref_id) = dot(candvec,refvec)./(norm(candvec)*norm(refvec));
		% cider score will be zero if refvec or candvec are all zero, but that should actually
		% never have happend
		if(isnan(cider_score(n,cand_id, ref_id)))
			cider_score(n, cand_id, ref_id) = 0;
		end
		assert(abs(cider_score(n,cand_id, ref_id))<=1+10^-5 );
	end
end
