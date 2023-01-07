subset([ ],_).
subset([H|T],List) :-
        member(H,List),
        subset(T,List).

%:- table subset/2.

test(Plan, Len):-
    solve([bg],
        [gs],
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