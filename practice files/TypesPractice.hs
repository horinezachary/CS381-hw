module TypesPractice where

data Result = OK Int | Error
  deriving (Eq,Show)

isOK :: Result -> Bool
isOK (OK _) = True
isOK Error  = False

add :: Int -> Result -> Result
add i (OK j) = OK (i+j)
add _ Error  = Error

-- From the Prelude:
--   map :: (a -> b) -> [a] -> [b]
--   (.) :: (b -> c) -> (a -> b) -> a -> c

-- Write the type of the following expressions,
-- or write "type error" if it is not type correct:

ex1 = OK
-- Int -> Result
ex2 = Error
-- Result
ex3 = isOK Error
-- Bool
-- ex4 = isOK 3
-- type Error
-- ex5 = isOK OK 3
-- type Error. needs parenthesis around OK 3
-- Int -> Bool
ex6 = isOK . OK
-- Int -> Bool (.) == (a->b)->(b->c)-> a->c (cuts out middle man)
ex7 = add 3
--only passes one var, so returns a function from Result -> Result
ex8 = add 3 Error
--Result
--ex9 = add 3 OK
--type Error Int -> Int -> Result -> Result
ex10 = add 3 (OK 4)
--Result
ex11 = map OK
--[Int]->[Result]
ex12 = map isOK
--[Result]->[Bool]
ex13 = map (add 3)
--[Result]->[Result]
ex14 = map (add 3 . OK)
--[Int]->[Result]
ex15 = map (add 3) . map OK
--[Int]->[Result]
