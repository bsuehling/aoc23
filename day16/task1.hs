module Main where

import qualified Data.Map   as Map
import           Data.Maybe (fromMaybe)

type BeamMap = Map.Map (Int, Int) String

at :: [[a]] -> (Int, Int) -> Maybe a
at xs (i, j)
  | i < 0 || j < 0 || i >= length xs || j >= length (head xs) = Nothing
  | otherwise = Just (xs !! i !! j)

newDirection :: Char -> Char -> Either Char (Char, Char)
newDirection d p
  | p == '.' = Left d
  | d `elem` "RL" && p == '-' || d `elem` "DU" && p == '|' = Left d
  | d == 'R' && p == '\\' || d == 'L' && p == '/' = Left 'D'
  | d == 'R' && p == '/' || d == 'L' && p == '\\' = Left 'U'
  | d == 'D' && p == '\\' || d == 'U' && p == '/' = Left 'R'
  | d == 'D' && p == '/' || d == 'U' && p == '\\' = Left 'L'
  | d `elem` "RL" && p == '|' = Right ('D', 'U')
  | d `elem` "DU" && p == '-' = Right ('R', 'L')

newPos :: (Int, Int) -> Char -> (Int, Int)
newPos (i, j) 'R' = (i, j + 1)
newPos (i, j) 'L' = (i, j - 1)
newPos (i, j) 'D' = (i + 1, j)
newPos (i, j) 'U' = (i - 1, j)

energize :: [[Char]] -> BeamMap
energize xs =
  let acc = replicate (length xs) (replicate (length $ head xs) "")
   in energize' (0, 0) 'R' Map.empty xs
  where
    energize' :: (Int, Int) -> Char -> BeamMap -> [[Char]] -> BeamMap
    energize' p d acc xs =
      case xs `at` p of
        Nothing -> acc
        Just q ->
          let dir = fromMaybe "" $ Map.lookup p acc
              acc' = Map.insert p [d] acc
           in if d `elem` dir
                then acc'
                else case newDirection d q of
                       Left a -> energize' (newPos p a) a acc' xs
                       Right (a, b) ->
                         let acc'' = energize' (newPos p a) a acc' xs
                          in energize' (newPos p b) b acc'' xs

main :: IO ()
main = do
  input <- readFile "./day16/input.txt"
  let contraption = lines input
      energized = energize contraption
      result = Map.size energized
  print result
