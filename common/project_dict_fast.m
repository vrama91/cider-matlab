% Filename: project_dict_fast.m
%
% Author: Ramakrishna Vedantam
% 
% Description: Find the representation for text (cell array) in a vector space 
% 				indexed by dictionary
%
% Usage: project_dict_fast(text, dictionary)
function vector = project_dict_fast(text, dictionary)

[occurrence] = ismember(dictionary, text);

[~, location] = ismember(text, dictionary);

occuring_list = find(occurrence==1);
vector = zeros(1,length(dictionary));
for x = occuring_list
	vector(x) = sum(location==x);
end