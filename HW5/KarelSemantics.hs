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
test (Not a)    w r = not (test a w r)
test (Facing d) _ r = d == getFacing r
test (Clear e)  w r = isClear (relativePos e r) w
test (Beeper)   w r = hasBeeper (getPos r) w
test (Empty)    w r = isEmpty r


-- | Valuation function for Stmt.
stmt :: Stmt -> Defs -> World -> Robot -> Result
stmt Shutdown d w r       = Done r
stmt Move d w r           = let p = relativePos Front r
                            in if isClear p w
                                  then OK w (setPos p r)
                                  else Error ("Blocked at: " ++ show p)
stmt PickBeeper d w r     = let p = getPos r
                            in if hasBeeper p w
                                  then OK (decBeeper p w) (incBag r)
                                  else Error ("No beeper to pick at: " ++ show p)
stmt PutBeeper d w r      = let p = getPos r
                            in if isEmpty r
                                  then Error ("No beeper to put.")
                                  else OK (incBeeper p w) (decBag r)
stmt (Turn dir) d w r     = OK w (setFacing (cardTurn dir (getFacing r)) r)
stmt (Call m) d w r       = case lookup m d of
                                 (Just a) -> stmt a d w r
                                 _        -> Error ("Undefined macro: " ++ m)
stmt (Iterate i s) d w r  = if i > 0
                               then case stmt s d w r of
                                         (OK w' r') -> stmt (Iterate (i-1) s) d w' r'
                                         (Done r')  -> Done r'
                                         (Error e')  -> Error e'
                               else OK w r
stmt (If q st1 st2) d w r = if (test q w r)
                                then stmt st1 d w r
                                else stmt st2 d w r
stmt (While q s) d w r    = if (test q w r)
                               then case stmt s d w r of
                                    (OK w' r') -> stmt (While q s) d w' r'
                                    (Done r')  -> Done r'
                                    (Error e')  -> Error e'
                               else OK w r
stmt (Block []) d w r     = OK w r
stmt (Block (s:ss)) d w r = case stmt s d w r of
                                 (OK w' r') -> stmt (Block ss) d w' r'
                                 (Done r')  -> Done r'
                                 (Error e')  -> Error e'


-- | Run a Karel program.
prog :: Prog -> World -> Robot -> Result
prog (m,s) w r = stmt s m w r
