function tfC = tc2tf(termFC, lenC)
% use log is not being used right now
total_entities = numel(termFC);
tfC = cell(size(termFC));
for it = 1:total_entities
	[n,s,d] = ind2sub(size(termFC), it);
	tf_vec = termFC{n,s,d};
	len = lenC(n,s,d);
	if(sum(tf_vec~=0))
		assert(sum(tf_vec)<=len);
		% changing tf_vec to not include length
%		tf_vec = tf_vec./len;
		tf_vec = tf_vec;
	end
	tfC{n,s,d} = tf_vec;
end
