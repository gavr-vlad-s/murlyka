module StripSpaces(
  stripSpaces
)
where

import qualified Data.List as Lists
import           Data.Char

{--
  This function discards any whitespace characters at the beginning 
  and end of the argument.
--}
stripSpaces :: String -> String
stripSpaces = Lists.dropWhileEnd isSpace . dropWhile isSpace