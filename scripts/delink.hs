#!/usr/bin/env runhaskell
import Text.Pandoc.JSON

main = toJSONFilter delink

delink :: Inline -> [Inline]
delink (Link txt _) = txt
delink x            = [x]
