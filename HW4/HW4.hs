-- | HW4
-- | Created by: Zachary Horine, Griffin Thenell & Jonathan Rich
-- | horinez,thenellg,richj

module HW4 where

import MiniMiniLogo
import Render


--
-- * Semantics of MiniMiniLogo
--

-- NOTE:
--  * MiniMiniLogo.hs defines the abstract syntax of MiniMiniLogo and some
--    functions for generating MiniMiniLogo programs. It contains the type
--    definitions for Mode, Cmd, and Prog.
--  * Render.hs contains code for rendering the output of a MiniMiniLogo
--    program in HTML5. It contains the types definitions for Point and Line.

-- | A type to represent the current state of the pen.
type State = (Mode,Point)

-- | The initial state of the pen.
start :: State
start = (Up,(0,0))

-- | A function that renders the image to HTML. Only works after you have
--   implemented `prog`. Applying `draw` to a MiniMiniLogo program will
--   produce an HTML file named MiniMiniLogo.html, which you can load in
--   your browswer to view the rendered image.
draw :: Prog -> IO ()
draw p = let (_,ls) = prog p start in toHTML ls


-- Semantic domains:
--   * Cmd:  State -> (State, Maybe Line)
--   * Prog: State -> (State, [Line])


-- | Semantic function for Cmd.
--
--   >>> cmd (Pen Down) (Up,(2,3))
--   ((Down,(2,3)),Nothing)
--
--   >>> cmd (Pen Up) (Down,(2,3))
--   ((Up,(2,3)),Nothing)
--
--   >>> cmd (Move 4 5) (Up,(2,3))
--   ((Up,(4,5)),Nothing)
--
--   >>> cmd (Move 4 5) (Down,(2,3))
--   ((Down,(4,5)),Just ((2,3),(4,5)))
--
cmd :: Cmd -> State -> (State, Maybe Line)
cmd (Pen a) (_, (x,y)) = ((a,(x,y)),Nothing)
cmd (Move a b) (c, (x,y)) = case c of
        Up -> ((c,(a,b)),Nothing)
        Down -> ((c,(a,b)),Just ((x,y),(a,b)))

-- | Semantic function for Prog.
--
--   >>> prog (nix 10 10 5 7) start
--   ((Down,(15,10)),[((10,10),(15,17)),((10,17),(15,10))])
--
--   >>> prog (steps 2 0 0) start
--   ((Down,(2,2)),[((0,0),(0,1)),((0,1),(1,1)),((1,1),(1,2)),((1,2),(2,2))])
prog :: Prog -> State -> (State, [Line])
prog x y = case x of
  [] -> (y, [])
  (l:ls) -> case cmd l y of
    (a, Nothing) -> prog ls a
    (a, Just z) -> (\(x, ls) -> (x, z:ls)) (prog ls a)

--
-- * Extra credit
--

-- *Helper function
-- | Modified version of line definition from homework 3 to make drawing easier
line:: Int -> Int -> Int -> Int -> Prog
line x1 y1 x2 y2 = [Pen Up, Move x1 y1, Pen Down, Move x2 y2, Pen Up]


-- | This should be a MiniMiniLogo program that draws an amazing picture.
--   Add as many helper functions as you want.

--   Making the asteroid alien

-- * Actual function

amazing :: Prog
--amazing = undefined
-- Would have used steps instead but steps increment by 1 not 2
amazing = line 2 4 2 10 ++ line 2 10 4 10 ++ line 4 10 4 12 ++ line 4 12 6 12 ++ line 6 12 6 14 ++ line 6 14 8 14 ++ line 8 14 8 16 ++ line 6 16 8 16 ++ line 8 16 8 18 ++ line 8 18 6 18 ++ line 6 18 6 16
          ++ line 8 16 10 16 ++ line 10 16 10 14 ++ line 10 14 16 14 ++ line 16 14 16 16 ++ line 16 16 20 16 ++ line 20 16 20 18 ++ line 20 18 18 18 ++ line 18 18 18 14
          ++ line 18 14 20 14 ++ line 20 14 20 12 ++ line 20 12 22 12 ++ line 22 12 22 10 ++ line 22 10 24 10 ++ line 24 10 24 4 ++ line 24 4 22 4 ++ line 22 4 22 8
          ++ line 22 8 20 8 ++ line 20 8 20 4 ++ line 20 4 14 4 ++ line 14 4 14 2 ++ line 14 2 18 2 ++ line 18 2 18 6 ++ line 18 6 8 6 ++ line 8 6 8 2 ++ line 8 2 12 2
          ++ line 12 2 12 4 ++ line 12 4 6 4 ++ line 6 4 6 8 ++ line 6 8 4 8 ++ line 4 8 4 4 ++ line 4 4 2 4
          ++ box 16 10 ++ box 8 10
