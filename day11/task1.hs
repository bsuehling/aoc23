module Main where

import           Data.List (transpose)

expand :: [[Char]] -> [[Char]]
expand x = transpose $ expand' $ transpose $ expand' x

expand' :: [[Char]] -> [[Char]]
expand' [] = []
expand' (h:t)
  | '#' `elem` h = h : expand' t
  | otherwise = h : h : expand' t

findGalaxies :: [[Char]] -> [(Int, Int)]
findGalaxies = findGalaxies' 0

findGalaxies' :: Int -> [[Char]] -> [(Int, Int)]
findGalaxies' _ [] = []
findGalaxies' row (h:t) =
  [(row, snd x) | x <- zip h [0 ..], fst x == '#'] ++ findGalaxies' (row + 1) t

getDistances :: [(Int, Int)] -> [Int]
getDistances [] = []
getDistances (h:t) =
  map (\x -> abs (fst h - fst x) + abs (snd h - snd x)) t ++ getDistances t

main :: IO ()
main = do
  input <- readFile "./day11/input.txt"
  let sky = expand $ lines input
      galaxies = findGalaxies sky
      distance = sum $ getDistances galaxies
  print distance
