module Main where

import           Data.List (transpose)

expand :: [[Char]] -> ([Int], [Int])
expand x = (expand' x, expand' $ transpose x)

expand' :: [[Char]] -> [Int]
expand' [] = []
expand' (h:t)
  | '#' `elem` h = 1 : expand' t
  | otherwise = 1_000_000 : expand' t

findGalaxies :: [[Char]] -> ([Int], [Int]) -> [(Int, Int)]
findGalaxies = findGalaxies' 0

findGalaxies' :: Int -> [[Char]] -> ([Int], [Int]) -> [(Int, Int)]
findGalaxies' _ [] stretch = []
findGalaxies' row (h:t) stretch =
  [ (sum $ take (row + 1) $ fst stretch, sum $ take (snd x + 1) $ snd stretch)
  | x <- zip h [0 ..]
  , fst x == '#'
  ] ++
  findGalaxies' (row + 1) t stretch

getDistances :: [(Int, Int)] -> [Int]
getDistances [] = []
getDistances (h:t) =
  map (\x -> abs (fst h - fst x) + abs (snd h - snd x)) t ++ getDistances t

main :: IO ()
main = do
  input <- readFile "./day11/input.txt"
  let sky = lines input
      stretch = expand sky
      galaxies = findGalaxies sky stretch
      distance = sum $ getDistances galaxies
  print distance
