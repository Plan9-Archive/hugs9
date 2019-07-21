{-# OPTIONS_GHC -optc-D__HUGS__ #-}
{-# INCLUDE "HsUnix.h" #-}
{-# LINE 1 "System/Posix/Unistd.hsc" #-}
{-# OPTIONS -fffi #-}
{-# LINE 2 "System/Posix/Unistd.hsc" #-}
-----------------------------------------------------------------------------
-- |
-- Module      :  System.Posix.Unistd
-- Copyright   :  (c) The University of Glasgow 2002
-- License     :  BSD-style (see the file libraries/base/LICENSE)
-- 
-- Maintainer  :  libraries@haskell.org
-- Stability   :  provisional
-- Portability :  non-portable (requires POSIX)
--
-- POSIX miscellaneous stuff, mostly from unistd.h
--
-----------------------------------------------------------------------------

module System.Posix.Unistd (
    -- * System environment
    SystemID(..),
    getSystemID,

    SysVar(..),
    getSysVar,

    -- * Sleeping
    sleep, usleep,

  {-
    ToDo from unistd.h:
      confstr, 
      lots of sysconf variables

    -- use Network.BSD
    gethostid, gethostname

    -- should be in System.Posix.Files?
    pathconf, fpathconf,

    -- System.Posix.Signals
    ualarm,

    -- System.Posix.IO
    read, write,

    -- should be in System.Posix.User?
    getEffectiveUserName,
-}
  ) where


{-# LINE 50 "System/Posix/Unistd.hsc" #-}

import Foreign.C.Error
import Foreign.C.String ( peekCString )
import Foreign.C.Types ( CInt, CUInt, CLong )
import Foreign.Marshal.Alloc ( allocaBytes )
import Foreign.Ptr ( Ptr, plusPtr )
import System.Posix.Types
import System.Posix.Internals

-- -----------------------------------------------------------------------------
-- System environment (uname())

data SystemID =
  SystemID { systemName :: String
  	   , nodeName   :: String
	   , release    :: String
	   , version    :: String
	   , machine    :: String
	   }

getSystemID :: IO SystemID
getSystemID = do
  allocaBytes (390) $ \p_sid -> do
{-# LINE 73 "System/Posix/Unistd.hsc" #-}
    throwErrnoIfMinus1_ "getSystemID" (c_uname p_sid)
    sysN <- peekCString (((\hsc_ptr -> hsc_ptr `plusPtr` 0)) p_sid)
{-# LINE 75 "System/Posix/Unistd.hsc" #-}
    node <- peekCString (((\hsc_ptr -> hsc_ptr `plusPtr` 65)) p_sid)
{-# LINE 76 "System/Posix/Unistd.hsc" #-}
    rel  <- peekCString (((\hsc_ptr -> hsc_ptr `plusPtr` 130)) p_sid)
{-# LINE 77 "System/Posix/Unistd.hsc" #-}
    ver  <- peekCString (((\hsc_ptr -> hsc_ptr `plusPtr` 195)) p_sid)
{-# LINE 78 "System/Posix/Unistd.hsc" #-}
    mach <- peekCString (((\hsc_ptr -> hsc_ptr `plusPtr` 260)) p_sid)
{-# LINE 79 "System/Posix/Unistd.hsc" #-}
    return (SystemID { systemName = sysN,
		       nodeName   = node,
		       release    = rel,
		       version    = ver,
		       machine    = mach
		     })

foreign import ccall unsafe "uname"
   c_uname :: Ptr CUtsname -> IO CInt

-- -----------------------------------------------------------------------------
-- sleeping

-- | Sleep for the specified duration (in seconds).  Returns the time remaining
-- (if the sleep was interrupted by a signal, for example).
--
-- GHC Note: the comment for 'usleep' also applies here.
--
sleep :: Int -> IO Int
sleep 0 = return 0
sleep secs = do r <- c_sleep (fromIntegral secs); return (fromIntegral r)

foreign import ccall safe "sleep"
  c_sleep :: CUInt -> IO CUInt

-- | Sleep for the specified duration (in microseconds).
--
-- GHC Note: 'Control.Concurrent.threadDelay' is a better choice.
-- Without the @-threaded@ option, 'usleep' will block all other user
-- threads.  Even with the @-threaded@ option, 'usleep' requires a
-- full OS thread to itself.  'Control.Concurrent.threadDelay' has
-- neither of these shortcomings.
--
usleep :: Int -> IO ()
usleep 0 = return ()

{-# LINE 117 "System/Posix/Unistd.hsc" #-}
usleep usecs = throwErrnoIfMinus1Retry_ "usleep" (c_usleep (fromIntegral usecs))

{-# LINE 119 "System/Posix/Unistd.hsc" #-}


{-# LINE 124 "System/Posix/Unistd.hsc" #-}
foreign import ccall safe "usleep"
  c_usleep :: CUInt -> IO CInt

{-# LINE 127 "System/Posix/Unistd.hsc" #-}

-- -----------------------------------------------------------------------------
-- System variables

data SysVar = ArgumentLimit
            | ChildLimit
            | ClockTick
            | GroupLimit
            | OpenFileLimit
            | PosixVersion
            | HasSavedIDs
            | HasJobControl
	-- ToDo: lots more

getSysVar :: SysVar -> IO Integer
getSysVar v =
    case v of
      ArgumentLimit -> sysconf (0)
{-# LINE 145 "System/Posix/Unistd.hsc" #-}
      ChildLimit    -> sysconf (1)
{-# LINE 146 "System/Posix/Unistd.hsc" #-}
      ClockTick	    -> sysconf (2)
{-# LINE 147 "System/Posix/Unistd.hsc" #-}
      GroupLimit    -> sysconf (3)
{-# LINE 148 "System/Posix/Unistd.hsc" #-}
      OpenFileLimit -> sysconf (4)
{-# LINE 149 "System/Posix/Unistd.hsc" #-}
      PosixVersion  -> sysconf (29)
{-# LINE 150 "System/Posix/Unistd.hsc" #-}
      HasSavedIDs   -> sysconf (8)
{-# LINE 151 "System/Posix/Unistd.hsc" #-}
      HasJobControl -> sysconf (7)
{-# LINE 152 "System/Posix/Unistd.hsc" #-}

sysconf :: CInt -> IO Integer
sysconf n = do 
  r <- throwErrnoIfMinus1 "getSysVar" (c_sysconf n)
  return (fromIntegral r)

foreign import ccall unsafe "sysconf"
  c_sysconf :: CInt -> IO CLong
