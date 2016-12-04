module Main where
import MakeContents
import System.Environment

usageStr :: String
usageStr = "Usage: murlyka [option] files\n\
\  Option:\n\
\    --help    Display this text.\n\
\    --version Display version info."

versionStr :: String
versionStr = "Murlyka, build system for C and C++, v.1.1.0\n\
\(c) Gavrilov Vladimir Sergeevich 2016"

usage :: IO ()
usage = putStrLn usageStr

version :: IO ()
version = putStrLn versionStr

parseArgs :: [String] -> IO ()
parseArgs []       = usage
parseArgs y@(x:_) = 
  case x of
    "--help"    -> usage
    "--version" -> version
    _           -> mapM_ handleMakefileDescr y

main::IO()
main = do
  args <- getArgs
  parseArgs args