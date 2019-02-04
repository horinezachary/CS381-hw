-- | HW3
-- | Created by: Zachary Horine, Griffin Thenell & Jonathan Rich
-- | horinez,thenellg,richj

module HW3 where

type Num = Int
data Var = String
data Macro = String

type Prog = [Cmd]

data Mode = Up
          | Down
          deriving (Eq,Show)

data Expr = Var Var
          | Num num
          | Add expr expr
          deriving (Eq,Show)

data Cmd = Pen Mode
         | Move (expr , expr)
         | Define Macro [Var] Prog
         | Call Macro [Expr]
         deriving (Eq,Show)






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
steps n = steps (n-1) ++ [Move (n-1) (n), Move (n) (n)]
