module Main where

import           Data.List (transpose)

groups :: [String] -> [[[Char]]]
groups = groups' []
  where
    groups' :: [[Char]] -> [String] -> [[[Char]]]
    groups' acc []     = [reverse acc]
    groups' acc ("":t) = reverse acc : groups' [] t
    groups' acc (h:t)  = groups' (h : acc) t

reflects :: [[Char]] -> [[Char]] -> Bool
reflects a b = and $ zipWith (==) (reverse a) b

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
