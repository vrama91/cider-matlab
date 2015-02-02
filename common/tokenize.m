% tokenize sentence
function [tokens, untoken] = tokenize(sentence)
	% might want to make untoken as just strjoin of tokens
untoken = lower(sentence);
tokens = regexp(lower(sentence), '[\w]+[^./ ; )(,"\''t \-!:?]*','match');
