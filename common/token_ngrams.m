function ngrams = token_ngrams(token, n,varargin)

if(n==1)
    ngrams = token;
    return;
end
it = repmat([1:length(token)]', [1,n]);
for i = 2:size(it,2)
    it(:,i) = it(:,i) +i -1 ;
end
if(length(token)==n)
    ngrams{1} = strjoin(token);
elseif(length(token)<n)
    ngrams = {};
else
    it = it(1:end-n+1,:);
    ng = token(it);
    ngrams = cell(1,size(it,1));
    for i = 1:size(it,1)
        ngrams{i} = strjoin(ng(i,:));
    end
end

