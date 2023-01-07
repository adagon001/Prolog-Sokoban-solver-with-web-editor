subset([ ],_).
subset([H|T],List) :-
        member(H,List),
        subset(T,List).

%:- table subset/2.

test(Plan, Len):-
    solve([ top(x0y0,x0y1), right(x1y0,x0y0), storage(x0y0), empty(x0y0), top(x1y0,x1y1), right(x2y0,x1y0), sokoban(x1y0), top(x2y0,x2y1), right(x3y0,x2y0), empty(x2y0), top(x3y0,x3y1), empty(x3y0), top(x0y1,x0y2), right(x1y1,x0y1), box(x0y1), top(x1y1,x1y2), right(x2y1,x1y1), box(x1y1), top(x2y1,x2y2), right(x3y1,x2y1), box(x2y1), top(x3y1,x3y2), storage(x3y1), empty(x3y1), right(x1y2,x0y2), storage(x0y2), empty(x0y2), right(x2y2,x1y2), empty(x1y2), right(x3y2,x2y2), empty(x2y2), empty(x3y2)],
        [ box(x0y0), box(x3y1), box(x0y2)],
          [],
          Len,
          Plan).

test(Plan, Len):-
    maxLength(ActualLen),
    ActualLen==Len,
    Len2 is Len + 1,
	test(Plan, Len2).

maxLength(0).
:- dynamic maxLength/1.

saveMaxLen(SoFar):-
    maxLength(MaxLen),
    length(SoFar,Len),
    Len>MaxLen,
    retractall(maxLength(_)),
    assertz(maxLength(Len)),
    false.

solve(State,Goal,Plan,Len,Plan):-subset(Goal,State),!.
solve(State,Goal,SoFar,Len,Plan):-
    \+saveMaxLen(SoFar),
    \+length(SoFar,Len),
    opn(Op,P,A,D),
    subset(P,State),
    \+ member(Op,SoFar),
    subtract(State,D,State2),
    append(State2,A,NewState),
    append(SoFar,[Op],SoFar2),
    solve(NewState,Goal,SoFar2,Len,Plan).

opn(pushU(Sok,From,To), %name
    [top(To,From),top(From,Sok),sokoban(Sok), box(From),  empty(To) ], %preconditions
    [sokoban(From), empty(Sok), box(To), placed(To)], %add list
    [sokoban(Sok), box(From), empty(To)]). %delete list


opn(pushD(Sok,From,To), %name
    [top(From,To),top(Sok,From),sokoban(Sok), box(From),  empty(To) ], %preconditions
    [sokoban(From), empty(Sok), box(To)], %add list
    [sokoban(Sok), box(From), empty(To)]). %delete list


opn(pushL(Sok,From,To), %name
    [right(From,To),  right(Sok,From), sokoban(Sok), box(From),  empty(To) ], %preconditions
    [sokoban(From), empty(Sok), box(To)], %add list
    [sokoban(Sok), box(From),  empty(To)]). %delete list

opn(pushR(Sok,From,To), %name
    [right(To,From), right(From,Sok),sokoban(Sok), box(From),  empty(To) ], %preconditions
    [sokoban(From), empty(Sok), box(To)], %add list
    [sokoban(Sok), box(From),  empty(To)]). %delete list

opn(moveU(From,To), %name
    [top(To,From),sokoban(From), empty(To)], %preconditions
    [sokoban(To), empty(From)], %add list
    [sokoban(From), empty(To)]). %delete list

opn(moveL(From,To), %name
    [right(From,To), sokoban(From), empty(To)], %preconditions
    [sokoban(To), empty(From)], %add list
    [sokoban(From), empty(To)]). %delete list

opn(moveD(From,To), %name
    [top(From,To),sokoban(From), empty(To)], %preconditions
    [sokoban(To), empty(From)], %add list
    [sokoban(From), empty(To)]). %delete list

opn(moveR(From,To), %name
    [right(To,From),sokoban(From), empty(To)], %preconditions
    [sokoban(To), empty(From)], %add list
    [sokoban(From), empty(To)]). %delete list