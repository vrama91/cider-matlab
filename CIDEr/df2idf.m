% function to convert document frequency to idf
function idf = df2idf(docFR, num_docs)

	num_ref_docs = num_docs;
	for it = 1:length(docFR)
		docF = docFR{it};
		if(~isempty(docF))
			doc_val = cell2mat(values(docF));
			doc_key = keys(docF);
			inv_doc = log(num_ref_docs./doc_val);
			idf{it} = containers.Map(doc_key, inv_doc);
		else
			idf{it} = [];
		end
	end

