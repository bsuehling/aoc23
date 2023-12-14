module Main where

import           Data.List (transpose)
import qualified Data.Map  as Map

slide :: [Char] -> [Char]
slide = slide' 0 0
  where
    slide' :: Int -> Int -> [Char] -> [Char]
    slide' r s [] = replicate r 'O' ++ replicate s '.'
    slide' r s (h:t)
      | h == '#' = replicate r 'O' ++ replicate s '.' ++ '#' : slide' 0 0 t
      | h == 'O' = slide' (r + 1) s t
      | otherwise = slide' r (s + 1) t

cycling :: [[Char]] -> [[Char]]
cycling xs =
  let north = map slide $ transpose xs
      west = map slide $ transpose north
      south = map slide $ transpose $ reverse west
      east = map slide $ transpose $ reverse south
   in reverse $ map reverse east

cycleLoop :: Int -> [[Char]] -> [[Char]]
cycleLoop = cycleLoop' Map.empty 0
  where
    cycleLoop' :: Map.Map [[Char]] Int -> Int -> Int -> [[Char]] -> [[Char]]
    cycleLoop' m i n p
      | i == n = p
      | otherwise =
        let i' = i + 1
            p' = cycling p
            m' = Map.insert p' i' m
         in case Map.lookup p' m of
              Nothing -> cycleLoop' m' (i + 1) n p'
              Just j ->
                let i'' = i' + ((i' - j) * ((n - i') `div` (i' - j)))
                 in cycleLoop' Map.empty i'' n p'

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
  let platform = lines input
      cycled = cycleLoop 1_000_000_000 platform
      load = sum $ map getLoad $ transpose cycled
  print load
