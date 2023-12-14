module Main where

import           Data.List (transpose)

slide :: [Char] -> [Char]
slide = slide' 0 0
  where
    slide' :: Int -> Int -> [Char] -> [Char]
    slide' r s [] = replicate r 'O' ++ replicate s '.'
    slide' r s (h:t)
      | h == '#' = replicate r 'O' ++ replicate s '.' ++ '#' : slide' 0 0 t
      | h == 'O' = slide' (r + 1) s t
      | otherwise = slide' r (s + 1) t

getLoad :: [Char] -> Int
getLoad xs = getLoad' 1 (reverse xs)
  where
    getLoad' :: Int -> [Char] -> Int
    getLoad' _ [] = 0
    getLoad' i (x:xs)
      | x == 'O' = i + getLoad' (i + 1) xs
      | otherwise = getLoad' (i + 1) xs

main :: IO ()
main = do
  input <- readFile "./day14/input.txt"
  let platform = transpose $ lines input
      slided = map slide platform
      load = sum $ map (getLoad . slide) platform
  print load
