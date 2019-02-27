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

-- | Valuation function for Stmt.--

-- stmt _ _ _ _ = undefined


stmt :: Stmt -> Defs -> World -> Robot -> Result
stmt Shutdown _ _ r       = Done r
stmt Move _ w r           = let p = relativePos Front r
                            in if isClear p w
                                  then OK w (setPos p r)
                                  else Error ("Blocked at: " ++ show p)
stmt PickBeeper _ w r     = let p = getPos r
                            in if hasBeeper p w
                                  then OK (decBeeper p w) (incBag r)
                                  else Error ("No beeper to pick at: " ++ show p)
stmt PutBeeper _ w r      = let p = getPos r
                            in if isEmpty r
                                  then Error ("No beeper to put.")
                                  else OK (incBeeper p w) (decBag r)
stmt (Turn d) _ w r       = OK w (setFacing (cardTurn d (getFacing r)) r)
stmt (Call m) d w r       = case lookup m d of
                                 (Just a) -> stmt a d w r
                                 _        -> Error ("Undefined macro: " ++ m)
stmt (Iterate i s) d w r  = if i > 0
                               then case stmt s d w r of
                                         (OK retW retR) -> stmt (Iterate (i-1) s) d retW retR
                                         (Done retR)  -> Done retR
                                         (Error e)  -> Error e
                               else OK w r
stmt (If q stmt1 stmt2) d w r   = if (test q w r)
                                then stmt stmt1 d w r
                                else stmt stmt2 d w r
stmt (While q s) d w r    = if (test q w r)
                               then case stmt s d w r of
                                    (OK retW retR) -> stmt (While q s) d retW retR
                                    (Done retR)  -> Done retR
                                    (Error e)  -> Error e
                               else OK w r
stmt (Block []) _ w r     = OK w r
stmt (Block (s:ss)) d w r = case stmt s d w r of
                                 (OK retW retR) -> stmt (Block ss) d retW retR
                                 (Done retR)  -> Done retR
                                 (Error e)  -> Error e
-- | Run a Karel program.
prog :: Prog -> World -> Robot -> Result
prog (m,s) w r = stmt s m w r
