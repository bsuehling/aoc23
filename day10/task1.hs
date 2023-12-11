module Main where

findStart :: [[Char]] -> (Int, Int)
findStart = findStart' (0, 0)

at :: [[Char]] -> Int -> Int -> Char
at xs a b
  | a < 0 || a >= length xs || b < 0 || b >= length (head xs) = '.'
  | otherwise = (xs !! a) !! b

findStart' :: (Int, Int) -> [[Char]] -> (Int, Int)
findStart' _ [] = (-1, -1)
findStart' (row, _) ([]:x) = findStart' (row + 1, 0) x
findStart' pos@(row, col) ((h:t):x)
  | h == 'S' = pos
  | otherwise = findStart' (row, col + 1) (t : x)

findMatches :: [[Char]] -> (Int, Int) -> [Char]
findMatches pipes (r, c) =
  map fst $
  filter
    snd
    [ ('U', at pipes (r - 1) c `elem` "F7|S" && at pipes r c `elem` "LJ|")
    , ('D', at pipes (r + 1) c `elem` "LJ|S" && at pipes r c `elem` "F7|")
    , ('L', at pipes r (c - 1) `elem` "FL-S" && at pipes r c `elem` "7J-")
    , ('R', at pipes r (c + 1) `elem` "7J-S" && at pipes r c `elem` "FL-")
    ]

findDNew :: Char -> [Char] -> Char
findDNew d ds
  | d == 'U' = head $ filter ('D' /=) ds
  | d == 'D' = head $ filter ('U' /=) ds
  | d == 'L' = head $ filter ('R' /=) ds
  | otherwise = head $ filter ('L' /=) ds

findPosNew :: Char -> (Int, Int) -> (Int, Int)
findPosNew d (r, c)
  | d == 'U' = (r - 1, c)
  | d == 'D' = (r + 1, c)
  | d == 'L' = (r, c - 1)
  | otherwise = (r, c + 1)

getPipeLength :: [[Char]] -> (Int, Int) -> Int
getPipeLength pipes (r, c)
  | at pipes (r - 1) c `elem` "F7|" = getPipeLength' 1 'U' pipes (r - 1, c)
  | at pipes (r + 1) c `elem` "LJ|" = getPipeLength' 1 'D' pipes (r + 1, c)
  | otherwise = getPipeLength' 1 'L' pipes (r, c - 1)

getPipeLength' :: Int -> Char -> [[Char]] -> (Int, Int) -> Int
getPipeLength' n d pipes p@(r, c)
  | at pipes r c == 'S' = n
  | otherwise =
    let ds = findMatches pipes p
        dNew = findDNew d ds
        posNew = findPosNew dNew p
     in getPipeLength' (n + 1) dNew pipes posNew

main :: IO ()
main = do
  input <- readFile "./day10/input.txt"
  let pipes :: [[Char]] = lines input
      start = findStart pipes
      len = getPipeLength pipes start
      result = len `div` 2
  print result
