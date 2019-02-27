-- | HW5
-- | Created by: Griffin Thenell, Zach Horine & Jonathan Rich
-- | horinez,thenellg,richj

module KarelSemantics where

import Prelude hiding (Either(..))
import Data.Function (fix)

import KarelSyntax
import KarelState


-- | Valuation function for Test.
test :: Test -> World -> Robot -> Bool
test (Not a) b c     = not (test a b c)
test (Facing d) _ c = d == getFacing c
test (Clear e) b c  = isClear (relativePos e c) b
test (Beeper) b c    = hasBeeper (getPos c) b
test (Empty) _ c     = isEmpty c

-- | Valuation function for Stmt.
stmt :: Stmt -> Defs -> World -> Robot -> Result
stmt Shutdown _ _ r     = Done r
stmt Move d w r             = if test (Clear Front) w r
                                 then OK w (setPos (relativePos Front r))
                                 else Error ("Blocked at:" ++ show (relativePos Front r))
stmt PickBeeper _ w r       = let p = getPos r
                              in if hasBeeper p w
                                 then OK (decBeeper p w) (incBag r)
                                 else Error ("No beeper to pick at: " ++ show p)
stmt PutBeeper d w r        = if isEmpty r
                                 then Error ("No beeper to put.")
                                 else OK (incBeeper (getPos r) w) (decBag r)
stmt (Turn d) d w r         = OK w (setFacing (cardTurn d (getFacing r)) r)
stmt (Call m) d w r         =
stmt (Iterate 0 s) d w r    = OK w r
stmt (Iterate i s) d w r    = case stmt s d w r of
                                 OK retW retR -> stmt (Iterate (i-1) s) d retW retR
                                 Error e -> Error e
stmt (If q s1 s2) d w r     = if test q w r
                                 then stmt s1 d w r
                                 else stmt s2 d w r
stmt (While q s) d w r      = if test q w r
                                 then OK w r
                                 else case stmt s d w r of
                                    OK retW retR -> stmt (while q s) d retW retR
                                    Error e -> Error e
stmt (Block []) d w r       = OK w r
stmt (Block (s:st)) d w r   =
stmt _ _ _ _ = undefined

-- | Run a Karel program.
prog :: Prog -> World -> Robot -> Result
prog (m,s) w r = stmt s m w r
