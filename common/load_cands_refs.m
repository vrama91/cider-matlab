% Filename: load_cands_refs.m
%
% Description: Load ngrams for a particular candidate and a reference from file
%
% Usage: load_cands_refs(cands, i)
%
% Author: Ramakrishna Vedantam
%
% Creation Date: 01/31/15

function [candFC, refFC] = load_cands_refs(cands, i)
parameters;

cands_folder = 'cache/cands';
refs_folder = 'cache/refs';

ngrams = params.ngrams;

for n = ngrams
	cands_file = fullfile(cands_folder,[num2str(i) '_' num2str(n) '.mat']);
	try
		load(cands_file);
	catch
		fprintf(2, 'Make sure that the candidate sentences are preprocessed!');
		dbstop;
	end
	candFC(n,:) = tf_vec;
	refs_file = fullfile(refs_folder, [num2str(cands(i).image_id) '_' num2str(n) '.mat']);
	try
		load(refs_file);
	catch
		fprintf(2, 'Make sure that the reference sentences are preprocessed!');
	end
	refFC(n,:) = tf_vec;
end

