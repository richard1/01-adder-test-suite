{-# LANGUAGE ScopedTypeVariables #-}

import           Common
import           Control.Exception
import           System.Exit
import           Test.Tasty
import           Text.Printf

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
    mkTest sc "fiveLets" File (Right "5")
  ]

unboundVarString :: String -> String
unboundVarString var = undefinedString

undefinedString = error "Test Invalid: Tester must fill in the correct string here!"
