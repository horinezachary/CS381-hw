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

type Prog = [cmd]

data Mode = Up
          | Down
		  deriving (Eq,Show)

data Expr = Var Var
          | Num num
		  | Add Expr Expr
		  deriving (Eq,Show)
		  
data cmd = Move Expr Expr
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
-- | 
-- | Haskell value:
-- |
Line :: cmd
Line = define "Line" ["x1","y1","x2","y2"]
	[Pen Up, Move(Var "x1") (Var "y1"), Pen Down, Move(Var "x2") (Var "y2")]

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
-- | Haskell value:
-- |
Nix :: cmd
Nix = Define "Nix" ["x","y","w","h"]
	Call ["Line" [(Var "x"), (Var "y"),
	Add (Var "x") (Var "w"), Add (Var "y") (Var "h")],
	Call "Line" [(Var "x"), Add (Var "y") (Var "h"),
	Add (Var "x") (Var "w"), (Var "y")]]-- | #6. Define a Haskell function pretty :: Prog -> String that pretty-prints

-- | #6. Define a Haskell function pretty :: Prog -> String that pretty-prints
-- | a MiniLogo program. That is, it transforms the abstract syntax (a Haskell
-- | value) into nicely formatted concrete syntax (a string of characters).
-- | Your pretty-printed program should look similar to the example programs
-- | given above; however, for simplicity you will probably want to print just
-- | one command per line.
-- | In GHCi, you can render a string with newlines by applying the function
-- | putStrLn. So, to pretty-print a program p use: putStrLn (pretty p).

pretty :: Prog -> String
pretty [] = ""
pretty (Pen Up:t) =
pretty (Pen Down:t) =
pretty (Move (x,y):t) =
pretty (Call f arg:t) =
pretty (Define f arg prog:t) =
