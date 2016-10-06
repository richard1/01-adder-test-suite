{-# LANGUAGE ScopedTypeVariables #-}

import           Common
import           Control.Exception
import           System.Exit
import           Test.Tasty
import           Text.Printf
import           Data.Int

main :: IO ()
main = do
  sc <- initScore
  defaultMain (tests sc) `catch` (\(e :: ExitCode) -> do
    (n, tot) <- getTotal sc
    putStrLn ("OVERALL SCORE = " ++ show n ++ " / "++ show tot)
    throwIO e)

tests :: Score -> TestTree
tests sc = testGroup "Tests"
  [ testGroup "Adder"           (adderTests   sc)
  , testGroup "Community-Tests" (yourTests    sc)
  ]

adderTests sc =
  [ mkTest sc "forty_one"  (Code "41")               (Right "41")
  , mkTest sc "nyi"        (Code "let x = 10 in x")  (Right "10")
  , mkTest sc "five"        File                     (Right "5")
  , mkTest sc "adds"        File                     (Right "8")
  , mkTest sc "subs"        File                     (Right "8")
  , mkTest sc "lets"        File                     (Right "14")
  ]

--------------------------------------------------------------------------------
-- | BEGIN yourTest DO NOT EDIT THIS LINE --------------------------------------
--------------------------------------------------------------------------------

yourTests sc =
  [ mkTest sc "badVar" File (Left (unboundVarString "x")),
    mkTest sc "badLet" File (Left (unboundVarString "y")),
    mkTest sc "fiveLets" File (Right "5"),
    mkTest sc "big_test" (Code "let z = sub1(5), y = sub1(z) in sub1(add1(add1(y)))") (Right "4"),
    mkTest sc "ignored_let_right" (Code "let z = sub1(5), y = sub1(z), l = 5 in sub1(add1(add1(y)))") (Right "4"),
    mkTest sc "ignored_let_left" (Code "let l = 5, z = sub1(5), y = sub1(z) in sub1(add1(add1(y)))") (Right "4"),
    mkTest sc "shadow" (Code "let z = sub1(5), y = sub1(z) in let y = 1 in y") (Right "1"),
    mkTest sc "yOutOfScope" File (Left (unboundVarString "y"))
  ]

unboundVarString :: String -> String
unboundVarString var = undefinedString

undefinedString = error "Test Invalid: Tester must fill in the correct string here!"
