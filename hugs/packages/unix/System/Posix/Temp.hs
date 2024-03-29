{-# OPTIONS_GHC -optc-D__HUGS__ #-}
{-# INCLUDE "HsUnix.h" #-}
{-# LINE 1 "System/Posix/Temp.hsc" #-}
{-# OPTIONS -fffi #-}
{-# LINE 2 "System/Posix/Temp.hsc" #-}
-----------------------------------------------------------------------------
-- |
-- Module      :  System.Posix.Temp
-- Copyright   :  (c) Volker Stolz <vs@foldr.org>
-- License     :  BSD-style (see the file libraries/base/LICENSE)
-- 
-- Maintainer  :  vs@foldr.org
-- Stability   :  provisional
-- Portability :  non-portable (requires POSIX)
--
-- POSIX environment support
--
-----------------------------------------------------------------------------

module System.Posix.Temp (

	mkstemp

{- Not ported (yet?):
	tmpfile: can we handle FILE*?
	tmpnam: ISO C, should go in base?
	tempname: dito
-}

) where


{-# LINE 29 "System/Posix/Temp.hsc" #-}

import System.IO
import System.Posix.IO
import System.Posix.Types
import Foreign.C

-- |'mkstemp' - make a unique filename and open it for
-- reading\/writing (only safe on GHC & Hugs)

mkstemp :: String -> IO (String, Handle)
mkstemp template = do

{-# LINE 41 "System/Posix/Temp.hsc" #-}
  withCString template $ \ ptr -> do
    fd <- throwErrnoIfMinus1 "mkstemp" (c_mkstemp ptr)
    name <- peekCString ptr
    h <- fdToHandle fd
    return (name, h)

{-# LINE 63 "System/Posix/Temp.hsc" #-}

foreign import ccall unsafe "mkstemp"
  c_mkstemp :: CString -> IO Fd

