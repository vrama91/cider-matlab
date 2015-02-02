function ci_scr = all_cider(scr)
	
for it = 1:length(scr)
	ci = scr{it};
	new_ci = zeros(size(ci,1)+1, size(ci,2), size(ci,3));
	new_ci(1:size(ci,1),:,:) = ci;
	den_1 = 0;
	for j = 1:size(ci,1)
		new_ci(size(ci,1)+1, :, :) = new_ci(size(ci,1)+1,:,:) + ci(j,:,:);
		den_1 = den_1 + 1;
	end
	new_ci(size(ci,1)+1,:,:) = new_ci(size(ci,1)+1,:,:)/den_1;
	scr_cel{it} = new_ci;
end
% everything should be contained under ci_scr.<cider_type> so that the scores of each kind
% of green are in a different container
% 1,2,3,4,overallmean
ci_scr = cell(1, size(scr_cel{it},1));

for it = 1:length(scr)
	ci = scr_cel{it};
	for j = 1:size(ci,1)
		ci_scr{j} = [ci_scr{j}; ci(j,:,:)];
	end
end
