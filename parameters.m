% Filename: parameters.m
%
% Description: Specify parameters for CIDEr metric
%
% Creation Date: 01/26/14
%
% Author: Ramakrishna Vedantam

% Standard Parameters - do not change these to compute CIDEr metric
params.ngrams = [1:4]; % default: ngrams = [1:4]
params.stemming = 0; % default: stemming = 0
params.sigma = 6; % default: sigma = 6

% Runtime Parameters
params.cores = [1]; 

% set path to reference sentences (gt) and candidate (test) sentences here
path_to_references = 'data/pascal50S.mat';
path_to_candidates = 'data/pascal_single.mat';

% location to store the final CIDEr score
output_file = 'cider_pascal.mat';
