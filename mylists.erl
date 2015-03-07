-module(mylists).
-export([rev/1,sum/1,multwo/1,split/1,app/2,test/0]).

%Jack Diaz 111499298

%reverses a list
rev(L) ->
	rev(L,[]).
rev([],Acc) ->
	Acc;
rev([H|T],Acc) ->
	rev(T,[H|Acc]).

%sums up the elements of a list

sum([]) ->
	0;
sum([H|T]) ->
	H+sum(T).

%map(F,L) --- F applied to all of the list elements
%borrowed from class code
map(_F,[]) ->
	[];
map(F,[H|T]) ->
	X = F(H),
	[X | map(F,T)].

%multiplies each element by 2
multwo(L) ->
	map(fun(X) -> 2*X end, L).

%splits a list into a pair of lists
%first in the pair is a list of evens
%second in the pair is a list of odds

split(L) ->
	EL = splitHelp(L,0),
	OL = splitHelp(L,1),
	{EL,OL}.

%extracts evens or odds
splitHelp([], _K) ->
	[];

splitHelp([H|T], K) ->
	if
		(H rem 2)=:=K ->
			[H|splitHelp(T, K)];
		true ->
			splitHelp(T, K)
	end.

%applies a list of functions to a list of integers
%ith elt of first param is applied to ith elt of second param
app([],[]) ->
	[];

app([H|T],[I|J]) ->
	[H(I) | app(T,J)].

%tests all the list funs
test() ->
	L = [1,2,3,4,5,6],
	[6,5,4,3,2,1] = rev(L),
	[] = rev([]),
	21 = sum(L),
	0 = sum([]),
	[2,4,6,8,10,12] = multwo(L),
	[] = multwo([]),
	{[2,4,6],[1,3,5]} = split(L),
	{[],[]} = split([]),
	[2,4] = app([fun (X) -> X+1 end, fun (X) -> X-1 end], [1,5]),
	[[7,5,3,4,3,1], {[2,2,4,2,8,6,2],[3,5,7,5,7,3,9]}, 336] = app([fun (X) -> rev(X) end, fun (X) -> split(X) end, fun (X) -> sum(multwo(X)) end], [[1,3,4,3,5,7],[3,2,2,4,2,5,7,8,5,7,6,2,3,9],[42,42,42,42]]),
	ok.









