module HW1 where


-- | Integer-labeled binary trees.
data Tree
   = Node Int Tree Tree   -- ^ Internal nodes
   | Leaf Int             -- ^ Leaf nodes
  deriving (Eq,Show)


-- | An example binary tree, which will be used in tests.
t1 :: Tree
t1 = Node 1 (Node 2 (Node 3 (Leaf 4) (Leaf 5))
                    (Leaf 6))
            (Node 7 (Leaf 8) (Leaf 9))

-- | Another example binary tree, used in tests.
t2 :: Tree
t2 = Node 6 (Node 2 (Leaf 1) (Node 4 (Leaf 3) (Leaf 5)))
            (Node 8 (Leaf 7) (Leaf 9))

t3 :: Tree
t3 = Node 6 (Leaf 6) (Leaf 7)


-- | The integer at the left-most node of a binary tree.
--
--   >>> leftmost (Leaf 3)
--   3
--
--   >>> leftmost (Node 5 (Leaf 6) (Leaf 7))
--   6
--
--   >>> leftmost t1
--   4
--
--   >>> leftmost t2
--   1
--
leftmost :: Tree -> Int
leftmost (Leaf a) = a
leftmost (Node x y z) = leftmost y



-- | The integer at the right-most node of a binary tree.
--
--   >>> rightmost (Leaf 3)
--   3
--
--   >>> rightmost (Node 5 (Leaf 6) (Leaf 7))
--   7
--
--   >>> rightmost t1
--   9
--
--   >>> rightmost t2
--   9
--
rightmost :: Tree -> Int
rightmost (Leaf a) = a
rightmost (Node x y z) = rightmost z

-- | Get the maximum integer from a binary tree.
--
--   >>> maxInt (Leaf 3)
--   3
--
--   >>> maxInt (Node 5 (Leaf 4) (Leaf 2))
--   5
--
--   >>> maxInt (Node 5 (Leaf 7) (Leaf 2))
--   7
--
--   >>> maxInt t1
--   9
--
--   >>> maxInt t2
--   9
--
maxInt :: Tree -> Int
maxInt (Leaf a) = a
maxInt (Node x y z) = max x (max (maxInt y) (maxInt z))

-- | Get the minimum integer from a binary tree.
--
--   >>> minInt (Leaf 3)
--   3
--
--   >>> minInt (Node 2 (Leaf 5) (Leaf 4))
--   2
--
--   >>> minInt (Node 5 (Leaf 4) (Leaf 7))
--   4
--
--   >>> minInt t1
--   1
--
--   >>> minInt t2
--   1
--
minInt :: Tree -> Int
minInt (Leaf a) = a
minInt (Node x y z) = min x (min (minInt y) (minInt z))

-- | Get the sum of the integers in a binary tree.
--
--   >>> sumInts (Leaf 3)
--   3
--
--   >>> sumInts (Node 2 (Leaf 5) (Leaf 4))
--   11
--
--   >>> sumInts t1
--   45
--
--   >>> sumInts (Node 10 t1 t2)
--   100
--
sumInts :: Tree -> Int
sumInts (Leaf a) = a
sumInts (Node x y z) = x + (sumInts y) + (sumInts z)


-- | The list of integers encountered by a pre-order traversal of the tree.
--
--   >>> preorder (Leaf 3)
--   [3]
--
--   >>> preorder (Node 5 (Leaf 6) (Leaf 7))
--   [5,6,7]
--
--   >>> preorder t1
--   [1,2,3,4,5,6,7,8,9]
--
--   >>> preorder t2
--   [6,2,1,4,3,5,8,7,9]
--
preorder :: Tree -> [Int]
preorder (Leaf a) = [a]
preorder (Node x y z) = [x] ++ (preorder y) ++ (preorder z)



-- | The list of integers encountered by an in-order traversal of the tree.
--
--   >>> inorder (Leaf 3)
--   [3]
--
--   >>> inorder (Node 5 (Leaf 6) (Leaf 7))
--   [6,5,7]
--
--   >>> inorder t1
--   [4,3,5,2,6,1,8,7,9]
--
--   >>> inorder t2
--   [1,2,3,4,5,6,7,8,9]
--
inorder :: Tree -> [Int]
inorder (Leaf a) = [a]
inorder (Node x y z) = (inorder y) ++ [x] ++ (inorder z)


-- | Check whether a binary tree is a binary search tree.
--
--   >>> isBST (Leaf 3)
--   True
--
--   >>> isBST (Node 5 (Leaf 6) (Leaf 7))
--   False
--
--   >>> isBST t1
--   False
--
--   >>> isBST t2
--   True
--
isBST :: Tree -> Bool
isBST (Leaf a) = True
isBST (Node x y z) = ((isBST y) && (isBST z)) && -- The left sub tree and right subtree are BST
      ((x > getVal y) && (x < getVal z)) -- Make sure that the left node is less and the right is more

getVal :: Tree -> Int
getVal (Leaf a) = a
getVal (Node x y z) = x


-- | Check whether a number is contained in a binary search tree.
--   (You may assume that the given tree is a binary search tree.)
--
--   >>> inBST 2 (Node 5 (Leaf 2) (Leaf 7))
--   True
--
--   >>> inBST 3 (Node 5 (Leaf 2) (Leaf 7))
--   False
--
--   >>> inBST 4 t2
--   True
--
--   >>> inBST 10 t2
--   False
--
inBST :: Int -> Tree -> Bool
inBST b (Leaf a) = a == b
inBST k (Node x y z) = inBST k y || inBST k z || x == k




-- | This is jon's grave yard of functions that could have been but alas are not
--maxInt :: Tree -> Int
--maxInt (Leaf a) = a
--maxInt (Node x y z) =
--  if maxInt y > maxInt z
    --then if x > maxInt y
--      then x
      --else maxInt y
    --else if x > maxInt z
    --then x
    --else maxInt z
