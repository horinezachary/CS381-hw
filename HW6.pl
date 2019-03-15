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
sibling(Sibone,Sibtwo) :-

% 5. Define two predicates `brother/2` and `sister/2`.
%brother(X,Y) :- male(X), sibling(X,Y).
%sister(X,Y) :- female(X), sibling(X,Y).


% 6. Define a predicate `siblingInLaw/2`. A sibling-in-law is either married to
%    a sibling or the sibling of a spouse.
%siblingInLaw(X,Y) :- sibling(X,Sib), married(Sib,Y), married(X,Spouse), sibling(Spouse,Y).

% 7. Define two predicates `aunt/2` and `uncle/2`. Your definitions of these
%    predicates should include aunts and uncles by marriage.


% 8. Define the predicate `cousin/2`.


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
