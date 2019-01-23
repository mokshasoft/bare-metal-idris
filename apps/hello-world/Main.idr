{-
Copyright 2018, Mokshasoft AB (mokshasoft.com)

This software may be distributed and modified according to the terms of
the BSD 2-Clause license. Note that NO WARRANTY is provided.
See "LICENSE_BSD2.txt" for details.
-}

module Main

import StarterWareFree.Utils

main : IO ()
main = do
    ConsoleUtilsInit
    ConsoleUtilsSetType 0
    ConsoleUtilsPrintf "Hello, bare-metal Idris"
