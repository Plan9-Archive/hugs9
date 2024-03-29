{-# OPTIONS_GHC -optc-D__HUGS__ #-}
{-# INCLUDE "HsUnix.h" #-}
{-# LINE 1 "System/Posix/IO.hsc" #-}
{-# OPTIONS -fffi #-}
{-# LINE 2 "System/Posix/IO.hsc" #-}
-----------------------------------------------------------------------------
-- |
-- Module      :  System.Posix.IO
-- Copyright   :  (c) The University of Glasgow 2002
-- License     :  BSD-style (see the file libraries/base/LICENSE)
-- 
-- Maintainer  :  libraries@haskell.org
-- Stability   :  provisional
-- Portability :  non-portable (requires POSIX)
--
-- POSIX IO support.  These types and functions correspond to the unix
-- functions open(2), close(2), etc.  For more portable functions
-- which are more like fopen(3) and friends from stdio.h, see
-- 'System.IO'.
--
-----------------------------------------------------------------------------

module System.Posix.IO (
    -- * Input \/ Output

    -- ** Standard file descriptors
    stdInput, stdOutput, stdError,

    -- ** Opening and closing files
    OpenMode(..),
    OpenFileFlags(..), defaultFileFlags,
    openFd, createFile,
    closeFd,

    -- ** Reading\/writing data
    -- |Programmers using the 'fdRead' and 'fdWrite' API should be aware that
    -- EAGAIN exceptions may occur for non-blocking IO!

    fdRead, fdWrite,

    -- ** Seeking
    fdSeek,

    -- ** File options
    FdOption(..),
    queryFdOption,
    setFdOption,

    -- ** Locking
    FileLock,
    LockRequest(..),
    getLock,  setLock,
    waitToSetLock,

    -- ** Pipes
    createPipe,

    -- ** Duplicating file descriptors
    dup, dupTo,

    -- ** Converting file descriptors to\/from Handles
    handleToFd,
    fdToHandle,  

  ) where

import System.IO
import System.IO.Error
import System.Posix.Types
import System.Posix.Error
import System.Posix.Internals

import Foreign
import Foreign.C
import Data.Bits


{-# LINE 78 "System/Posix/IO.hsc" #-}


{-# LINE 80 "System/Posix/IO.hsc" #-}
import Hugs.Prelude (IOException(..), IOErrorType(..))
import qualified Hugs.IO (handleToFd, openFd)

{-# LINE 83 "System/Posix/IO.hsc" #-}


{-# LINE 85 "System/Posix/IO.hsc" #-}

-- -----------------------------------------------------------------------------
-- Pipes
-- |The 'createPipe' function creates a pair of connected file
-- descriptors. The first component is the fd to read from, the second
-- is the write end.  Although pipes may be bidirectional, this
-- behaviour is not portable and programmers should use two separate
-- pipes for this purpose.  May throw an exception if this is an
-- invalid descriptor.

createPipe :: IO (Fd, Fd)
createPipe =
  allocaArray 2 $ \p_fd -> do
    throwErrnoIfMinus1_ "createPipe" (c_pipe p_fd)
    rfd <- peekElemOff p_fd 0
    wfd <- peekElemOff p_fd 1
    return (Fd rfd, Fd wfd)

-- -----------------------------------------------------------------------------
-- Duplicating file descriptors

-- | May throw an exception if this is an invalid descriptor.
dup :: Fd -> IO Fd
dup (Fd fd) = do r <- throwErrnoIfMinus1 "dup" (c_dup fd); return (Fd r)

-- | May throw an exception if this is an invalid descriptor.
dupTo :: Fd -> Fd -> IO Fd
dupTo (Fd fd1) (Fd fd2) = do
  r <- throwErrnoIfMinus1 "dupTo" (c_dup2 fd1 fd2)
  return (Fd r)

-- -----------------------------------------------------------------------------
-- Opening and closing files

stdInput, stdOutput, stdError :: Fd
stdInput   = Fd (0)
{-# LINE 121 "System/Posix/IO.hsc" #-}
stdOutput  = Fd (1)
{-# LINE 122 "System/Posix/IO.hsc" #-}
stdError   = Fd (2)
{-# LINE 123 "System/Posix/IO.hsc" #-}

data OpenMode = ReadOnly | WriteOnly | ReadWrite

-- |Correspond to some of the int flags from C's fcntl.h.
data OpenFileFlags =
 OpenFileFlags {
    append    :: Bool, -- ^ O_APPEND
    exclusive :: Bool, -- ^ O_EXCL
    noctty    :: Bool, -- ^ O_NOCTTY
    nonBlock  :: Bool, -- ^ O_NONBLOCK
    trunc     :: Bool  -- ^ O_TRUNC
 }


-- |Default values for the 'OpenFileFlags' type. False for each of
-- append, exclusive, noctty, nonBlock, and trunc.
defaultFileFlags :: OpenFileFlags
defaultFileFlags =
 OpenFileFlags {
    append    = False,
    exclusive = False,
    noctty    = False,
    nonBlock  = False,
    trunc     = False
  }


-- |Open and optionally create this file.  See 'System.Posix.Files'
-- for information on how to use the 'FileMode' type.
openFd :: FilePath
       -> OpenMode
       -> Maybe FileMode -- ^Just x => creates the file with the given modes, Nothing => the file must exist.
       -> OpenFileFlags
       -> IO Fd
openFd name how maybe_mode (OpenFileFlags append exclusive noctty
				nonBlock truncate) = do
   withCString name $ \s -> do
    fd <- throwErrnoPathIfMinus1 "openFd" name (c_open s all_flags mode_w)
    return (Fd fd)
  where
    all_flags  = creat .|. flags .|. open_mode

    flags =
       (if append    then (1024)   else 0) .|.
{-# LINE 167 "System/Posix/IO.hsc" #-}
       (if exclusive then (128)     else 0) .|.
{-# LINE 168 "System/Posix/IO.hsc" #-}
       (if noctty    then (256)   else 0) .|.
{-# LINE 169 "System/Posix/IO.hsc" #-}
       (if nonBlock  then (2048) else 0) .|.
{-# LINE 170 "System/Posix/IO.hsc" #-}
       (if truncate  then (512)    else 0)
{-# LINE 171 "System/Posix/IO.hsc" #-}

    (creat, mode_w) = case maybe_mode of 
			Nothing -> (0,0)
			Just x  -> ((64), x)
{-# LINE 175 "System/Posix/IO.hsc" #-}

    open_mode = case how of
		   ReadOnly  -> (0)
{-# LINE 178 "System/Posix/IO.hsc" #-}
		   WriteOnly -> (1)
{-# LINE 179 "System/Posix/IO.hsc" #-}
		   ReadWrite -> (2)
{-# LINE 180 "System/Posix/IO.hsc" #-}

-- |Create and open this file in WriteOnly mode.  A special case of
-- 'openFd'.  See 'System.Posix.Files' for information on how to use
-- the 'FileMode' type.

createFile :: FilePath -> FileMode -> IO Fd
createFile name mode
  = openFd name WriteOnly (Just mode) defaultFileFlags{ trunc=True } 

-- |Close this file descriptor.  May throw an exception if this is an
-- invalid descriptor.

closeFd :: Fd -> IO ()
closeFd (Fd fd) = throwErrnoIfMinus1_ "closeFd" (c_close fd)

-- -----------------------------------------------------------------------------
-- Converting file descriptors to/from Handles

-- | Extracts the 'Fd' from a 'Handle'.  This function has the side effect
-- of closing the 'Handle' and flushing its write buffer, if necessary.
handleToFd :: Handle -> IO Fd

-- | Converts an 'Fd' into a 'Handle' that can be used with the
-- standard Haskell IO library (see "System.IO").  
--
-- GHC only: this function has the side effect of putting the 'Fd'
-- into non-blocking mode (@O_NONBLOCK@) due to the way the standard
-- IO library implements multithreaded I\/O.
--
fdToHandle :: Fd -> IO Handle


{-# LINE 226 "System/Posix/IO.hsc" #-}


{-# LINE 228 "System/Posix/IO.hsc" #-}
handleToFd h = do
  fd <- Hugs.IO.handleToFd h
  return (fromIntegral fd)

fdToHandle fd = do
  mode <- fdGetMode (fromIntegral fd)
  Hugs.IO.openFd (fromIntegral fd) False mode True

{-# LINE 236 "System/Posix/IO.hsc" #-}

-- -----------------------------------------------------------------------------
-- Fd options

data FdOption = AppendOnWrite     -- ^O_APPEND
	      | CloseOnExec       -- ^FD_CLOEXEC
	      | NonBlockingRead   -- ^O_NONBLOCK
	      | SynchronousWrites -- ^O_SYNC

fdOption2Int :: FdOption -> CInt
fdOption2Int CloseOnExec       = (1)
{-# LINE 247 "System/Posix/IO.hsc" #-}
fdOption2Int AppendOnWrite     = (1024)
{-# LINE 248 "System/Posix/IO.hsc" #-}
fdOption2Int NonBlockingRead   = (2048)
{-# LINE 249 "System/Posix/IO.hsc" #-}
fdOption2Int SynchronousWrites = (1052672)
{-# LINE 250 "System/Posix/IO.hsc" #-}

-- | May throw an exception if this is an invalid descriptor.
queryFdOption :: Fd -> FdOption -> IO Bool
queryFdOption (Fd fd) opt = do
  r <- throwErrnoIfMinus1 "queryFdOption" (c_fcntl_read fd flag)
  return ((r .&. fdOption2Int opt) /= 0)
 where
  flag    = case opt of
	      CloseOnExec       -> (1)
{-# LINE 259 "System/Posix/IO.hsc" #-}
	      other		-> (3)
{-# LINE 260 "System/Posix/IO.hsc" #-}

-- | May throw an exception if this is an invalid descriptor.
setFdOption :: Fd -> FdOption -> Bool -> IO ()
setFdOption (Fd fd) opt val = do
  r <- throwErrnoIfMinus1 "setFdOption" (c_fcntl_read fd getflag)
  let r' | val       = r .|. opt_val
	 | otherwise = r .&. (complement opt_val)
  throwErrnoIfMinus1_ "setFdOption" (c_fcntl_write fd setflag r')
 where
  (getflag,setflag)= case opt of
	      CloseOnExec       -> ((1),(2)) 
{-# LINE 271 "System/Posix/IO.hsc" #-}
	      other		-> ((3),(4))
{-# LINE 272 "System/Posix/IO.hsc" #-}
  opt_val = fdOption2Int opt

-- -----------------------------------------------------------------------------
-- Seeking 

mode2Int :: SeekMode -> CInt
mode2Int AbsoluteSeek = (0)
{-# LINE 279 "System/Posix/IO.hsc" #-}
mode2Int RelativeSeek = (1)
{-# LINE 280 "System/Posix/IO.hsc" #-}
mode2Int SeekFromEnd  = (2)
{-# LINE 281 "System/Posix/IO.hsc" #-}

-- | May throw an exception if this is an invalid descriptor.
fdSeek :: Fd -> SeekMode -> FileOffset -> IO FileOffset
fdSeek (Fd fd) mode off =
  throwErrnoIfMinus1 "fdSeek" (c_lseek fd off (mode2Int mode))

-- -----------------------------------------------------------------------------
-- Locking

data LockRequest = ReadLock
                 | WriteLock
                 | Unlock

type FileLock = (LockRequest, SeekMode, FileOffset, FileOffset)

-- | May throw an exception if this is an invalid descriptor.
getLock :: Fd -> FileLock -> IO (Maybe (ProcessID, FileLock))
getLock (Fd fd) lock =
  allocaLock lock $ \p_flock -> do
    throwErrnoIfMinus1_ "getLock" (c_fcntl_lock fd (5) p_flock)
{-# LINE 301 "System/Posix/IO.hsc" #-}
    result <- bytes2ProcessIDAndLock p_flock
    return (maybeResult result)
  where
    maybeResult (_, (Unlock, _, _, _)) = Nothing
    maybeResult x = Just x

allocaLock :: FileLock -> (Ptr CFLock -> IO a) -> IO a
allocaLock (lockreq, mode, start, len) io = 
  allocaBytes (32) $ \p -> do
{-# LINE 310 "System/Posix/IO.hsc" #-}
    ((\hsc_ptr -> pokeByteOff hsc_ptr 0))   p (lockReq2Int lockreq :: CShort)
{-# LINE 311 "System/Posix/IO.hsc" #-}
    ((\hsc_ptr -> pokeByteOff hsc_ptr 2)) p (fromIntegral (mode2Int mode) :: CShort)
{-# LINE 312 "System/Posix/IO.hsc" #-}
    ((\hsc_ptr -> pokeByteOff hsc_ptr 8))  p start
{-# LINE 313 "System/Posix/IO.hsc" #-}
    ((\hsc_ptr -> pokeByteOff hsc_ptr 16))    p len
{-# LINE 314 "System/Posix/IO.hsc" #-}
    io p

lockReq2Int :: LockRequest -> CShort
lockReq2Int ReadLock  = (0)
{-# LINE 318 "System/Posix/IO.hsc" #-}
lockReq2Int WriteLock = (1)
{-# LINE 319 "System/Posix/IO.hsc" #-}
lockReq2Int Unlock    = (2)
{-# LINE 320 "System/Posix/IO.hsc" #-}

bytes2ProcessIDAndLock :: Ptr CFLock -> IO (ProcessID, FileLock)
bytes2ProcessIDAndLock p = do
  req   <- ((\hsc_ptr -> peekByteOff hsc_ptr 0))   p
{-# LINE 324 "System/Posix/IO.hsc" #-}
  mode  <- ((\hsc_ptr -> peekByteOff hsc_ptr 2)) p
{-# LINE 325 "System/Posix/IO.hsc" #-}
  start <- ((\hsc_ptr -> peekByteOff hsc_ptr 8))  p
{-# LINE 326 "System/Posix/IO.hsc" #-}
  len   <- ((\hsc_ptr -> peekByteOff hsc_ptr 16))    p
{-# LINE 327 "System/Posix/IO.hsc" #-}
  pid   <- ((\hsc_ptr -> peekByteOff hsc_ptr 24))    p
{-# LINE 328 "System/Posix/IO.hsc" #-}
  return (pid, (int2req req, int2mode mode, start, len))
 where
  int2req :: CShort -> LockRequest
  int2req (0) = ReadLock
{-# LINE 332 "System/Posix/IO.hsc" #-}
  int2req (1) = WriteLock
{-# LINE 333 "System/Posix/IO.hsc" #-}
  int2req (2) = Unlock
{-# LINE 334 "System/Posix/IO.hsc" #-}
  int2req _ = error $ "int2req: bad argument"

  int2mode :: CShort -> SeekMode
  int2mode (0) = AbsoluteSeek
{-# LINE 338 "System/Posix/IO.hsc" #-}
  int2mode (1) = RelativeSeek
{-# LINE 339 "System/Posix/IO.hsc" #-}
  int2mode (2) = SeekFromEnd
{-# LINE 340 "System/Posix/IO.hsc" #-}
  int2mode _ = error $ "int2mode: bad argument"

-- | May throw an exception if this is an invalid descriptor.
setLock :: Fd -> FileLock -> IO ()
setLock (Fd fd) lock = do
  allocaLock lock $ \p_flock ->
    throwErrnoIfMinus1_ "setLock" (c_fcntl_lock fd (6) p_flock)
{-# LINE 347 "System/Posix/IO.hsc" #-}

-- | May throw an exception if this is an invalid descriptor.
waitToSetLock :: Fd -> FileLock -> IO ()
waitToSetLock (Fd fd) lock = do
  allocaLock lock $ \p_flock ->
    throwErrnoIfMinus1_ "waitToSetLock" 
	(c_fcntl_lock fd (7) p_flock)
{-# LINE 354 "System/Posix/IO.hsc" #-}

-- -----------------------------------------------------------------------------
-- fd{Read,Write}

-- | May throw an exception if this is an invalid descriptor.
fdRead :: Fd
       -> ByteCount -- ^How many bytes to read
       -> IO (String, ByteCount) -- ^The bytes read, how many bytes were read.
fdRead _fd 0 = return ("", 0)
fdRead (Fd fd) nbytes = do
    allocaBytes (fromIntegral nbytes) $ \ bytes -> do
    rc    <-  throwErrnoIfMinus1Retry "fdRead" (c_read fd bytes nbytes)
    case fromIntegral rc of
      0 -> ioError (IOError Nothing EOF "fdRead" "EOF" Nothing)
      n -> do
       s <- peekCStringLen (bytes, fromIntegral n)
       return (s, n)

-- | May throw an exception if this is an invalid descriptor.
fdWrite :: Fd -> String -> IO ByteCount
fdWrite (Fd fd) str = withCStringLen str $ \ (strPtr,len) -> do
    rc <- throwErrnoIfMinus1Retry "fdWrite" (c_write fd strPtr (fromIntegral len))
    return (fromIntegral rc)
