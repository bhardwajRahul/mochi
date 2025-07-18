-- Generated by Mochi compiler v0.10.26 on 2025-07-16T09:31:22Z
-- Code generated by Mochi compiler; DO NOT EDIT.
{-# LANGUAGE DeriveGeneric #-}

module Main where

import Data.List (intercalate, isInfixOf, isPrefixOf)
import qualified Data.List as List
import qualified Data.Map as Map
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

data AnyValue = VInt Int | VDouble Double | VString String | VBool Bool deriving (Show)

_asInt :: AnyValue -> Int
_asInt (VInt n) = n
_asInt v = error ("expected int, got " ++ show v)

_asDouble :: AnyValue -> Double
_asDouble (VDouble d) = d
_asDouble v = error ("expected double, got " ++ show v)

_asString :: AnyValue -> String
_asString (VString s) = s
_asString v = error ("expected string, got " ++ show v)

_asBool :: AnyValue -> Bool
_asBool (VBool b) = b
_asBool v = error ("expected bool, got " ++ show v)

_showAny :: AnyValue -> String
_showAny (VInt n) = show n
_showAny (VDouble d) = show d
_showAny (VString s) = s
_showAny (VBool b) = if b then "true" else "false"

sieve :: Int -> [Int]
sieve limit =
  fromMaybe ([]) $
    (let spf = [] in (let i = 0 in case whileLoop (\() -> (i <= limit)) (\() -> (let spf = (spf ++ [0]) in (let i = (_asInt (i) + 1) in Nothing))) of Just v -> Just v; Nothing -> (let i = 2 in case whileLoop (\() -> (i <= limit)) (\() -> case if (_asInt ((spf !! i)) == 0) then (let spf = Map.insert i i spf in if ((i * i) <= limit) then (let j = (i * i) in whileLoop (\() -> (j <= limit)) (\() -> case if (_asInt ((spf !! j)) == 0) then (let spf = Map.insert j i spf in Nothing) else Nothing of Just v -> Just v; Nothing -> (let j = (j + i) in Nothing))) else Nothing) else Nothing of Just v -> Just v; Nothing -> (let i = (_asInt (i) + 1) in Nothing)) of Just v -> Just v; Nothing -> Just (spf))))

primesFrom :: [Int] -> Int -> [Int]
primesFrom spf limit =
  fromMaybe ([]) $
    (let primes = [] in (let i = 3 in case whileLoop (\() -> (i <= limit)) (\() -> case if ((spf !! i) == i) then (let primes = (primes ++ [i]) in Nothing) else Nothing of Just v -> Just v; Nothing -> (let i = (_asInt (i) + 1) in Nothing)) of Just v -> Just v; Nothing -> Just (primes)))

pad3 :: Int -> String
pad3 n =
  fromMaybe ("") $
    (let s = show n in case whileLoop (\() -> (length s < 3)) (\() -> (let s = (" " + s) in Nothing)) of Just v -> Just v; Nothing -> Just (s))

commatize :: Int -> String
commatize n =
  fromMaybe ("") $
    (let s = show n in (let out = "" in (let i = (length s - 1) in (let c = 0 in case whileLoop (\() -> (_asInt (i) >= 0)) (\() -> (let out = (take ((_asInt (i) + 1) - i) (drop i s) + out) in (let c = (_asInt (c) + 1) in case if ((((c `mod` 3) == 0) && i) > 0) then (let out = ("," + out) in Nothing) else Nothing of Just v -> Just v; Nothing -> (let i = (_asInt (i) - 1) in Nothing)))) of Just v -> Just v; Nothing -> Just (out)))))

primeCount :: [Int] -> Int -> [Int] -> Int
primeCount primes last spf =
  fromMaybe (0) $
    (let lo = 0 in (let hi = length primes in case whileLoop (\() -> (lo < hi)) (\() -> (let mid = (read ((div ((lo + hi)) 2)) :: Int) in if ((primes !! mid) < last) then (let lo = (_asInt (mid) + 1) in Nothing) else (let hi = mid in Nothing))) of Just v -> Just v; Nothing -> (let count = (_asInt (lo) + 1) in case if ((spf !! last) /= last) then (let count = (count - 1) in Nothing) else Nothing of Just v -> Just v; Nothing -> Just (count))))

arithmeticNumbers :: Int -> [Int] -> [Int]
arithmeticNumbers limit spf =
  fromMaybe ([]) $
    (let arr = [1] in (let n = 3 in case whileLoop (\() -> (length arr < _asInt (limit))) (\() -> case if ((spf !! n) == n) then (let arr = (arr ++ [n]) in Nothing) else (let x = n in (let sigma = 1 in (let tau = 1 in case whileLoop (\() -> (_asInt (x) > 1)) (\() -> (let p = (spf !! x) in case if (_asInt (p) == 0) then (let p = x in Nothing) else Nothing of Just v -> Just v; Nothing -> (let cnt = 0 in (let power = p in (let sum = 1 in case whileLoop (\() -> ((x `mod` p) == 0)) (\() -> (let x = (x / p) in (let cnt = (_asInt (cnt) + 1) in (let sum = (sum + power) in (let power = (power * p) in Nothing))))) of Just v -> Just v; Nothing -> (let sigma = (sigma * sum) in (let tau = (tau * ((_asInt (cnt) + 1))) in Nothing))))))) of Just v -> Just v; Nothing -> if ((sigma `mod` tau) == 0) then (let arr = (arr ++ [n]) in Nothing) else Nothing))) of Just v -> Just v; Nothing -> (let n = (_asInt (n) + 1) in Nothing)) of Just v -> Just v; Nothing -> Just (arr)))

main :: ()
main =
  fromMaybe (()) $
    (let limit = 1228663 in (let spf = sieve limit in (let primes = primesFrom spf limit in (let arr = arithmeticNumbers 1000000 spf in case (let _ = putStrLn ("The first 100 arithmetic numbers are:") in Nothing) of Just v -> Just v; Nothing -> (let i = 0 in case whileLoop (\() -> (_asInt (i) < 100)) (\() -> (let line = "" in (let j = 0 in case whileLoop (\() -> (_asInt (j) < 10)) (\() -> (let line = (line + pad3 (arr !! (i + j))) in case if (_asInt (j) < 9) then (let line = (line + " ") in Nothing) else Nothing of Just v -> Just v; Nothing -> (let j = (_asInt (j) + 1) in Nothing))) of Just v -> Just v; Nothing -> case (let _ = putStrLn (_showAny (line)) in Nothing) of Just v -> Just v; Nothing -> (let i = (_asInt (i) + 10) in Nothing)))) of Just v -> Just v; Nothing -> foldr (\x acc -> case (let last = (arr !! (_asInt (x) - 1)) in (let lastc = commatize last in case (let _ = putStrLn (_showAny (((("\nThe " ++ commatize x) ++ "th arithmetic number is: ") + lastc))) in Nothing) of Just v -> Just v; Nothing -> (let pc = primeCount primes last spf in (let comp = (_asInt ((x - pc)) - 1) in (let _ = putStrLn (_showAny ((((("The count of such numbers <= " + lastc) + " which are composite is ") + commatize comp) + "."))) in Nothing))))) of Just v -> Just v; Nothing -> acc) Nothing [1000, 10000, 100000, 1000000])))))
  where
    limit = 1228663
    spf = sieve limit
    primes = primesFrom spf limit
    arr = arithmeticNumbers 1000000 spf

main :: IO ()
main = do
  main
