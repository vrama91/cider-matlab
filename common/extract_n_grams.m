% Filename: extract_n_grams.m
%
% Parameters:
%           refs : Reference Setnences for images in the testing dataset
%                  MATLAB struct with fields (image, sent)
% Returns:
%           docF : n-gram dictionaries extracted from reference sentences
%                  cell array of containers.Map storing {key == word, value == document_frequency}
% Notes:
%           Only extracts n-grams for reference sentences. See extract_n_grams_cands.m for candidate n-gram extraction code.
% See Also:
%           extract_n_grams_cands.m

function [docF,num_docs] = extract_n_grams(refs)
folder_write = fullfile('cache', 'refs/');

parameters;
ngrams = params.ngrams;
stemming = params.stemming;
cores = params.cores;


location = fullfile('cache', 'refs');
file = [location '_tokens'];

try
    load(file);
catch
    tokens = cell(length(refs(1).sent),length(refs));
    untoken = cell(length(refs(1).sent),length(refs));
    % tokenize sentences
    for ref_iter = 1:length(refs)
        for sent_iter = 1:length(refs(ref_iter).sent)
            [tokens{sent_iter, ref_iter}, untoken{sent_iter, ref_iter}]...
                = tokenize(refs(ref_iter).sent{sent_iter});
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
            parfor j = 1:size(tokens,2)
                tokens{i,j} = cellfun(@porterStemmer, tokens{i,j},...
                    'UniformOutput', 0);
                assert(~isempty(tokens{i,j}));
            end
            fprintf('finished stemming sent %d\n', i);
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

file = [location '_' num2str(stemming) '_tfidf'];
% now form the dictionary
for n = ngrams
        all_words = ngram_tokens(n,:);
        words_all = [all_words{:}];
        docF{n} = containers.Map(words_all, zeros(1,length(words_all)));
        dictionary{n} = keys(docF{n});
end
% access tokens for a sentnece in the (ngram, sentence_id, image_id) format
ngram_s_doc = reshape(ngram_tokens, length(ngrams), size(tokens,1), size(tokens,2));

for n = ngrams
    for i = 1:size(ngram_s_doc,3)
        ngrams_sent = ngram_s_doc(n,:,i);
        ngram_doc{n, i} = [ngrams_sent{:}];
    end
end

% get len_vec from ngram_tokens
% get tf-df
termF = cell(length(ngrams), size(tokens,1), size(tokens,2));
for n=ngrams
    try
        load(fullfile('cache',['df' '_' num2str(n) '.mat']), 'docF', 'num_docs');
    catch
        % instantiate 
        dictionary_n = dictionary{n};
        df = zeros(1,length(dictionary_n));

        % extract the document frequency
        for i = 1:size(ngram_doc,2)
                df = df + ismember(dictionary_n, ngram_doc{n,i});
                fprintf('Done with %d\n',i);
        end

        document_freq = containers.Map(dictionary_n, df);
        docF{ngrams(n)} = document_freq;
        num_docs = size(tokens,2);
        save(fullfile('cache',['df' '_' num2str(n) '.mat']), 'docF', 'num_docs');
        assert(all(df~=0));
    end
end

% extract term frequency for each sentence
if(exist(folder_write)~=7)
    mkdir(folder_write);
    if(cores>1)
        matlabpool('open', cores);
        for n = ngrams
            dictionary_n = dictionary{n};
            for j = 1:size(ngram_s_doc,3)
                tf_vec = cell(1, size(ngram_s_doc,2));
                parfor i = 1:size(ngram_s_doc,2)
                    words = ngram_s_doc{n, i, j};
                    tf_vec{i} = sparse(project_dict_fast(words, dictionary_n));
                end
                save([folder_write num2str(j) '_' num2str(n) '.mat'], 'tf_vec');
                fprintf('Processed n = %d , %d \n',n,j);
            end
        end
    matlabpool('close');
    else
        for n=ngrams
            dictionary_n = dictionary{n};
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
end
