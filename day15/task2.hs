module Main where

import           Data.Char (digitToInt, isDigit, ord)
import qualified Data.Map  as Map

data Instruction
  = Insert Int String Int
  | Remove Int String
  deriving (Show, Eq)

replace :: (String, Int) -> [(String, Int)] -> [(String, Int)]
replace x [] = [x]
replace x (h:t)
  | fst x == fst h = x : t
  | otherwise = h : replace x t

delete :: String -> [(String, Int)] -> [(String, Int)]
delete _ [] = []
delete x (h:t)
  | x == fst h = delete x t
  | otherwise = h : delete x t

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

getInstruction :: String -> Instruction
getInstruction = getInstruction' "" "" 0
  where
    getInstruction' :: String -> String -> Int -> String -> Instruction
    getInstruction' lbl cmd val ""
      | cmd == "=" = Insert (hash lbl) lbl val
      | otherwise = Remove (hash lbl) lbl
    getInstruction' lbl cmd val (h:t)
      | h `elem` "=-" = getInstruction' lbl [h] val t
      | isDigit h = getInstruction' lbl cmd (digitToInt h) t
      | otherwise = getInstruction' (lbl ++ [h]) cmd val t

installLenses :: [Instruction] -> Map.Map Int [(String, Int)]
installLenses = installLenses' Map.empty
  where
    installLenses' ::
         Map.Map Int [(String, Int)]
      -> [Instruction]
      -> Map.Map Int [(String, Int)]
    installLenses' acc [] = acc
    installLenses' acc ((Insert box lbl i):t) =
      case Map.lookup box acc of
        Nothing -> installLenses' (Map.insert box [(lbl, i)] acc) t
        Just xs -> installLenses' (Map.insert box (replace (lbl, i) xs) acc) t
    installLenses' acc ((Remove box lbl):t) =
      case Map.lookup box acc of
        Nothing -> installLenses' acc t
        Just xs -> installLenses' (Map.insert box (delete lbl xs) acc) t

focusingPower :: Map.Map Int [(String, Int)] -> Int
focusingPower m = focusingPower' (Map.toList m)
  where
    focusingPower' :: [(Int, [(String, Int)])] -> Int
    focusingPower' []    = 0
    focusingPower' (h:t) = uncurry focusingPower'' h + focusingPower' t
    focusingPower'' :: Int -> [(String, Int)] -> Int
    focusingPower'' = focusingPower''' 1
    focusingPower''' :: Int -> Int -> [(String, Int)] -> Int
    focusingPower''' _ _ [] = 0
    focusingPower''' i n ((s, l):t) =
      (n + 1) * i * l + focusingPower''' (i + 1) n t

main :: IO ()
main = do
  input <- readFile "./day15/input.txt"
  let steps = split (head $ lines input) ','
      instructions = map getInstruction steps
      installed = installLenses instructions
      power = focusingPower installed
  print power
