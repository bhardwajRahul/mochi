-- Generated by Mochi compiler v0.10.26 on 2025-07-16T15:36:26Z
-- Code generated by Mochi compiler; DO NOT EDIT.
{-# LANGUAGE DeriveGeneric #-}

module Main where

x = 5

main :: IO ()
main = do
  if (x > 3)
    then do
      putStrLn ("big")
    else do
      putStrLn ("small")
