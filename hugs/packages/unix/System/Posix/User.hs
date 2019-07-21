{-# OPTIONS_GHC -optc-D__HUGS__ #-}
{-# INCLUDE "HsUnix.h" #-}
{-# LINE 1 "System/Posix/User.hsc" #-}
{-# OPTIONS -fffi #-}
{-# LINE 2 "System/Posix/User.hsc" #-}
-----------------------------------------------------------------------------
-- |
-- Module      :  System.Posix.User
-- Copyright   :  (c) The University of Glasgow 2002
-- License     :  BSD-style (see the file libraries/base/LICENSE)
-- 
-- Maintainer  :  libraries@haskell.org
-- Stability   :  provisional
-- Portability :  non-portable (requires POSIX)
--
-- POSIX user\/group support
--
-----------------------------------------------------------------------------

module System.Posix.User (
    -- * User environment
    -- ** Querying the user environment
    getRealUserID,
    getRealGroupID,
    getEffectiveUserID,
    getEffectiveGroupID,
    getGroups,
    getLoginName,
    getEffectiveUserName,

    -- *** The group database
    GroupEntry(..),
    getGroupEntryForID,
    getGroupEntryForName,
    getAllGroupEntries,

    -- *** The user database
    UserEntry(..),
    getUserEntryForID,
    getUserEntryForName,
    getAllUserEntries,

    -- ** Modifying the user environment
    setUserID,
    setGroupID,

  ) where


{-# LINE 46 "System/Posix/User.hsc" #-}

import System.Posix.Types
import Foreign
import Foreign.C
import System.Posix.Internals	( CGroup, CPasswd )


{-# LINE 53 "System/Posix/User.hsc" #-}
import Control.Concurrent.MVar  ( newMVar, withMVar )

{-# LINE 55 "System/Posix/User.hsc" #-}

-- -----------------------------------------------------------------------------
-- user environemnt

-- | @getRealUserID@ calls @getuid@ to obtain the real @UserID@
--   associated with the current process.
getRealUserID :: IO UserID
getRealUserID = c_getuid

foreign import ccall unsafe "getuid"
  c_getuid :: IO CUid

-- | @getRealGroupID@ calls @getgid@ to obtain the real @GroupID@
--   associated with the current process.
getRealGroupID :: IO GroupID
getRealGroupID = c_getgid

foreign import ccall unsafe "getgid"
  c_getgid :: IO CGid

-- | @getEffectiveUserID@ calls @geteuid@ to obtain the effective
--   @UserID@ associated with the current process.
getEffectiveUserID :: IO UserID
getEffectiveUserID = c_geteuid

foreign import ccall unsafe "geteuid"
  c_geteuid :: IO CUid

-- | @getEffectiveGroupID@ calls @getegid@ to obtain the effective
--   @GroupID@ associated with the current process.
getEffectiveGroupID :: IO GroupID
getEffectiveGroupID = c_getegid

foreign import ccall unsafe "getegid"
  c_getegid :: IO CGid

-- | @getGroups@ calls @getgroups@ to obtain the list of
--   supplementary @GroupID@s associated with the current process.
getGroups :: IO [GroupID]
getGroups = do
    ngroups <- c_getgroups 0 nullPtr
    allocaArray (fromIntegral ngroups) $ \arr -> do
       throwErrnoIfMinus1_ "getGroups" (c_getgroups ngroups arr)
       groups <- peekArray (fromIntegral ngroups) arr
       return groups

foreign import ccall unsafe "getgroups"
  c_getgroups :: CInt -> Ptr CGid -> IO CInt




-- | @getLoginName@ calls @getlogin@ to obtain the login name
--   associated with the current process.
getLoginName :: IO String
getLoginName =  do
    -- ToDo: use getlogin_r
    str <- throwErrnoIfNull "getLoginName" c_getlogin
    peekCString str

foreign import ccall unsafe "getlogin"
  c_getlogin :: IO CString

-- | @setUserID uid@ calls @setuid@ to set the real, effective, and
--   saved set-user-id associated with the current process to @uid@.
setUserID :: UserID -> IO ()
setUserID uid = throwErrnoIfMinus1_ "setUserID" (c_setuid uid)

foreign import ccall unsafe "setuid"
  c_setuid :: CUid -> IO CInt

-- | @setGroupID gid@ calls @setgid@ to set the real, effective, and
--   saved set-group-id associated with the current process to @gid@.
setGroupID :: GroupID -> IO ()
setGroupID gid = throwErrnoIfMinus1_ "setGroupID" (c_setgid gid)

foreign import ccall unsafe "setgid"
  c_setgid :: CGid -> IO CInt

-- -----------------------------------------------------------------------------
-- User names

-- | @getEffectiveUserName@ gets the name
--   associated with the effective @UserID@ of the process.
getEffectiveUserName :: IO String
getEffectiveUserName = do
    euid <- getEffectiveUserID
    pw <- getUserEntryForID euid
    return (userName pw)

-- -----------------------------------------------------------------------------
-- The group database (grp.h)

data GroupEntry =
 GroupEntry {
  groupName    :: String,       -- ^ The name of this group (gr_name)
  groupPassword :: String,      -- ^ The password for this group (gr_passwd)
  groupID      :: GroupID,      -- ^ The unique numeric ID for this group (gr_gid)
  groupMembers :: [String]      -- ^ A list of zero or more usernames that are members (gr_mem)
 } deriving (Show, Read, Eq)

-- | @getGroupEntryForID gid@ calls @getgrgid@ to obtain
--   the @GroupEntry@ information associated with @GroupID@
--   @gid@.
getGroupEntryForID :: GroupID -> IO GroupEntry

{-# LINE 161 "System/Posix/User.hsc" #-}
getGroupEntryForID gid = do
  allocaBytes (32) $ \pgr ->
{-# LINE 163 "System/Posix/User.hsc" #-}
    allocaBytes grBufSize $ \pbuf ->
      alloca $ \ ppgr -> do
        throwErrorIfNonZero_ "getGroupEntryForID" $
	     c_getgrgid_r gid pgr pbuf (fromIntegral grBufSize) ppgr
	throwErrnoIfNull "getGroupEntryForID" $
	     peekElemOff ppgr 0
	unpackGroupEntry pgr


foreign import ccall unsafe "getgrgid_r"
  c_getgrgid_r :: CGid -> Ptr CGroup -> CString
		 -> CSize -> Ptr (Ptr CGroup) -> IO CInt

{-# LINE 178 "System/Posix/User.hsc" #-}

-- | @getGroupEntryForName name@ calls @getgrnam@ to obtain
--   the @GroupEntry@ information associated with the group called
--   @name@.
getGroupEntryForName :: String -> IO GroupEntry

{-# LINE 184 "System/Posix/User.hsc" #-}
getGroupEntryForName name = do
  allocaBytes (32) $ \pgr ->
{-# LINE 186 "System/Posix/User.hsc" #-}
    allocaBytes grBufSize $ \pbuf ->
      alloca $ \ ppgr -> 
	withCString name $ \ pstr -> do
          throwErrorIfNonZero_ "getGroupEntryForName" $
	     c_getgrnam_r pstr pgr pbuf (fromIntegral grBufSize) ppgr
	  throwErrnoIfNull "getGroupEntryForName" $
	     peekElemOff ppgr 0
	  unpackGroupEntry pgr

foreign import ccall unsafe "getgrnam_r"
  c_getgrnam_r :: CString -> Ptr CGroup -> CString
		 -> CSize -> Ptr (Ptr CGroup) -> IO CInt

{-# LINE 201 "System/Posix/User.hsc" #-}

-- | @getAllGroupEntries@ returns all group entries on the system by
--   repeatedly calling @getgrent@
getAllGroupEntries :: IO [GroupEntry]

{-# LINE 206 "System/Posix/User.hsc" #-}
getAllGroupEntries =
    withMVar lock $ \_ -> worker []
    where worker accum =
              do resetErrno
                 ppw <- throwErrnoIfNullAndError "getAllGroupEntries" $ 
                        c_getgrent
                 if ppw == nullPtr
                     then return (reverse accum)
                     else do thisentry <- unpackGroupEntry ppw
                             worker (thisentry : accum)

foreign import ccall unsafe "getgrent"
  c_getgrent :: IO (Ptr CGroup)

{-# LINE 222 "System/Posix/User.hsc" #-}


{-# LINE 224 "System/Posix/User.hsc" #-}
grBufSize :: Int

{-# LINE 226 "System/Posix/User.hsc" #-}
grBufSize = fromIntegral $ unsafePerformIO $
		c_sysconf (69)
{-# LINE 228 "System/Posix/User.hsc" #-}

{-# LINE 231 "System/Posix/User.hsc" #-}

{-# LINE 232 "System/Posix/User.hsc" #-}

unpackGroupEntry :: Ptr CGroup -> IO GroupEntry
unpackGroupEntry ptr = do
   name    <- ((\hsc_ptr -> peekByteOff hsc_ptr 0)) ptr >>= peekCString
{-# LINE 236 "System/Posix/User.hsc" #-}
   passwd  <- ((\hsc_ptr -> peekByteOff hsc_ptr 8)) ptr >>= peekCString
{-# LINE 237 "System/Posix/User.hsc" #-}
   gid     <- ((\hsc_ptr -> peekByteOff hsc_ptr 16)) ptr
{-# LINE 238 "System/Posix/User.hsc" #-}
   mem     <- ((\hsc_ptr -> peekByteOff hsc_ptr 24)) ptr
{-# LINE 239 "System/Posix/User.hsc" #-}
   members <- peekArray0 nullPtr mem >>= mapM peekCString
   return (GroupEntry name passwd gid members)

-- -----------------------------------------------------------------------------
-- The user database (pwd.h)

data UserEntry =
 UserEntry {
   userName      :: String,     -- ^ Textual name of this user (pw_name)
   userPassword  :: String,     -- ^ Password -- may be empty or fake if shadow is in use (pw_passwd)
   userID        :: UserID,     -- ^ Numeric ID for this user (pw_uid)
   userGroupID   :: GroupID,    -- ^ Primary group ID (pw_gid)
   userGecos     :: String,     -- ^ Usually the real name for the user (pw_gecos)
   homeDirectory :: String,     -- ^ Home directory (pw_dir)
   userShell     :: String      -- ^ Default shell (pw_shell)
 } deriving (Show, Read, Eq)

--
-- getpwuid and getpwnam leave results in a static object. Subsequent
-- calls modify the same object, which isn't threadsafe. We attempt to
-- mitigate this issue, on platforms that don't provide the safe _r versions
--
-- Also, getpwent/setpwent require a global lock since they maintain
-- an internal file position pointer.

{-# LINE 264 "System/Posix/User.hsc" #-}
lock = unsafePerformIO $ newMVar ()
{-# NOINLINE lock #-}

{-# LINE 267 "System/Posix/User.hsc" #-}

-- | @getUserEntryForID gid@ calls @getpwuid@ to obtain
--   the @UserEntry@ information associated with @UserID@
--   @uid@.
getUserEntryForID :: UserID -> IO UserEntry

{-# LINE 273 "System/Posix/User.hsc" #-}
getUserEntryForID uid = do
  allocaBytes (48) $ \ppw ->
{-# LINE 275 "System/Posix/User.hsc" #-}
    allocaBytes pwBufSize $ \pbuf ->
      alloca $ \ pppw -> do
        throwErrorIfNonZero_ "getUserEntryForID" $
	     c_getpwuid_r uid ppw pbuf (fromIntegral pwBufSize) pppw
	throwErrnoIfNull "getUserEntryForID" $
	     peekElemOff pppw 0
	unpackUserEntry ppw

foreign import ccall unsafe "getpwuid_r"
  c_getpwuid_r :: CUid -> Ptr CPasswd -> 
			CString -> CSize -> Ptr (Ptr CPasswd) -> IO CInt

{-# LINE 297 "System/Posix/User.hsc" #-}

-- | @getUserEntryForName name@ calls @getpwnam@ to obtain
--   the @UserEntry@ information associated with the user login
--   @name@.
getUserEntryForName :: String -> IO UserEntry

{-# LINE 303 "System/Posix/User.hsc" #-}
getUserEntryForName name = do
  allocaBytes (48) $ \ppw ->
{-# LINE 305 "System/Posix/User.hsc" #-}
    allocaBytes pwBufSize $ \pbuf ->
      alloca $ \ pppw -> 
	withCString name $ \ pstr -> do
          throwErrorIfNonZero_ "getUserEntryForName" $
	       c_getpwnam_r pstr ppw pbuf (fromIntegral pwBufSize) pppw
	  throwErrnoIfNull "getUserEntryForName" $
		peekElemOff pppw 0
	  unpackUserEntry ppw

foreign import ccall unsafe "getpwnam_r"
  c_getpwnam_r :: CString -> Ptr CPasswd -> 
			CString -> CSize -> Ptr (Ptr CPasswd) -> IO CInt

{-# LINE 329 "System/Posix/User.hsc" #-}

-- | @getAllUserEntries@ returns all user entries on the system by 
--   repeatedly calling @getpwent@
getAllUserEntries :: IO [UserEntry]

{-# LINE 334 "System/Posix/User.hsc" #-}
getAllUserEntries = 
    withMVar lock $ \_ -> worker []
    where worker accum = 
              do resetErrno
                 ppw <- throwErrnoIfNullAndError "getAllUserEntries" $ 
                        c_getpwent
                 if ppw == nullPtr
                     then return (reverse accum)
                     else do thisentry <- unpackUserEntry ppw
                             worker (thisentry : accum)

foreign import ccall unsafe "getpwent"
  c_getpwent :: IO (Ptr CPasswd)

{-# LINE 350 "System/Posix/User.hsc" #-}


{-# LINE 352 "System/Posix/User.hsc" #-}
pwBufSize :: Int

{-# LINE 354 "System/Posix/User.hsc" #-}
pwBufSize = fromIntegral $ unsafePerformIO $
		c_sysconf (70)
{-# LINE 356 "System/Posix/User.hsc" #-}

{-# LINE 359 "System/Posix/User.hsc" #-}

{-# LINE 360 "System/Posix/User.hsc" #-}


{-# LINE 362 "System/Posix/User.hsc" #-}
foreign import ccall unsafe "sysconf"
  c_sysconf :: CInt -> IO CLong

{-# LINE 365 "System/Posix/User.hsc" #-}

unpackUserEntry :: Ptr CPasswd -> IO UserEntry
unpackUserEntry ptr = do
   name   <- ((\hsc_ptr -> peekByteOff hsc_ptr 0))   ptr >>= peekCString
{-# LINE 369 "System/Posix/User.hsc" #-}
   passwd <- ((\hsc_ptr -> peekByteOff hsc_ptr 8)) ptr >>= peekCString
{-# LINE 370 "System/Posix/User.hsc" #-}
   uid    <- ((\hsc_ptr -> peekByteOff hsc_ptr 16))    ptr
{-# LINE 371 "System/Posix/User.hsc" #-}
   gid    <- ((\hsc_ptr -> peekByteOff hsc_ptr 20))    ptr
{-# LINE 372 "System/Posix/User.hsc" #-}
   gecos  <- ((\hsc_ptr -> peekByteOff hsc_ptr 24))  ptr >>= peekCString
{-# LINE 373 "System/Posix/User.hsc" #-}
   dir    <- ((\hsc_ptr -> peekByteOff hsc_ptr 32))    ptr >>= peekCString
{-# LINE 374 "System/Posix/User.hsc" #-}
   shell  <- ((\hsc_ptr -> peekByteOff hsc_ptr 40))  ptr >>= peekCString
{-# LINE 375 "System/Posix/User.hsc" #-}
   return (UserEntry name passwd uid gid gecos dir shell)

-- Used when calling re-entrant system calls that signal their 'errno' 
-- directly through the return value.
throwErrorIfNonZero_ :: String -> IO CInt -> IO ()
throwErrorIfNonZero_ loc act = do
    rc <- act
    if (rc == 0) 
     then return ()
     else ioError (errnoToIOError loc (Errno (fromIntegral rc)) Nothing Nothing)

-- Used when a function returns NULL to indicate either an error or
-- EOF, depending on whether the global errno is nonzero.
throwErrnoIfNullAndError :: String -> IO (Ptr a) -> IO (Ptr a)
throwErrnoIfNullAndError loc act = do
    rc <- act
    errno <- getErrno
    if rc == nullPtr && errno /= eOK
       then throwErrno loc
       else return rc
