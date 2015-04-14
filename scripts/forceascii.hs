-- Preprocessor for hapax.lua writer
-- because for some damn reason, UTF-8 confuses things

import Text.Pandoc.JSON
import Data.Char (isAscii)

main :: IO ()
main = toJSONFilter unFancy

unFancy :: Inline -> Inline
unFancy (Str s) = Str $ map makeAscii s
unFancy x       = x

makeAscii :: Char -> Char
makeAscii c
    | isAscii c = c
    | otherwise = ' '
