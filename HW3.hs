-- | HW3
-- | Created by: Zachary Horine, Griffin Thenell & Jonathan Rich
-- | horinez,thenellg,richj

module HW3 where

import Data.List
import Prelude hiding (Num)

-- | USE THIS GRAMMAR
-- |
-- | num	::=	(any natural number)
-- | var	::=	(any variable name)
-- | macro	::=	(any macro name)
-- |
-- | prog	::=	ε   |   cmd ; prog	sequence of commands
-- |
-- | mode	::=	down   |   up	pen status
-- |
-- | expr	::=	var	variable reference
-- | |	num	literal number
-- | |	expr + expr	addition expression
-- |
-- | cmd	::=	pen mode	change pen mode
-- | |	move ( expr , expr )	move pen to a new position
-- | |	define macro ( var* ) { prog }  	define a macro
-- | |	call macro ( expr* )	invoke a macro


-- | #1. Define the abstract syntax of MiniLogo as a set of Haskell data types.
-- | You should use built-in types for num, var, and macro.

type Num = Int
type Var = String
type Macro = String

type Prog = [Cmd]

data Mode = Up
          | Down
          deriving (Eq,Show)

data Expr = Var Var
          | Num Int
          | Add Expr Expr
          deriving (Eq,Show)

data Cmd = Pen Mode
         | Move Expr Expr
         | Define Macro [Var] Prog
         | Call Macro [Expr]
         deriving (Eq,Show)

-- | #2. Define a MiniLogo macro line (x1,y1,x2,y2) that (starting from anywhere on the canvas) draws a line segment from (x1,y1) to (x2,y2).
-- |
-- | Concrete syntax:
-- |
-- | define line (x1,y2,x2,y2) {
-- | 	Pen up; Move(x1,y1);
-- | 	Pen down; Move(x2,y2);
-- | }
-- |

--line :: Cmd -> Prog (not needed, throws error)
line = Define "Line" ["x1","y1","x2","y2"] [Pen Up, Move (Var "x1") (Var "y1"), Pen Down, Move(Var "x2") (Var "y2")]

-- | #3. Use the line macro you just defined to define a new MiniLogo macro nix (x,y,w,h) that draws a big “X” of width w and height h, starting from position (x,y).
-- | Your definition should not contain any move commands.
-- |
-- | Concrete syntax:
-- |
-- | define nix (x,y,w,h){
-- | 	Pen Up; Move (x,y);
-- | 	Pen Down; Move (x+w,y+h);
-- | 	Pen Up; Move (x,y+h);
-- | 	Pen Down; Move (x+w, y);
-- | }
-- |

-- nix :: Cmd -> Prog (not needed, throws error)
nix = Define "nix" ["x","y","w","h"] [
   Call "Line" [(Var "x"), (Var "y"), Add (Var "x") (Var "w"), Add (Var "y") (Var "h")],
   Call "Line" [(Var "x"), Add (Var "y") (Var "h"), Add (Var "x") (Var "w"), (Var "y")]]


-- | #4. Define a Haskell function steps :: Int -> Prog that constructs a
-- | MiniLogo program that draws a staircase of n steps starting from (0,0).
-- | Below is a visual illustration of what the generated program should draw
-- | for a couple different applications of steps.
-- |
-- | Example output of steps function:
-- |
-- |                 _____ (1,1)                          _____ (3,3)
-- |               |                                    |
-- |          (0,0)|                         (1,2) _____|
-- |                                              |
-- |                                         _____|
-- |                                        |
-- |                                   (0,0)|
-- |                 steps 1                         steps 3

steps:: Int -> Prog
steps 0 = []
steps n = [Call "Line" [Num n, Num n, Num (n-1),Num n],
           Call "Line" [Num n, Num n, Num n,Num (n-1)]] ++ steps (n-1)

-- | #5. Define a Haskell function macros :: Prog -> [Macro] that returns a list
-- | of the names of all of the macros that are defined anywhere in a given
-- | MiniLogo program. Don’t worry about duplicates—if a macro is defined more
-- | than once, the resulting list may include multiple copies of its name.

--   >>> macros [Define "func1" ["x","y","z"] [Pen Up,Pen Down], Define "func2" ["x"][Call "func1" [Num 1,Num 2,Num 3]]]
--   ["func1","func2"]

macros :: Prog -> [Macro]
macros [] = []
macros (h:t) = case h of
   Define m _ _ -> m:(macros t)
   otherwise -> macros t
