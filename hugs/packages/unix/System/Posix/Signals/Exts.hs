{-# OPTIONS_GHC -optc-D__HUGS__ #-}
{-# INCLUDE "HsUnix.h" #-}
{-# LINE 1 "System/Posix/Signals/Exts.hsc" #-}
{-# OPTIONS -fffi #-}
{-# LINE 2 "System/Posix/Signals/Exts.hsc" #-}
-----------------------------------------------------------------------------
-- |
-- Module      :  System.Posix.Signals.Exts
-- Copyright   :  (c) The University of Glasgow 2002
-- License     :  BSD-style (see the file libraries/base/LICENSE)
-- 
-- Maintainer  :  libraries@haskell.org
-- Stability   :  provisional
-- Portability :  non-portable (requires POSIX, includes Linuxisms/BSDisms)
--
-- non-POSIX signal support commonly available
--
-----------------------------------------------------------------------------


{-# LINE 17 "System/Posix/Signals/Exts.hsc" #-}

module System.Posix.Signals.Exts (
  module System.Posix.Signals


{-# LINE 24 "System/Posix/Signals/Exts.hsc" #-}

{-# LINE 25 "System/Posix/Signals/Exts.hsc" #-}
  , windowChange, sigWINCH

{-# LINE 27 "System/Posix/Signals/Exts.hsc" #-}

  ) where

import Foreign.C ( CInt )
import System.Posix.Signals


{-# LINE 34 "System/Posix/Signals/Exts.hsc" #-}

{-# LINE 37 "System/Posix/Signals/Exts.hsc" #-}

{-# LINE 38 "System/Posix/Signals/Exts.hsc" #-}
sigWINCH  = (28)  :: CInt
{-# LINE 39 "System/Posix/Signals/Exts.hsc" #-}

{-# LINE 40 "System/Posix/Signals/Exts.hsc" #-}

{-# LINE 48 "System/Posix/Signals/Exts.hsc" #-}


{-# LINE 53 "System/Posix/Signals/Exts.hsc" #-}


{-# LINE 55 "System/Posix/Signals/Exts.hsc" #-}
windowChange :: Signal
windowChange = sigWINCH

{-# LINE 58 "System/Posix/Signals/Exts.hsc" #-}
