% Filename: load_data.mat
% 
% Description: Load the data candidate and reference data stored in mat files
%
% Author: Ramakrishna Vedantam
%
% Date Created: 01/27/15

function [refs, cands] = load_data(path_to_candidates, path_to_references)
	load(path_to_candidates);
	load(path_to_references);
end