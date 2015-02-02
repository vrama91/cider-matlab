% Filename 
% -----------
%           extract_n_grams_cands.m
% Parameters
% -----------
%           cands : Reference Setnences for images in the testing dataset
%                  MATLAB struct with fields (image, sent)
%           docF : n-gram dictionaries extracted from reference sentences
%                  cell array of containers.Map storing {key == word, value == document_frequency}
% Returns
% -----------
%           None
% Notes
% -----------
%           Only extracts n-grams for reference sentences. See extract_n_grams_cands.m for candidate n-gram extraction code.
% See Also
% -----------
%           extract_n_grams.m

function extract_n_grams_cands(cands, docF)

parameters;
cores = params.cores;

folder_write = fullfile('cache', 'cands/');


parameters;
ngrams = params.ngrams;
stemming = params.stemming;

% extract tokens and remove punctuation
location = fullfile('cache', 'cands');

file = [location '_tokens'];
try
    load(file);
catch
    tokens = cell(length(cands(1).sent),length(cands));
    untoken = cell(length(cands(1).sent),length(cands));
    % tokenize sentences
    for ref_iter = 1:length(cands)
        for sent_iter = 1:length(cands(ref_iter).sent)
             [tokens{sent_iter, ref_iter}, untoken{sent_iter, ref_iter}]...
                = tokenize(cands(ref_iter).sent{sent_iter});
            assert(~isempty(tokens{sent_iter,ref_iter}));
        end
    end
    save(file, 'tokens', 'untoken');
    fprintf('Extracted tokens from reference sentences\n');
end

% stemming or lemmatization if needed
if(stemming == 1)
    file = [location '_stem'];
    try
        load(file);
    catch
        for i = 1:size(tokens,1)
            for j = 1:size(tokens,2)
                tokens{i,j} = cellfun(@porterStemmer, tokens{i,j},...
                    'UniformOutput', 0);
            assert(~isempty(tokens{i,j}));
            end
            fprintf('finished stemming img %d\n', i);
        end
        save(file, 'tokens');
    end
    fprintf('Stemming done\n');
else
    file = [location '_none'];
    try
        load(file)
    catch
        save(file, 'tokens')
    end
    fprintf('Processed * None *\n');
end

file = [location '_' num2str(stemming) '_' num2str(ngrams) '_ngrams'];
try
    load(file);
catch
    token_vector = tokens(:);
    ngram_tokens = cell(length(ngrams), length(token_vector));
    for n = ngrams
        for it = 1:length(token_vector)
            ngram_tokens{n,it} = token_ngrams(token_vector{it},n);
            fprintf('Processed %d n= %d\n', it,n);
        end
    end
    save(file, 'ngram_tokens');
end
ngram_s_doc = reshape(ngram_tokens, length(ngrams), size(tokens,1), size(tokens,2));

for n = ngrams
    for i = 1:size(ngram_s_doc,3)
        ngrams_sent = ngram_s_doc(n,:,i);
        ngram_doc{n, i} = [ngrams_sent{:}];
    end
end

% compute tf-df
if(exist(folder_write)~=7)
    mkdir(folder_write)
    for n=ngrams
        dictionary_n = keys(docF{ngrams(n)});
        for i = 1:size(ngram_tokens,2)
            [s, doc] = ind2sub(size(tokens), i);
            if(s==1)
                tf_vec = cell(1, size(tokens,1)); 
            end
            words = ngram_tokens{n, i};
            tf_vec{s} = sparse(project_dict_fast(words, dictionary_n));
            if(s==size(tokens,1))
                save([folder_write num2str(doc) '_' num2str(n) '.mat'], 'tf_vec');
                fprintf('Processed n = %d , %d \n', n, doc);                
                clear tf_vec;
            end                
        end
    end
end

