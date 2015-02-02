% test.m

a = sort({'cat', 'dog', 'bat', 'stuff', 'things', 'with', 'how', 'nothing'});
b = {'cat', 'dog', 'dog', 'dog', 'cat', 'dog', 'dog', 'cat'};

for i = 1:10
	b = [b, b];
end

keyboard;
t = tic();
projectDict(b, a)
toc(t)

t = tic();
project_dict_fast(b, a)
toc(t)
