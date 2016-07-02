module StripSpaces(
  stripSpaces
)
where

import qualified Data.List as Lists
import           Data.Char

{--
  Данная функция отбрасывает пробельные символы вначале и в конце
  строки--аргумента.
--}
stripSpaces :: String -> String
stripSpaces = Lists.dropWhileEnd isSpace . dropWhile isSpace