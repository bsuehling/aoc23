module Main where

stringToInts :: String -> [[Int]]
stringToInts = map (map read . words) . lines

diffs :: [Int] -> [Int]
diffs (a:b:t) = (b - a) : diffs (b : t)
diffs x       = []

allZero :: [Int] -> Bool
allZero = foldr (\h -> (&&) (h == 0)) True

predictValue :: [Int] -> Int
predictValue x
  | allZero x = 0
  | otherwise = last x + predictValue (diffs x)

main :: IO ()
main = do
  input <- readFile "./day09/input.txt"
  let histories = stringToInts input
  let result = sum . map predictValue $ histories
  print result
