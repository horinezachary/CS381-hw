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
related(Related, X) :- sibling(Related, X); siblingInLaw(Related, X).
related(Related, X) :- child(Related, Parent),!,related(Parent,X).
related(Related, X) :- child(Related, Child),!,related(Child,X).


%%
% Part 2. Language implementation (see course web page)
%%

