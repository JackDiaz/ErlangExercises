-module(intfuns).
-export([factif/1,fact/1,fibif/1,test/0,fib/1]).

%Jack Diaz 111499298


%tests all the int functions
test() ->
	24 = factif(4),
	24 = fact(4),
	[1,1,2,6,24,120,720,5040,40320,362880,3628800] = map(fun (X) -> factif(X) end, [0,1,2,3,4,5,6,7,8,9,10]),
	[1,1,2,6,24,120,720,5040,40320,362880,3628800] = map(fun (X) -> fact(X) end, [0,1,2,3,4,5,6,7,8,9,10]),
	[0,1,1,2,3,5,8,13,21,34,55] = map(fun (X) -> fibif(X) end, [0,1,2,3,4,5,6,7,8,9,10]),
	[0,1,1,2,3,5,8,13,21,34,55] = map(fun (X) -> fib(X) end, [0,1,2,3,4,5,6,7,8,9,10]),
	ok.

%map(F,L) --- F applied to all of the list elements
map(_F,[]) ->
	[];
map(F,[H|T]) ->
	X = F(H),
	[X | map(F,T)].

%finds the factorial of the argument

%this on uses if
factif(N) ->
	if
		N > 0 ->
			N*factif(N-1);
		true ->
			1
	end.

%this one uses multiple function clauses
fact(0) ->
	1;

fact(N) ->
	N*fact(N-1).

%finds the nth fib num using 0 as the zeroth fibnum, 1 as the first
%1 as the second, 2 as the third and so on.

%this one uses if
fibif(N) ->
	if
		N =:= 0 ->
			0;
		N =:= 1 ->
			1;
		N =:= 2 ->
			1;
		true ->
			fibif(N-1) + fibif(N-2)
	end.


%this one uses multiple function clauses
fib(0) ->
	0;
fib(1) ->
	1;
fib(2) ->
	1;
fib(N) ->
	fib(N-1) + fib(N-2).
