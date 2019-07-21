{-# OPTIONS_GHC -optc-D__HUGS__ #-}
{-# INCLUDE "HsUnix.h" #-}
{-# LINE 1 "System/Posix/Resource.hsc" #-}
{-# OPTIONS -fffi #-}
{-# LINE 2 "System/Posix/Resource.hsc" #-}
-----------------------------------------------------------------------------
-- |
-- Module      :  System.Posix.Resource
-- Copyright   :  (c) The University of Glasgow 2003
-- License     :  BSD-style (see the file libraries/base/LICENSE)
-- 
-- Maintainer  :  libraries@haskell.org
-- Stability   :  provisional
-- Portability :  non-portable (requires POSIX)
--
-- POSIX resource support
--
-----------------------------------------------------------------------------

module System.Posix.Resource (
    -- * Resource Limits
    ResourceLimit(..), ResourceLimits(..), Resource(..),
    getResourceLimit,
    setResourceLimit,
  ) where


{-# LINE 24 "System/Posix/Resource.hsc" #-}

import System.Posix.Types
import Foreign
import Foreign.C

-- -----------------------------------------------------------------------------
-- Resource limits

data Resource
  = ResourceCoreFileSize
  | ResourceCPUTime
  | ResourceDataSize
  | ResourceFileSize
  | ResourceOpenFiles
  | ResourceStackSize

{-# LINE 40 "System/Posix/Resource.hsc" #-}
  | ResourceTotalMemory

{-# LINE 42 "System/Posix/Resource.hsc" #-}
  deriving Eq

data ResourceLimits
  = ResourceLimits { softLimit, hardLimit :: ResourceLimit }
  deriving Eq

data ResourceLimit
  = ResourceLimitInfinity
  | ResourceLimitUnknown
  | ResourceLimit Integer
  deriving Eq

type RLimit = ()

foreign import ccall unsafe "getrlimit"
  c_getrlimit :: CInt -> Ptr RLimit -> IO CInt

foreign import ccall unsafe "setrlimit"
  c_setrlimit :: CInt -> Ptr RLimit -> IO CInt

getResourceLimit :: Resource -> IO ResourceLimits
getResourceLimit res = do
  allocaBytes (16) $ \p_rlimit -> do
{-# LINE 65 "System/Posix/Resource.hsc" #-}
    throwErrnoIfMinus1 "getResourceLimit" $
      c_getrlimit (packResource res) p_rlimit
    soft <- ((\hsc_ptr -> peekByteOff hsc_ptr 0)) p_rlimit
{-# LINE 68 "System/Posix/Resource.hsc" #-}
    hard <- ((\hsc_ptr -> peekByteOff hsc_ptr 8)) p_rlimit
{-# LINE 69 "System/Posix/Resource.hsc" #-}
    return (ResourceLimits { 
		softLimit = unpackRLimit soft,
		hardLimit = unpackRLimit hard
	   })

setResourceLimit :: Resource -> ResourceLimits -> IO ()
setResourceLimit res ResourceLimits{softLimit=soft,hardLimit=hard} = do
  allocaBytes (16) $ \p_rlimit -> do
{-# LINE 77 "System/Posix/Resource.hsc" #-}
    ((\hsc_ptr -> pokeByteOff hsc_ptr 0)) p_rlimit (packRLimit soft True)
{-# LINE 78 "System/Posix/Resource.hsc" #-}
    ((\hsc_ptr -> pokeByteOff hsc_ptr 8)) p_rlimit (packRLimit hard False)
{-# LINE 79 "System/Posix/Resource.hsc" #-}
    throwErrnoIfMinus1 "setResourceLimit" $
	c_setrlimit (packResource res) p_rlimit
    return ()

packResource :: Resource -> CInt
packResource ResourceCoreFileSize  = (4)
{-# LINE 85 "System/Posix/Resource.hsc" #-}
packResource ResourceCPUTime       = (0)
{-# LINE 86 "System/Posix/Resource.hsc" #-}
packResource ResourceDataSize      = (2)
{-# LINE 87 "System/Posix/Resource.hsc" #-}
packResource ResourceFileSize      = (1)
{-# LINE 88 "System/Posix/Resource.hsc" #-}
packResource ResourceOpenFiles     = (7)
{-# LINE 89 "System/Posix/Resource.hsc" #-}
packResource ResourceStackSize     = (3)
{-# LINE 90 "System/Posix/Resource.hsc" #-}

{-# LINE 91 "System/Posix/Resource.hsc" #-}
packResource ResourceTotalMemory   = (9)
{-# LINE 92 "System/Posix/Resource.hsc" #-}

{-# LINE 93 "System/Posix/Resource.hsc" #-}

unpackRLimit :: CRLim -> ResourceLimit
unpackRLimit (18446744073709551615)  = ResourceLimitInfinity
{-# LINE 96 "System/Posix/Resource.hsc" #-}

{-# LINE 97 "System/Posix/Resource.hsc" #-}
unpackRLimit (18446744073709551615) = ResourceLimitUnknown
{-# LINE 98 "System/Posix/Resource.hsc" #-}
unpackRLimit (18446744073709551615) = ResourceLimitUnknown
{-# LINE 99 "System/Posix/Resource.hsc" #-}

{-# LINE 100 "System/Posix/Resource.hsc" #-}
unpackRLimit other = ResourceLimit (fromIntegral other)

packRLimit :: ResourceLimit -> Bool -> CRLim
packRLimit ResourceLimitInfinity _     = (18446744073709551615)
{-# LINE 104 "System/Posix/Resource.hsc" #-}

{-# LINE 105 "System/Posix/Resource.hsc" #-}
packRLimit ResourceLimitUnknown  True  = (18446744073709551615)
{-# LINE 106 "System/Posix/Resource.hsc" #-}
packRLimit ResourceLimitUnknown  False = (18446744073709551615)
{-# LINE 107 "System/Posix/Resource.hsc" #-}

{-# LINE 108 "System/Posix/Resource.hsc" #-}
packRLimit (ResourceLimit other) _     = fromIntegral other


-- -----------------------------------------------------------------------------
-- Test code

{-
import System.Posix
import Control.Monad

main = do
 zipWithM_ (\r n -> setResourceLimit r ResourceLimits{
					hardLimit = ResourceLimit n,
					softLimit = ResourceLimit n })
	allResources [1..]	
 showAll
 mapM_ (\r -> setResourceLimit r ResourceLimits{
					hardLimit = ResourceLimit 1,
					softLimit = ResourceLimitInfinity })
	allResources
   -- should fail


showAll = 
  mapM_ (\r -> getResourceLimit r >>= (putStrLn . showRLims)) allResources

allResources =
    [ResourceCoreFileSize, ResourceCPUTime, ResourceDataSize,
	ResourceFileSize, ResourceOpenFiles, ResourceStackSize
#ifdef RLIMIT_AS


	]

showRLims ResourceLimits{hardLimit=h,softLimit=s}
  = "hard: " ++ showRLim h ++ ", soft: " ++ showRLim s
 
showRLim ResourceLimitInfinity = "infinity"
showRLim ResourceLimitUnknown  = "unknown"
showRLim (ResourceLimit other)  = show other
-}
