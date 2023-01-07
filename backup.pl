subset([ ],_).
subset([H|T],List) :-
        member(H,List),
        subset(T,List).

/* Board definition: adjacent positions                                    */


/* Boxes initial positions                                                 */

/* Storage positions                                                       */

:- table subset/2.

test(Plan, Len):-
    solve([top(x0y0, x0y1),right(x1y0, x0y0),storage(x0y0),empty(x0y0),top(x1y0, x1y1),right(x2y0, x1y0),box(x1y0),top(x2y0, x2y1),right(x3y0, x2y0),empty(x2y0),top(x3y0, x3y1),right(x4y0, x3y0),top(x4y0, x4y1),top(x0y1, x0y2),right(x1y1, x0y1),top(x1y1, x1y2),right(x2y1, x1y1),top(x2y1, x2y2),right(x3y1, x2y1),empty(x2y1),top(x3y1, x3y2),right(x4y1, x3y1),top(x4y1, x4y2),top(x0y2, x0y3),right(x1y2, x0y2),top(x1y2, x1y3),right(x2y2, x1y2),top(x2y2, x2y3),right(x3y2, x2y2),empty(x2y2),top(x3y2, x3y3),right(x4y2, x3y2),top(x4y2, x4y3),top(x0y3, x0y4),right(x1y3, x0y3),top(x1y3, x1y4),right(x2y3, x1y3),empty(x1y3),top(x2y3, x2y4),right(x3y3, x2y3),empty(x2y3),top(x3y3, x3y4),right(x4y3, x3y3),box(x3y3),top(x4y3, x4y4),storage(x4y3),empty(x4y3),top(x0y4, x0y5),right(x1y4, x0y4),top(x1y4, x1y5),right(x2y4, x1y4),sokoban(x1y4),top(x2y4, x2y5),right(x3y4, x2y4),top(x3y4, x3y5),right(x4y4, x3y4),empty(x3y4),top(x4y4, x4y5),right(x1y5, x0y5),storage(x0y5),empty(x0y5),right(x2y5, x1y5),box(x1y5),right(x3y5, x2y5),empty(x2y5),right(x4y5, x3y5),empty(x3y5)],
          [box(x0y0),box(x4y3),box(x0y5)],
          [],
          Len,
          Plan).

test(Plan, Len):-
    Len2 is Len + 1,
	test(Plan, Len2).

solve(State,Goal,Plan,Len,Plan):-subset(Goal,State),!.
solve(State,Goal,SoFar,Len,Plan):-
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