subset([ ],_).
subset([H|T],List) :-
        member(H,List),
        subset(T,List).

%:- table subset/2.

test(Plan,1):-
    solve([[ [bg],[ ]]],
          [gs],
          Plan).

solve([[State,Plan]|Rstate],Goal,Plan):-subset(Goal,State),!.
solve([[State,SoFar]|Rstate],Goal,Plan):-
    findall([X,Sf2],arr([State,SoFar],X,Sf2),Z),
	append(Rstate,Z,NewStates),
    solve(NewStates,Goal,Plan).

arr([State,SoFar],NewState,SoFar2):-
    opn(Op,P,A,D),
    subset(P,State),
    \+ member(Op,SoFar),
    subtract(State,D,State2),
    append(SoFar,[Op],SoFar2),
    append(State2,A,NewState).

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