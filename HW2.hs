-- | HW2
-- | Created by: Zachary Horine, Griffin Thenell & Jonathan Rich
-- | horinez,thenellg,richj

module HW2 where

-- | Binary trees with nodes labeled by values of an arbitrary type.
data Tree a
   = Node a (Tree a) (Tree a)
   | End
  deriving (Eq,Show)

-- | One step in a path, indicating whether to follow the left subtree (L)
--   or the right subtree (R).
data Step = L | R
  deriving (Eq,Show)

-- | A path is a sequence of steps. Each node in a binary tree can be
--   identified by a path, indicating how to move down the tree starting
--   from the root.
type Path = [Step]

-- | Create a leaf node.
leaf :: a -> Tree a
leaf x = Node x End End

-- | An example tree.
ex :: Tree Int
ex = Node 4 (Node 3 (leaf 2) End)
            (Node 7 (Node 5 End (leaf 6))
                    (leaf 8))


-- | Map a function over a tree. Applies the given function to every label
--   in the tree, preserving the tree's structure.
--
--   >>> mapTree odd End
--   End
--
--   >>> mapTree even (Node 5 (leaf 2) End)
--   Node False (Node True End End) End
--
--   >>> (mapTree not . mapTree even) (Node 5 End (leaf 2))
--   Node True End (Node False End End)
--
--   >>> mapTree (+10) ex
--   Node 14 (Node 13 (Node 12 End End) End) (Node 17 (Node 15 End (Node 16 End End)) (Node 18 End End))
--
--   >>> ex == (mapTree (subtract 27) . mapTree (+27)) ex
--   True
--
mapTree :: (a->b) -> (Tree a) -> (Tree b)
mapTree f (Node a xl xr) = Node (f a) (mapTree f xl) (mapTree f xr)
mapTree f (end) = End


-- | Get the value at the node specified by a path. Returns 'Nothing' if
--   the given path is invalid.
--
--   >>> valueAt [] ex
--   Just 4
--
--   >>> valueAt [L,L] ex
--   Just 2
--
--   >>> valueAt [L,R] ex
--   Nothing
--
--   >>> valueAt [R,L,R] ex
--   Just 6
--
--   >>> valueAt [L,L,L] ex
--   Nothing
--
valueAt :: [Step] -> (Tree b) -> Maybe b
valueAt (_) (End) = Nothing
valueAt ((L):t) (Node b xl xr) = valueAt t xl
valueAt ((R):t) (Node b xl xr) = valueAt t xr
valueAt [] (Node b xl xr) = Just b


-- | Find a path to a node that contains the given value.
--
--   >>> pathTo 3 (leaf 5)
--   Nothing
--
--   >>> pathTo 5 ex
--   Just [R,L]
--
--   >>> pathTo 6 ex
--   Just [R,L,R]
--
--   >>> pathTo 4 ex
--   Just []
--
--   >>> pathTo 10 ex
--   Nothing
--
pathTo :: Eq a => a -> Tree a -> Maybe Path
pathTo search (End) = Nothing
pathTo search (Node a xl xr) =
      if search == a then Just []
         else if ((pathTo search xl) /= Nothing) then ((pathHelper L (pathTo search xl)))
         else ((pathHelper R (pathTo search xr)))


pathHelper :: Step -> Maybe [Step] -> Maybe Path
pathHelper a b = case b of
  Nothing -> Nothing
  Just b' -> Just (a:b')
