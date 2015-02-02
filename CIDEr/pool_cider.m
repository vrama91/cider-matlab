function scr = pool_cider(cider_score)
parameters;
ngrams = params.ngrams;

	for n = 1:length(ngrams)
		score = cider_score(n,:,:);
		scr(n,:,1) = mean(score,3);
	end
