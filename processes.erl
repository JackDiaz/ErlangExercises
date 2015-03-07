-module(processes).
-export([twoproc/1,nproc/2,starproc/2,test/0]).

%Jack Diaz 111499298


test() ->
	twoproc(3),
	nproc(4,3),
	starproc(4,3),
	all_good.


%spawns two procs and they send a message back and forth between each other M times
%one proc is a start which sends the initial message and the other is an other
twoproc(M) ->
	io:fwrite("twoproc starting\n"),
	register(top,self()),
	To = spawn(fun () -> other(M) end),
	start(To, M).

start(_To, 0) ->
	io:fwrite(pid_to_list(self())++"s-done\n"),
	io:fwrite("twoproc done\n"),
	top ! {},
	start_ok;

start(To, M) ->
	To ! {self()},
	io:fwrite(pid_to_list(self())++"s-sent\n"),
	receive
		{} ->
			io:fwrite(pid_to_list(self())++"s-rec\n"),
			start(To, M-1)
	end,
	ok.

other(0) ->
	io:fwrite(pid_to_list(self())++"o-done\n"),
	other_ok;

other(M) ->
	receive
		{From} ->
			io:fwrite(pid_to_list(self())++"o-rec\n"),
			From ! {},
			io:fwrite(pid_to_list(self())++"o-sent\n"),
			other(M-1)
	end.

%spawns N procs and they send a message in a circle M times
%one proc is an init which sends the initial message and the others are nodes
nproc(N, M) ->
	io:fwrite("nproc starting\n"),
	Mid = loop(1, N-1, M, self()),
	init(Mid,M),
	ok.

init(_To, 0) ->
	io:fwrite(pid_to_list(self())++"s-done\n"),
	io:fwrite("nproc done\n"),
	start_ok;

init(To, M) ->
	To ! {},
	io:fwrite(pid_to_list(self())++"s-sent\n"),
	receive
		{} ->
			io:fwrite(pid_to_list(self())++"s-rec\n"),
			init(To, M-1)
	end.

node(_To, 0) ->
	io:fwrite(pid_to_list(self())++"n-done\n"),
	node_ok;

node(To, M) ->
	receive
		{} ->
			io:fwrite(pid_to_list(self())++"n-rec\n"),
			To ! {},
			io:fwrite(pid_to_list(self())++"n-sent\n"),
			node(To, M-1)
	end.

loop(N, N, M, Point) ->
    spawn(fun() -> node(Point, M) end);
loop(I, N, M, Point) -> 
    A = spawn(fun() -> node(Point, M) end),
    loop(I+1, N, M, A).

%spawns N procs and they send messages in a star shape
%one proc is a starinit which sends the initial messages and receives messages from the other procs 
%and the others are starnodes, they receive from the starinit and send the message back
starproc(N, M) ->
	io:fwrite("starproc starting\n"),
	Spokes = loop2(1, N-1, M, self()),
	starinit(Spokes,(M*(N-1)-(M-2))),
	ok.

starinit(_To, 0) ->
	io:fwrite(pid_to_list(self())++"s-done\n"),
	io:fwrite("starproc done\n"),
	start_ok;

starinit(S,M) ->
	map(fun(X) -> X ! {} end, S),
	io:fwrite(pid_to_list(self())++"s-sent\n"),
	receive
		{From} ->
			io:fwrite(pid_to_list(self())++"s-rec\n"),
			starinit([From], M-1)
	end.

starnode(_To, 0) ->
	io:fwrite(pid_to_list(self())++"n-done\n"),
	node_ok;

starnode(To, M) ->
	receive
		{} ->
			io:fwrite(pid_to_list(self())++"n-rec\n"),
			To ! {self()},
			io:fwrite(pid_to_list(self())++"n-sent\n"),
			starnode(To, M-1)
	end.

loop2(N, N, M, Point) ->
    A = spawn(fun() -> starnode(Point, M) end),
    [A];
loop2(I, N, M, Point) -> 
    A = spawn(fun() -> starnode(Point, M) end),
    [A|loop2(I+1, N, M, Point)].

%map(F,L) --- F applied to all of the list elements
%borrowed from class code
map(_F,[]) ->
	[];
map(F,[H|T]) ->
	X = F(H),
	[X | map(F,T)].

