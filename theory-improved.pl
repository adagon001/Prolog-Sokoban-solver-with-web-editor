subset([ ],_).
subset([H|T],List) :-
        member(H,List),
        subset(T,List).

:- table subset/2.

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

solve([_,_,B,_],Goal,Plan,_,Plan):-subset(Goal,B),!.
solve([Map,SS,BB,EE],Goal,SoFar,Len,Plan):-
    \+saveMaxLen(SoFar),
    \+length(SoFar,Len),
    opn(Op,[MapP,S,B,E],[As,Ae,Ab],[Ds,De,Db]),
    subset(MapP,Map),
    SS==S,
    subset(B,BB),
    subset([E],EE),
    \+ member(Op,SoFar),
    subtract(BB,Db,Boxes),
    subtract(EE,[De],Empty),
    append(Boxes,Ab,Boxes2),
    append(SoFar,[Op],SoFar2),
    append(Empty,[Ae],Empty2),
    solve([Map,As,Boxes2,Empty2],Goal,SoFar2,Len,Plan).

opn(pushU(Sok,From,To), %name
    [[top(To,From),top(From,Sok)],sokoban(Sok),[ box(From)],  empty(To) ], %preconditions
    [sokoban(From), empty(Sok), [box(To)]], %add list
    [sokoban(Sok),  empty(To),[box(From)]]). %delete list


opn(pushD(Sok,From,To), %name
    [[top(From,To),top(Sok,From)],sokoban(Sok),[ box(From)],  empty(To) ], %preconditions
    [sokoban(From), empty(Sok), [box(To)]], %add list
    [sokoban(Sok), empty(To), [box(From)]]). %delete list


opn(pushL(Sok,From,To), %name
    [[right(From,To),  right(Sok,From)], sokoban(Sok),[ box(From)],  empty(To) ], %preconditions
    [sokoban(From), empty(Sok), [box(To)]], %add list
    [sokoban(Sok),  empty(To), [box(From)]]). %delete list

opn(pushR(Sok,From,To), %name
    [[right(To,From), right(From,Sok)],sokoban(Sok),[ box(From)],  empty(To) ], %preconditions
    [sokoban(From), empty(Sok), [box(To)]], %add list
    [sokoban(Sok),  empty(To), [box(From)]]). %delete list

opn(moveU(From,To), %name
    [[top(To,From)],sokoban(From),[], empty(To)], %preconditions
    [sokoban(To), empty(From),[]], %add list
    [sokoban(From), empty(To),[]]). %delete list

opn(moveL(From,To), %name
    [[right(From,To)], sokoban(From),[], empty(To)], %preconditions
    [sokoban(To), empty(From),[]], %add list
    [sokoban(From), empty(To),[]]). %delete list

opn(moveD(From,To), %name
    [[top(From,To)],sokoban(From),[], empty(To)], %preconditions
    [sokoban(To), empty(From),[]], %add list
    [sokoban(From), empty(To),[]]). %delete list

opn(moveR(From,To), %name
    [[right(To,From)],sokoban(From),[], empty(To)], %preconditions
    [sokoban(To), empty(From),[]], %add list
    [sokoban(From), empty(To),[]]). %delete list