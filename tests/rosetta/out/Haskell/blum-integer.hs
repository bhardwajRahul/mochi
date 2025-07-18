-- Generated by Mochi compiler v0.10.26 on 2025-07-16T09:30:25Z
-- Code generated by Mochi compiler; DO NOT EDIT.
{-# LANGUAGE DeriveGeneric #-}

module Main where

import Data.List (intercalate, isInfixOf, isPrefixOf)
import qualified Data.List as List
import Data.Maybe (fromMaybe)

forLoop :: Int -> Int -> (Int -> Maybe a) -> Maybe a
forLoop start end f = go start
  where
    go i
      | i < end =
          case f i of
            Just v -> Just v
            Nothing -> go (i + 1)
      | otherwise = Nothing

whileLoop :: (() -> Bool) -> (() -> Maybe a) -> Maybe a
whileLoop cond body = go ()
  where
    go _
      | cond () =
          case body () of
            Just v -> Just v
            Nothing -> go ()
      | otherwise = Nothing

avg :: (Integral a) => [a] -> a
avg xs
  | null xs = 0
  | otherwise = div (sum xs) (fromIntegral (length xs))

data MGroup k a = MGroup {key :: k, items :: [a]} deriving (Show)

_group_by :: (Ord k) => [a] -> (a -> k) -> [MGroup k a]
_group_by src keyfn =
  let go [] m order = (m, order)
      go (x : xs) m order =
        let k = keyfn x
         in case Map.lookup k m of
              Just is -> go xs (Map.insert k (is ++ [x]) m) order
              Nothing -> go xs (Map.insert k [x] m) (order ++ [k])
      (m, order) = go src Map.empty []
   in [MGroup k (fromMaybe [] (Map.lookup k m)) | k <- order]

_indexString :: String -> Int -> String
_indexString s i =
  let idx = if i < 0 then i + length s else i
   in if idx < 0 || idx >= length s
        then error "index out of range"
        else [s !! idx]

_append :: [a] -> a -> [a]
_append xs x = xs ++ [x]

_input :: IO String
_input = getLine

_readInput :: Maybe String -> IO String
_readInput Nothing = getContents
_readInput (Just p)
  | null p || p == "-" = getContents
  | otherwise = readFile p

_writeOutput :: Maybe String -> String -> IO ()
_writeOutput mp text = case mp of
  Nothing -> putStr text
  Just p
    | null p || p == "-" -> putStr text
    | otherwise -> writeFile p text

_split :: Char -> String -> [String]
_split _ "" = [""]
_split d s =
  let (h, t) = break (== d) s
   in h : case t of
        [] -> []
        (_ : rest) -> _split d rest

_parseCSV :: String -> Bool -> Char -> [Map.Map String String]
_parseCSV text header delim =
  let ls = filter (not . null) (lines text)
   in if null ls
        then []
        else
          let heads =
                if header
                  then _split delim (head ls)
                  else ["c" ++ show i | i <- [0 .. length (_split delim (head ls)) - 1]]
              start = if header then 1 else 0
              row line =
                let parts = _split delim line
                 in Map.fromList
                      [ (heads !! j, if j < length parts then parts !! j else "")
                        | j <- [0 .. length heads - 1]
                      ]
           in map row (drop start ls)

_updateAt :: Int -> (a -> a) -> [a] -> [a]
_updateAt i f xs = take i xs ++ [f (xs !! i)] ++ drop (i + 1) xs

isPrime :: Int -> Bool
isPrime n = fromMaybe (False) $
  case if (_asInt (n) < 2) then Just (False) else Nothing of Just v -> Just v; Nothing -> case if ((n `mod` 2) == 0) then Just ((_asInt (n) == 2)) else Nothing of Just v -> Just v; Nothing -> case if ((n `mod` 3) == 0) then Just ((_asInt (n) == 3)) else Nothing of Just v -> Just v; Nothing -> (let d = 5 in case whileLoop (\() -> ((d * d) <= n)) (\() -> case if ((n `mod` d) == 0) then Just (False) else Nothing of Just v -> Just v; Nothing -> (let d = (_asInt (d) + 2) in case if ((n `mod` d) == 0) then Just (False) else Nothing of Just v -> Just v; Nothing -> (let d = (_asInt (d) + 4) in Nothing))) of Just v -> Just v; Nothing -> Just (True))

firstPrimeFactor :: Int -> Int
firstPrimeFactor n = fromMaybe (0) $
  case if (_asInt (n) == 1) then Just (1) else Nothing of Just v -> Just v; Nothing -> case if ((n `mod` 3) == 0) then Just (3) else Nothing of Just v -> Just v; Nothing -> case if ((n `mod` 5) == 0) then Just (5) else Nothing of Just v -> Just v; Nothing -> (let inc = [4, 2, 4, 2, 4, 6, 2, 6] in (let k = 7 in (let i = 0 in case whileLoop (\() -> ((k * k) <= n)) (\() -> case if ((n `mod` k) == 0) then Just (k) else Nothing of Just v -> Just v; Nothing -> (let k = (k + (inc !! i)) in (let i = (((_asInt (i) + 1)) `mod` length inc) in Nothing))) of Just v -> Just v; Nothing -> Just (n))))

indexOf :: String -> String -> Int
indexOf s ch =
  fromMaybe (0) $
    (let i = 0 in case whileLoop (\() -> (_asInt (i) < length s)) (\() -> case if (take ((_asInt (i) + 1) - i) (drop i s) == ch) then Just (i) else Nothing of Just v -> Just v; Nothing -> (let i = (_asInt (i) + 1) in Nothing)) of Just v -> Just v; Nothing -> Just ((-1)))

padLeft :: Int -> Int -> String
padLeft n width =
  fromMaybe ("") $
    (let s = show n in case whileLoop (\() -> (length s < _asInt (width))) (\() -> (let s = (" " + s) in Nothing)) of Just v -> Just v; Nothing -> Just (s))

formatFloat :: Double -> Int -> String
formatFloat f prec =
  fromMaybe ("") $
    (let s = show f in (let idx = indexOf s "." in case if (_asInt (idx) < 0) then Just (s) else Nothing of Just v -> Just v; Nothing -> (let need = ((_asInt (idx) + 1) + _asInt (prec)) in case if (length s > _asInt (need)) then Just (take (need - 0) (drop 0 s)) else Nothing of Just v -> Just v; Nothing -> Just (s))))
  where
    s = show f
    idx = indexOf s "."

main :: ()
main =
  fromMaybe (()) $
    (let blum = [] in (let counts = [0, 0, 0, 0] in (let digits = [1, 3, 7, 9] in (let i = 1 in (let bc = 0 in whileLoop (\() -> True) (\() -> (let p = firstPrimeFactor i in case if ((p `mod` 4) == 3) then (let q = (read ((i / p)) :: Int) in if (((((q /= p) && q) `mod` 4) == 3) && isPrime q) then case if (_asInt (bc) < 50) then (let blum = (blum ++ [i]) in Nothing) else Nothing of Just v -> Just v; Nothing -> (let d = (i `mod` 10) in case if (_asInt (d) == 1) then (let counts = _updateAt 0 (const (_asInt ((counts !! 0)) + 1)) counts in Nothing) else if (_asInt (d) == 3) then (let counts = _updateAt 1 (const (_asInt ((counts !! 1)) + 1)) counts in Nothing) else if (_asInt (d) == 7) then (let counts = _updateAt 2 (const (_asInt ((counts !! 2)) + 1)) counts in Nothing) else if (_asInt (d) == 9) then (let counts = _updateAt 3 (const (_asInt ((counts !! 3)) + 1)) counts in Nothing) else Nothing of Just v -> Just v; Nothing -> (let bc = (_asInt (bc) + 1) in if (_asInt (bc) == 50) then case (let _ = putStrLn ("First 50 Blum integers:") in Nothing) of Just v -> Just v; Nothing -> (let idx = 0 in case whileLoop (\() -> (_asInt (idx) < 50)) (\() -> (let line = "" in (let j = 0 in case whileLoop (\() -> (_asInt (j) < 10)) (\() -> (let line = ((line + padLeft (blum !! idx) 3) + " ") in (let idx = (_asInt (idx) + 1) in (let j = (_asInt (j) + 1) in Nothing)))) of Just v -> Just v; Nothing -> (let _ = putStrLn (take ((length line - 1) - 0) (drop 0 line)) in Nothing)))) of Just v -> Just v; Nothing -> Just ()) else Nothing)) else Nothing) else Nothing of Just v -> Just v; Nothing -> if ((i `mod` 5) == 3) then (let i = (_asInt (i) + 4) in Nothing) else (let i = (_asInt (i) + 2) in Nothing))))))))

main :: IO ()
main = do
  main
