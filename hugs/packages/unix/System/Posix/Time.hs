{-# OPTIONS_GHC -optc-D__HUGS__ #-}
{-# INCLUDE "HsUnix.h" #-}
{-# LINE 1 "System/Posix/Time.hsc" #-}
{-# OPTIONS -fffi #-}
{-# LINE 2 "System/Posix/Time.hsc" #-}
-----------------------------------------------------------------------------
-- |
-- Module      :  System.Posix.Time
-- Copyright   :  (c) The University of Glasgow 2002
-- License     :  BSD-style (see the file libraries/base/LICENSE)
-- 
-- Maintainer  :  libraries@haskell.org
-- Stability   :  provisional
-- Portability :  non-portable (requires POSIX)
--
-- POSIX Time support
--
-----------------------------------------------------------------------------

module System.Posix.Time (
	epochTime,
	-- ToDo: lots more from sys/time.h
	-- how much already supported by System.Time?
  ) where


{-# LINE 23 "System/Posix/Time.hsc" #-}

import System.Posix.Types
import Foreign
import Foreign.C

-- -----------------------------------------------------------------------------
-- epochTime

-- | @epochTime@ calls @time@ to obtain the number of 
--   seconds that have elapsed since the epoch (Jan 01 00:00:00 GMT 1970).
epochTime :: IO EpochTime
epochTime = throwErrnoIfMinus1 "epochTime" (c_time nullPtr)

foreign import ccall unsafe "time"
  c_time :: Ptr CTime -> IO CTime
