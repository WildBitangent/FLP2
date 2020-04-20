%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FLP2 Proj - Hamiltons Cycle
% 
% author: Matej Karas
% email: xkaras34@stud.fit.vutbr.cz
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Implementation from YAP6 library
% Since merlin is running 6.1.1 version
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
convlist(_, [], []).
convlist(Pred, [Old|Olds], NewList) :-
	call(Pred, Old, New),
	!,
	NewList = [New|News],
	convlist(Pred, Olds, News).
convlist(Pred, [_|Olds], News) :-
	convlist(Pred, Olds, News).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input parser by Martin Hyrs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Read single line from stdin
read_line(L,C) :-
	get_char(C),
	(isEOFEOL(C), L = [], !;
		read_line(LL,_),
		[C|LL] = L).

% Test for EOL/EOF
isEOFEOL(C) :-
	C == end_of_file;
	(char_code(C,Code), Code==10).

% Read lines from stdin until EOF is reached
read_lines(Ls) :-
	read_line(L,C),
	( 
		C == end_of_file, Ls = [], !;
	  	read_lines(LLs), Ls = [L|LLs]
	).

% Split list of lines to tokens
split_lines([], []).
split_lines([L|Ls], [H|T]) :- split_lines(Ls, T), split_line(L, H).

% Create list of tokens from line separated by spaces
split_line([], []) :- !.
split_line([' '|T], S) :- !, split_line(T, S).
split_line([H|T], [H|Sx]) :- split_line(T, Sx).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Print
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Print single path
print(Path) :- 
	path(V1, V2, Path), !,
	write(V1), write('-'), write(V2).

% Print single cycle on one line
print_cycle([H]) :- print(H).
print_cycle([H|T]) :- 
	print(H), write(' '),
	print_cycle(T).

% Print all cycles
print_cycles([]).
print_cycles([H|T]) :- print_cycle(H), nl, print_cycles(T).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Logic
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Tell the interpret, those will change in runtime
:- dynamic vertex/1.
:- dynamic path/3.

% Create database of Vertices and Paths
build_db([], _).
build_db([[H1, H2]|T], N) :- 
	assertz(vertex(H1)), 		% Add vertex 1
	assertz(vertex(H2)),		% Add vertex 2
	assertz(path(H1, H2, N)),	% Add path
	assertz(path(H2, H1, N)),	% Add reversed path
	N1 is N + 1,
	build_db(T, N1).
build_db([_|T], N) :- build_db(T,N). % Ignore wrong format of line

% Create permutations from given list (slightly faster than lib function)
permute([], []).
permute([X|Rest], L) :- permute(Rest, L1), select(X, L, L1).

% Appends first Vertex to list -- creates cycle
make_cycle([H|T], Out) :- append([H|T], [H], Out).

% Convert list of vertices to path numbers
% Also removes all invalid paths
pathlist_to_nums([H1, H2], [Out]) :- path(H1, H2, Out).
pathlist_to_nums([H1, H2|T], [Out|X]) :- path(H1, H2, Out), pathlist_to_nums([H2|T], X).

% Creates valid permutations out of vertices
create_perm_paths(Out) :-
	setof(V, vertex(V), Vertices), 							% get vertices
	bagof([H|X], (permute(Vertices, [H|X])), Permutations), % create permutations
	maplist(make_cycle, Permutations, Inv),					% append first vertex to the end, so it's cycle
	convlist(pathlist_to_nums, Inv, Out).					% convert vertices to paths

% Make unique cycles
make_unique(Paths, Out) :- 
	maplist(sort, Paths, X), 	% sort inner
	sort(X, Out). 				% sort outer -- remove duplicate cycles

% Loads input
process_input :- 
	prompt(_, ''),
	read_lines(Input),
	split_lines(Input, Lines),
	build_db(Lines, 0).

% Main program, Load input, creates DB of facts, find and print cycles
start :-
	process_input,
	create_perm_paths(Paths),
	make_unique(Paths, Cycles),
	print_cycles(Cycles),
	halt.
