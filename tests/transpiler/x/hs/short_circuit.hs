-- Generated by Mochi transpiler v0.10.31 on 2025-07-20 01:18 GMT+7
import Data.List (isInfixOf, union, intersect, (\\))
boom a b = do
    putStrLn ("boom")
    return (True)


main :: IO ()
main = do
    print (fromEnum (False && boom 1 2))
    print (fromEnum (True || boom 1 2))
