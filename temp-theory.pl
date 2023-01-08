subset([ ],_).
subset([H|T],List) :-
        member(H,List),
        subset(T,List).

:- table subset/2.

test(Plan, Len):-
    solve([[ top(x0y0,x0y1), right(x1y0,x0y0), top(x1y0,x1y1), right(x2y0,x1y0), top(x2y0,x2y1), right(x3y0,x2y0), top(x3y0,x3y1), right(x4y0,x3y0), top(x4y0,x4y1), right(x5y0,x4y0), top(x5y0,x5y1), right(x6y0,x5y0), top(x6y0,x6y1), right(x7y0,x6y0), top(x7y0,x7y1), right(x8y0,x7y0), top(x8y0,x8y1), top(x0y1,x0y2), right(x1y1,x0y1), top(x1y1,x1y2), right(x2y1,x1y1), top(x2y1,x2y2), right(x3y1,x2y1), top(x3y1,x3y2), right(x4y1,x3y1), top(x4y1,x4y2), right(x5y1,x4y1), top(x5y1,x5y2), right(x6y1,x5y1), top(x6y1,x6y2), right(x7y1,x6y1), top(x7y1,x7y2), right(x8y1,x7y1), top(x8y1,x8y2), top(x0y2,x0y3), right(x1y2,x0y2), top(x1y2,x1y3), right(x2y2,x1y2), top(x2y2,x2y3), right(x3y2,x2y2), top(x3y2,x3y3), right(x4y2,x3y2), top(x4y2,x4y3), right(x5y2,x4y2), top(x5y2,x5y3), right(x6y2,x5y2), top(x6y2,x6y3), right(x7y2,x6y2), top(x7y2,x7y3), right(x8y2,x7y2), top(x8y2,x8y3), top(x0y3,x0y4), right(x1y3,x0y3), top(x1y3,x1y4), right(x2y3,x1y3), top(x2y3,x2y4), right(x3y3,x2y3), top(x3y3,x3y4), right(x4y3,x3y3), top(x4y3,x4y4), right(x5y3,x4y3), top(x5y3,x5y4), right(x6y3,x5y3), top(x6y3,x6y4), right(x7y3,x6y3), top(x7y3,x7y4), right(x8y3,x7y3), top(x8y3,x8y4), top(x0y4,x0y5), right(x1y4,x0y4), top(x1y4,x1y5), right(x2y4,x1y4), top(x2y4,x2y5), right(x3y4,x2y4), top(x3y4,x3y5), right(x4y4,x3y4), top(x4y4,x4y5), right(x5y4,x4y4), top(x5y4,x5y5), right(x6y4,x5y4), top(x6y4,x6y5), right(x7y4,x6y4), top(x7y4,x7y5), right(x8y4,x7y4), top(x8y4,x8y5), top(x0y5,x0y6), right(x1y5,x0y5), top(x1y5,x1y6), right(x2y5,x1y5), top(x2y5,x2y6), right(x3y5,x2y5), top(x3y5,x3y6), right(x4y5,x3y5), top(x4y5,x4y6), right(x5y5,x4y5), top(x5y5,x5y6), right(x6y5,x5y5), top(x6y5,x6y6), right(x7y5,x6y5), top(x7y5,x7y6), right(x8y5,x7y5), top(x8y5,x8y6), top(x0y6,x0y7), right(x1y6,x0y6), top(x1y6,x1y7), right(x2y6,x1y6), top(x2y6,x2y7), right(x3y6,x2y6), top(x3y6,x3y7), right(x4y6,x3y6), top(x4y6,x4y7), right(x5y6,x4y6), top(x5y6,x5y7), right(x6y6,x5y6), top(x6y6,x6y7), right(x7y6,x6y6), top(x7y6,x7y7), right(x8y6,x7y6), top(x8y6,x8y7), right(x1y7,x0y7), right(x2y7,x1y7), right(x3y7,x2y7), right(x4y7,x3y7), right(x5y7,x4y7), right(x6y7,x5y7), right(x7y7,x6y7), right(x8y7,x7y7)],  sokoban(x5y4), [ box(x2y1), box(x6y1), box(x3y2), box(x2y3)],[ empty(x1y1), empty(x3y1), empty(x4y1), empty(x5y1), empty(x7y1), empty(x1y2), empty(x2y2), empty(x4y2), empty(x6y2), empty(x7y2), empty(x1y3), empty(x3y3), empty(x4y3), empty(x6y3), empty(x7y3), empty(x1y4), empty(x2y4), empty(x6y4), empty(x7y4), empty(x1y5), empty(x2y5), empty(x3y5), empty(x4y5), empty(x5y5), empty(x6y5), empty(x7y5), empty(x1y6), empty(x2y6), empty(x6y6), empty(x7y6)]],
          [ box(x6y1), box(x7y1), box(x6y2), box(x7y2)],
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