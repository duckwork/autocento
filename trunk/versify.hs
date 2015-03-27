import Text.Pandoc.JSON
import Data.List.Split

main :: IO ()
main = toJSONFilter transformVerseParas

transformVerseParas :: Block -> Block
transformVerseParas (Para xs)
    | LineBreak `elem` xs = Para (addLineSpans xs)
    | otherwise = Para xs
transformVerseParas x = x

addLineSpans :: [Inline] -> [Inline]
addLineSpans = map encloseInSpan . splitWhen (== LineBreak)
    where encloseInSpan = Span("", ["line"], [])
