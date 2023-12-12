module Main where

import           Control.Concurrent.STM (lengthTBQueue)
import           Debug.Trace

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

findPath :: [[Char]] -> (Int, Int) -> [(Int, Int)]
findPath pipes s@(r, c)
  | at pipes (r - 1) c `elem` "F7|" = findPath' [s] 'U' pipes (r - 1, c)
  | at pipes (r + 1) c `elem` "LJ|" = findPath' [s] 'D' pipes (r + 1, c)
  | otherwise = findPath' [s] 'L' pipes (r, c - 1)

findPath' :: [(Int, Int)] -> Char -> [[Char]] -> (Int, Int) -> [(Int, Int)]
findPath' path d pipes p@(r, c)
  | at pipes r c == 'S' = p : path
  | otherwise =
    let ds = findMatches pipes p
        dNew = findDNew d ds
     in findPath' (p : path) dNew pipes $ findPosNew dNew p

getArea :: [(Int, Int)] -> [[Char]] -> Int
getArea = getArea' 0 0

getArea' :: Int -> Int -> [(Int, Int)] -> [[Char]] -> Int
getArea' n _ _ [] = n
getArea' n row path (p:pipes) =
  getArea' (n + xray row (length p) path) (row + 1) path pipes

pos :: Eq a => a -> [a] -> Int
pos = pos' 0

pos' :: Eq a => Int -> a -> [a] -> Int
pos' _ _ [] = -2
pos' acc x (h:t)
  | x == h = acc
  | otherwise = pos' (acc + 1) x t

findD' :: Int -> Int -> Int -> Int -> Int -> Int
findD' x xu xd d len
  | adj x xu len && adj x xd len = 2
  | adj x xu len = -1
  | adj x xd len = 1
  | otherwise = d

adj :: Int -> Int -> Int -> Bool
adj x y len = abs (x - y) == 1 || abs (x - y - len) == 1

xray :: Int -> Int -> [(Int, Int)] -> Int
xray = xray' 0 0 0 0

xray' :: Int -> Int -> Int -> Int -> Int -> Int -> [(Int, Int)] -> Int
xray' acc cuts d col row len path
  -- | trace
  --     (show row ++
  --      ", " ++
  --      show col ++ ", " ++ show acc ++ ", " ++ show cuts ++ ", " ++ show d)
  --     False = undefined
  | col + 1 == len = acc
  | (row, col) `elem` path =
    let x = pos (row, col) path
        xu = pos (row - 1, col) path
        xd = pos (row + 1, col) path
        d'
          -- trace
          --   ("x: " ++
          --    show x ++
          --    ", xu: " ++ show xu ++ ", xd: " ++ show xd ++ ", l: " ++ show len) $
         = findD' x xu xd d $ length path
        cuts' =
          if d' == 2 || abs (d - d') == 2
            then cuts + 1
            else cuts
        d'' =
          if cuts' == cuts
            then d'
            else 0
     in xray' acc cuts' d'' (col + 1) row len path
  | odd cuts = xray' (acc + 1) cuts d (col + 1) row len path
  | otherwise = xray' acc cuts d (col + 1) row len path

main :: IO ()
main = do
  input <- readFile "./day10/test.txt"
  let pipes :: [[Char]] = lines input
      start = findStart pipes
      path = findPath pipes start
  -- print path
  let area = getArea path pipes
  print area
