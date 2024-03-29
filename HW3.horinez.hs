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
-- |          |	num	literal number
-- |          |	expr + expr	addition expression
-- |
-- | cmd	::=	pen mode	change pen mode
-- |       |	move ( expr , expr )	move pen to a new position
-- |       |	define macro ( var* ) { prog }  	define a macro
-- |       |	call macro ( expr* )	invoke a macro


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
nix = Define "Nix" ["x","y","w","h"] [
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
--
--   >>> macros [Define "func1" ["x","y","z"] [Pen Up,Pen Down]]
--   ["func1"]
--
--   >>> macros [Define "func1" ["x","y","z"] [Pen Up,Pen Down], Define "func2" ["x"][Call "func1" [Num 1,Num 2,Num 3]]]
--   ["func1","func2"]

macros :: Prog -> [Macro]
macros [] = []
macros (h:t) = case h of
   Define m _ _ -> m:(macros t)
   otherwise -> macros t


-- | #6. Define a Haskell function pretty :: Prog -> String that pretty-prints
-- | a MiniLogo program. That is, it transforms the abstract syntax (a Haskell
-- | value) into nicely formatted concrete syntax (a string of characters).
-- | Your pretty-printed program should look similar to the example programs
-- | given above; however, for simplicity you will probably want to print just
-- | one command per line.
-- | In GHCi, you can render a string with newlines by applying the function
-- | putStrLn. So, to pretty-print a program p use: putStrLn (pretty p).
--
--   >>>pretty [Define "func1" ["x","y","z"] [Pen Up,Pen Down,Move (Var "x") (Var "y"),Call "Line" [Var "x",Var "x",Var "y",Var "y"]]]
--   "define func1 (x,y,z) {pen up; pen down; move (x,y); Line(x, x, y, y); }"
--
--   >>>pretty [Define "square" ["x","y"] [Pen Up,Move (Var "x") (Var "y"),Pen Down,Move (Add (Var "x") (Num 2)) (Var "y"), Move (Add (Var "x") (Num 2)) (Add (Var "y") (Num 2)), Move (Var "x") (Add (Var "y") (Num 2)), Move (Var "x") (Var "y")]]
--   "define square (x,y) {pen up; move (x,y); pen down; move (x+2,y); move (x+2,y+2); move (x,y+2); move (x,y); }"

pretty :: Prog -> String
pretty [] = ""
pretty (Pen Up:t) = "pen up; " ++ pretty t
pretty (Pen Down:t) = "pen down; " ++ pretty t
pretty (Move x y:t) = "move (" ++ resolveExpr x ++ "," ++ resolveExpr y ++ "); " ++ pretty t
pretty (Call f arg:t) = f ++ "(" ++ intercalate ", " (map resolveExpr arg) ++ "); " ++ pretty t
pretty (Define f arg prog:t) = "define " ++ f ++ " (" ++ intercalate "," arg ++ ") " ++ "{" ++ pretty prog ++ "}" ++ pretty t

resolveExpr :: Expr -> String
resolveExpr (Num n) = show n
resolveExpr (Var v) = v
resolveExpr (Add x y) = resolveExpr x ++ "+" ++ resolveExpr y


-- | BONUS Problems
-- | --------------
-- |
-- | #1. Define a Haskell function optE :: Expr -> Expr that partially evaluates
-- | expressions by replacing any additions of literals with the result.
-- | For example, given the expression (2+3)+x, optE should return the
-- | expression 5+x.
--
--   >>> optE (Add (Num 5) (Num 6))
--   Num 11
--
--   >>> optE (Add (Num 5) (Add (Num 4) (Num 6)))
--   Num 15
--
--   >>> optE (Add (Num 5) (Add (Var "x") (Num 2)))
--   Add (Num 5) (Add (Var "x") (Num 2))

optE :: Expr -> Expr
optE (Add (Num x) (Num y)) = Num $ x + y
optE (Add (Add x y) (Num z)) = optE (Add (optE (Add x y)) (Num z))
optE (Add (Num z) (Add x y)) = optE (Add (Num z) (optE (Add x y)))
optE otherwise = otherwise


-- | #2. Define a Haskell function optP :: Prog -> Prog that optimizes all of
-- | the expressions contained in a given program using optE.
--
--   >>> optP [Define "func1" ["x","y","z"] [Pen Up,Pen Down]]
--   [Define "func1" ["x","y","z"] [Pen Up,Pen Down]]
--
--   >>> optP [Define "func2" ["x","y","z"] [Pen Up,Move (Add (Num 4) (Num 6)) (Var "y"),Pen Down]]
--   [Define "func2" ["x","y","z"] [Pen Up,Move (Num 10) (Var "y"),Pen Down]]
--
--   >>> optP [Define "nix" ["x", "y", "w", "h"] [Call "line" [Var "x", Var "y", Add (Var "x") (Var "w"), Add (Number 1) (Var "h")],Call "line" [Add (Var "x") (Var "w"), Var "y", Var "x", Add (Number 2) (Number 1)]]]
--   [Define "nix" ["x","y","w","h"] [Call "line" [Var "x",Var "y",Add (Var "x") (Var "w"),Add (Number 1) (Var "h")],Call "line" [Add (Var "x") (Var "w"),Var "y",Var "x",Number 3]]]

optP :: Prog -> Prog
optP [] = []
optP (h:t) = case h of
   Move x y -> Move (optE x) (optE y) :optP t
   Call f args -> Call f (map optE args) :optP t
   Define f args prog -> Define f args (optP prog) :optP t
   otherwise -> h:optP t
