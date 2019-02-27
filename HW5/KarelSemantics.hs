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
stmt Shutdown   _ _ r     = Done r
stmt Move _ w r           = OK w (setPos (relativePos Front r))
stmt PickBeeper _ w r     = let p = getPos r
                                 in if hasBeeper p w
                                    then OK (decBeeper p w) (incBag r)
                                    else Error ("No beeper to pick at: " ++ show p)
stmt PutBeeper _ w r      = OK (incBeeper (getPos r)) (decBag r)
stmt Turn    (d) w r      = OK w (setFacing (cardTurn d (getFacing r)) r)
stmt Call    (m) w r      =
stmt Iterate (i,s) w r    =
stmt If      (t,s,st) w r =
stmt While   (t,s) w r    =
stmt Block   (s:st) w r   =
stmt _ _ _ _ = undefined

-- | Run a Karel program.
prog :: Prog -> World -> Robot -> Result
prog (m,s) w r = stmt s m w r
