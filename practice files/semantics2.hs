-- Sample Problem 1:
-- i ::= (any integer)
-- s ::= inc i
--    |  reset
-- p ::= s ; p
--    |  e

data Stmt = Inc Int
          | Reset
      deriving(Eq,Show)

type P = [Stmt]

-- semantic domain: int -> int

stmt :: Stmt -> Int -> Int
stmt (Inc i) n = n+i
stmt (Reset) _ = 0

stmts :: [Stmt] -> Int -> Int
stmts [] n = n
stmts (h:t) n = stmts t (stmt h n)


--Sample Problem 2:

data Cmd = Gas
         | Brake
         | Turn
      deriving(Eq, Show)

type Prog = [Cmd]

type Pos = Int
type Speed = Int
data Dir = Forward
         | Backward
      deriving(Eq,Show)

type State = (Pos, Speed, Dir)

data Result = OK State
            | Crash Pos
      deriving(Eq,Show)

-- semantic domain: State -> Result

cmd:: Cmd -> State -> Result
cmd Turn (p, 0, Forward) = OK (p, 0, Backward)
cmd Turn (p, 0, Backward) = OK (p, 0, Forward)
cmd Turn (p, s, d) = Crash p

cmd Brake (p, 0, d)  = OK (p, 0, d)
cmd Brake (p, s, Forward) = OK (p+s, s-1, Forward)
cmd Brake (p, s, Backward) = OK (p-s, s-1, Backward)

cmd Gas (p, s, Forward) = OK (p+s, s+1, Forward)
cmd Gas (p, s, Backward) = OK (p-s, s+1, Backward)

prog:: [Cmd] -> State -> Result
prog [] s = OK s
prog (h:t) s = case cmd h s of
                  OK s' -> prog t s'
                  Crash p' -> Crash p'
