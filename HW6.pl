%%
% HW6
% Created by: Zachary Horine, Griffin Thenell & Jonathan Rich
% horinez,thenellg,richj
%%

% Here are a bunch of facts describing the Simpson's family tree.
% Don't change them!

female(mona).
female(jackie).
female(marge).
female(patty).
female(selma).
female(lisa).
female(maggie).
female(ling).

male(abe).
male(clancy).
male(herb).
male(homer).
male(bart).

married_(abe,mona).
married_(clancy,jackie).
married_(homer,marge).

married(X,Y) :- married_(X,Y).
married(X,Y) :- married_(Y,X).

parent(abe,herb).
parent(abe,homer).
parent(mona,homer).

parent(clancy,marge).
parent(jackie,marge).
parent(clancy,patty).
parent(jackie,patty).
parent(clancy,selma).
parent(jackie,selma).

parent(homer,bart).
parent(marge,bart).
parent(homer,lisa).
parent(marge,lisa).
parent(homer,maggie).
parent(marge,maggie).

parent(selma,ling).



%%
% Part 1. Family relations
%%

% 1. Define a predicate `child/2` that inverts the parent relationship.
child(Child,Parent) :- parent(Parent,Child).

% 2. Define two predicates `isMother/1` and `isFather/1`.
isMother(Parent) :- female(Parent) , not(\+ child(_,Parent)).
isFather(Parent) :- male(Parent), not(\+ child(_,Parent)).


% 3. Define a predicate `grandparent/2`.
% grandpartnt(Grandparent,Grandchild)
% parten(parent,child)
%                   parent( abe,(homer,bart))
grandparent(Grandparent,Grandchild) :- parent(Parent,Grandchild), parent(Grandparent,Parent).


% 4. Define a predicate `sibling/2`. Siblings share at least one parent.
sibling(Sibone,Sibtwo) :- parent(Parent,Sibone), parent(Parent,Sibtwo), Sibone \= Sibtwo.


% 5. Define two predicates `brother/2` and `sister/2`.
brother(X,Y) :- male(X), sibling(X,Y).
sister(X,Y) :- female(X), sibling(X,Y).


% 6. Define a predicate `siblingInLaw/2`. A sibling-in-law is either married to
%    a sibling or the sibling of a spouse.
siblingInLaw(X,Y) :- (sibling(X,Sib), married(Sib,Y)); (married(X,Spouse), sibling(Spouse,Y)).

% 7. Define two predicates `aunt/2` and `uncle/2`. Your definitions of these
%    predicates should include aunts and uncles by marriage.
uncle(X,Y) :- male(X),((sibling(X,Sib),child(Y,Sib));(siblingInLaw(X,Sibinlaw),child(Y,Sibinlaw))).
aunt(X,Y) :- female(X),((sibling(X,Sib),child(Y,Sib));(siblingInLaw(X,Sibinlaw),child(Y,Sibinlaw))).

% 8. Define the predicate `cousin/2`.
cousin(X,Y) :- parent(Parent,X), sibling(Parent,Sibling), child(Y,Sibling).

% 9. Define the predicate `ancestor/2`.
ancestor(Ancestor, X) :- grandparent(Ancestor, X).
ancestor(Ancestor, X) :- parent(Ancestor, X).

% Extra credit: Define the predicate `related/2`.
related(X,Y) :- ancestor(X,Y).
related(X,Y) :- ancestor(Y,X).
related(X,Y) :- aunt(X,Y).
related(X,Y) :- aunt(Y,X).
related(X,Y) :- uncle(X,Y).
related(X,Y) :- uncle(Y,X).
related(X,Y) :- cousin(X,Y).
related(X,Y) :- siblingInLaw(X,Y).
related(X,Y) :- sibling(X,Y).

%%
% Part 2. Language implementation (see course web page)
%%

%%
% num	::=	(any number literal)
% str	::=	(any string literal)
% bool	::=	t   |   f	               boolean literals
% prog	::=	cmd∗	                     sequence of commands
% cmd	   ::=	num   |   str   |   bool	push a literal onto the stack
%          |	add   |   lte	            number addition/comparison
%          |	if(prog,prog)	            conditional branching
%%

bool(t). bool(f).

%%
% 1. Define the predicate cmd/3, which describes the effect of a command on the stack.
% That is, the predicate cmd(C,S1,S2) means that executing command C with stack S1 
% produces stack S2.
%%

cmd(C,S1,S2) :- number(C), S2 = [C|S1].
cmd(C,S1,S2) :- string(C), S2 = [C|S1].
cmd(C,S1,S2) :- bool(C), S2 = [C|S1].

cmd(add,[NumA,NumB|S1],S2) :- S2 = [Result|S1], Result is NumA + NumB.

cmd(lte,[NumA,NumB|S1],S2) :- S2 = [t|S1], NumA =< NumB.
cmd(lte,[_,_|S1],S2) :- S2 = [f|S1].

cmd(if(Prog1,_),[t|S1],S2) :- prog(Prog1,S1,S2).
cmd(if(_,Prog2),[f|S1],S2) :- prog(Prog2,S1,S2).

%%
% Define the predicate prog/3, which describes the effect of a program on the stack.
% That is, the predicate prog(P,S1,S2) means that executing program P with stack S1
% produces stack S2.
%%

prog([CmdA],S1,S2)      :- cmd(CmdA,S1,S2).
prog([CmdA|CmdB],S1,S3) :- cmd(CmdA,S1,S2), prog(CmdB,S2,S3).