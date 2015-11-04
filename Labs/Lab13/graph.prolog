edge(a, b, 2).
edge(b, a, 2).
edge(a, c, 3).
edge(c, a, 3).
edge(a, f, 4).
edge(f, a, 4).
edge(b, c, 2).
edge(c, b, 2).
edge(c, d, 3).
edge(d, c, 3).
edge(c, e, 1).
edge(e, c, 1).
edge(d, f, 5).
edge(f, d, 5).

find_path(Start, End, _, Cost, Path, Lst) :-
  edge(Start, End, Cost),
  Path = [Start, End].

find_path(Start, End, Visited, TotalCost, Path) :-
  edge(Start, X, InitCost),
  X \+ End,
  \+ member(X, Visited),
  find_path(X, End, [Start | Visited], RestCost, TailPath),
  TotalCost is InitCost + RestCost,
  Path = [Start|TailPath].

% find_path(a, c, TC, P).
% member(X, L) returns true if L is in L