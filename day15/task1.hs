module Main where

import           Data.Char (ord)

split :: String -> Char -> [String]
split = split' [] ""
  where
    split' :: [String] -> String -> String -> Char -> [String]
    split' acc x "" _ = acc ++ [x]
    split' acc x (c:s) sep
      | c == sep = split' (acc ++ [x]) "" s sep
      | otherwise = split' acc (x ++ [c]) s sep

hash :: String -> Int
hash = hash' 0
  where
    hash' :: Int -> String -> Int
    hash' acc ""    = acc
    hash' acc (h:t) = hash' (17 * (acc + ord h) `mod` 256) t

main :: IO ()
main = do
  input <- readFile "./day15/input.txt"
  let steps = split (head $ lines input) ','
  print $ sum $ map hash steps
