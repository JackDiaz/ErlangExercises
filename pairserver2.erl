-module(pairserver2). 
-export([make_pair/0, push/2, pop/1, peek/1, swap/1, test/0]). 
-export([init/0, handle_call/2, handle_cast/2]).

%Jack Diaz 111499298


% API 
make_pair()     -> server:start(pairserver2). 
push(Pair, P)   -> server:cast(Pair, {push, P}). 
pop(Pair)       -> server:call(Pair, pop). 
peek(Pair)      -> server:call(Pair, peek). 
swap(Pair)      -> server:cast(Pair, swap).

% Server callbacks 
init()                          -> {0,0}. 
handle_call(pop, {A,B})         -> {A,{B,0}};
handle_call(peek, {A,B})        -> {A, {A,B}}. 
handle_cast({push, P}, {A, _})  -> {P, A};
handle_cast(swap, {A,B})        -> {B,A}. 

% testing code
test() ->
    P = make_pair(),
    push(P,1), push(P,2),
    2 = pop(P),
    1 = peek(P),
    swap(P),
    0 = pop(P),
    1 = pop(P),
    push(P,4), push(P,5), push(P,6),
    6 = peek(P),
    swap(P),
    5 = peek(P),
    5 = pop(P),
    push(P,4),
    4 = pop(P),
    swap(P),
    0 = pop(P),
    6 = pop(P),
    0 = peek(P),
    ok.
