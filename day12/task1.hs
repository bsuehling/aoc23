module Main where

split :: String -> Char -> [String]
split = split' [] ""
  where
    split' :: [String] -> String -> String -> Char -> [String]
    split' acc x "" _ = acc ++ [x]
    split' acc x (c:s) sep
      | c == sep = split' (acc ++ [x]) "" s sep
      | otherwise = split' acc (x ++ [c]) s sep

getRecords :: [[String]] -> [([Char], [Int])]
getRecords = map (\h -> (head h, map read $ split (last h) ','))

arrangements :: [Char] -> [Int] -> Int
arrangements = arrangements' (-1)
  where
    arrangements' :: Int -> [Char] -> [Int] -> Int
    arrangements' x springs []
      | x > 0 =
        case springs of
          '#':t -> arrangements' (x - 1) t []
          '?':t -> arrangements' (x - 1) t []
          _     -> 0
      | otherwise =
        case springs of
          []    -> 1
          '#':t -> 0
          _:t   -> arrangements' x t []
    arrangements' _ [] _ = 0
    arrangements' x ('#':springs) recs@(r:records)
      | x == 0 = 0
      | x == (-1) = arrangements' (r - 1) springs records
      | otherwise = arrangements' (x - 1) springs recs
    arrangements' x ('.':springs) recs@(r:records)
      | x > 0 = 0
      | otherwise = arrangements' (-1) springs recs
    arrangements' x ('?':springs) records =
      arrangements' x ('#' : springs) records +
      arrangements' x ('.' : springs) records

main :: IO ()
main = do
  input <- readFile "./day12/input.txt"
  let records = getRecords $ map words $ lines input
      result = sum $ map (uncurry arrangements) records
  print result
