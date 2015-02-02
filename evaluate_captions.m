% Filename: evaluate_captions.m
%
% Description: Main script to evaluate CIDEr metric as described in http://arxiv.org/abs/1411.5726
%
% Creation Date: 01/26/14
%
% Author: Ramakrishna Vedantam

% Usage: 
% 1. Specify the reference and candidate files, as mat files in the following format
% 		<object> of struct in matlab with the fields : (image, sent)
%			object.sent is of type cell array of char
% 			object.image is of type char 

% 2. See sample reference and candidate files in data/pascal50S.mat and data/pascal_cands.mat
%
% 3. Set parameters in the file parameters.m
addpath('cache');
addpath('CIDEr');
addpath('common');
addpath('data');

if(exist('cache')~=7)
	mkdir('cache');
end

parameters;
% load the data 
[refs, cands] = load_data(path_to_candidates, path_to_references);

% extract tokens, stem the reference sentences and get n-grams
[docF, num_docs] = extract_n_grams(refs);
% extract tokens, stem the candidate sentences and get n-grams
extract_n_grams_cands(cands, docF);

scr = compute_cider(docF, num_docs, cands, refs);
% cider score
cider = scr{end};
% scr{1} contains CIDEr_1, scr{2} contains CIDEr_2, scr{3} contains CIDEr_3
% scr{4} contains CIDEr_4, scr{5} contains CIDEr scores
save(fullfile('data', output_file), 'scr');