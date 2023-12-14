module Main where

import           Data.List (transpose)

almostEq :: [Char] -> [Char] -> (Bool, Bool)
almostEq = almostEq' True
  where
    almostEq' :: Bool -> [Char] -> [Char] -> (Bool, Bool)
    almostEq' b [] [] = (True, b)
    almostEq' b (x:xs) (y:ys)
      | x == y = almostEq' b xs ys
      | b = almostEq' False xs ys
      | otherwise = (False, False)

count :: Eq a => [a] -> a -> Int
count [] _ = 0
count (h:t) x
  | h == x = 1 + count t x
  | otherwise = count t x

groups :: [String] -> [[[Char]]]
groups = groups' []
  where
    groups' :: [[Char]] -> [String] -> [[[Char]]]
    groups' acc []     = [reverse acc]
    groups' acc ("":t) = reverse acc : groups' [] t
    groups' acc (h:t)  = groups' (h : acc) t

reflects :: [[Char]] -> [[Char]] -> Bool
reflects a b =
  let refl = zipWith almostEq (reverse a) b
   in all fst refl && count (map snd refl) False == 1

reflection :: [[Char]] -> Int
reflection x = 100 * reflection' [] x + reflection' [] (transpose x)
  where
    reflection' :: [[Char]] -> [[Char]] -> Int
    reflection' _ [] = 0
    reflection' [] (h:t) = reflection' [h] t
    reflection' a b@(h:t)
      | reflects a b = length a
      | otherwise = reflection' (a ++ [h]) t

main :: IO ()
main = do
  input <- readFile "./day13/input.txt"
  let patterns = groups $ lines input
      result = sum $ map reflection patterns
  print result
