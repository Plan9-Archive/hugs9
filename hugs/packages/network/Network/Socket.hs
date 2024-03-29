{-# OPTIONS_GHC -optc-D__HUGS__ #-}
{-# OPTIONS_GHC -optc-DCALLCONV=ccall #-}
{-# OPTIONS_GHC -optc-D_GNU_SOURCE #-}
{-# INCLUDE "HsNet.h" #-}
{-# OPTIONS_GHC -optc-DDOMAIN_SOCKET_SUPPORT=1 #-}
{-# LINE 1 "Network/Socket.hsc" #-}
{-# OPTIONS -fglasgow-exts -cpp #-}
{-# LINE 2 "Network/Socket.hsc" #-}
-----------------------------------------------------------------------------
-- |
-- Module      :  Network.Socket
-- Copyright   :  (c) The University of Glasgow 2001
-- License     :  BSD-style (see the file libraries/network/LICENSE)
-- 
-- Maintainer  :  libraries@haskell.org
-- Stability   :  provisional
-- Portability :  portable
--
-- The "Network.Socket" module is for when you want full control over
-- sockets.  Essentially the entire C socket API is exposed through
-- this module; in general the operations follow the behaviour of the C
-- functions of the same name (consult your favourite Unix networking book).
--
-- A higher level interface to networking operations is provided
-- through the module "Network".
--
-----------------------------------------------------------------------------


{-# LINE 23 "Network/Socket.hsc" #-}

-- NOTE: ##, we want this interpreted when compiling the .hs, not by hsc2hs.
                                           












{-# LINE 30 "Network/Socket.hsc" #-}


{-# LINE 32 "Network/Socket.hsc" #-}

{-# LINE 33 "Network/Socket.hsc" #-}

{-# LINE 34 "Network/Socket.hsc" #-}


{-# LINE 42 "Network/Socket.hsc" #-}

-- In order to process this file, you need to have CALLCONV defined.

module Network.Socket (

    -- * Types
    Socket(..),		-- instance Eq, Show
    Family(..),		
    SocketType(..),
    SockAddr(..),
    SocketStatus(..),
    HostAddress,
    ShutdownCmd(..),
    ProtocolNumber,
    PortNumber(..),
	-- PortNumber is used non-abstractly in Network.BSD.  ToDo: remove
	-- this use and make the type abstract.

    -- * Socket Operations
    socket,		-- :: Family -> SocketType -> ProtocolNumber -> IO Socket 

{-# LINE 63 "Network/Socket.hsc" #-}
    socketPair,         -- :: Family -> SocketType -> ProtocolNumber -> IO (Socket, Socket)

{-# LINE 65 "Network/Socket.hsc" #-}
    connect,		-- :: Socket -> SockAddr -> IO ()
    bindSocket,		-- :: Socket -> SockAddr -> IO ()
    listen,		-- :: Socket -> Int -> IO ()
    accept,		-- :: Socket -> IO (Socket, SockAddr)
    getPeerName,	-- :: Socket -> IO SockAddr
    getSocketName,	-- :: Socket -> IO SockAddr


{-# LINE 76 "Network/Socket.hsc" #-}

    socketPort,		-- :: Socket -> IO PortNumber

    socketToHandle,	-- :: Socket -> IOMode -> IO Handle

    sendTo,		-- :: Socket -> String -> SockAddr -> IO Int
    sendBufTo,          -- :: Socket -> Ptr a -> Int -> SockAddr -> IO Int

    recvFrom,		-- :: Socket -> Int -> IO (String, Int, SockAddr)
    recvBufFrom,        -- :: Socket -> Ptr a -> Int -> IO (Int, SockAddr)
    
    send,		-- :: Socket -> String -> IO Int
    recv,		-- :: Socket -> Int    -> IO String
    recvLen,            -- :: Socket -> Int    -> IO (String, Int)

    inet_addr,		-- :: String -> IO HostAddress
    inet_ntoa,		-- :: HostAddress -> IO String

    shutdown,		-- :: Socket -> ShutdownCmd -> IO ()
    sClose,		-- :: Socket -> IO ()

    -- ** Predicates on sockets
    sIsConnected,	-- :: Socket -> IO Bool
    sIsBound,		-- :: Socket -> IO Bool
    sIsListening,	-- :: Socket -> IO Bool 
    sIsReadable,	-- :: Socket -> IO Bool
    sIsWritable,	-- :: Socket -> IO Bool

    -- * Socket options
    SocketOption(..),
    getSocketOption,     -- :: Socket -> SocketOption -> IO Int
    setSocketOption,     -- :: Socket -> SocketOption -> Int -> IO ()

    -- * File descriptor transmission

{-# LINE 111 "Network/Socket.hsc" #-}
    sendFd,              -- :: Socket -> CInt -> IO ()
    recvFd,              -- :: Socket -> IO CInt

      -- Note: these two will disappear shortly
    sendAncillary,       -- :: Socket -> Int -> Int -> Int -> Ptr a -> Int -> IO ()
    recvAncillary,       -- :: Socket -> Int -> Int -> IO (Int,Int,Int,Ptr a)


{-# LINE 119 "Network/Socket.hsc" #-}

    -- * Special Constants
    aNY_PORT,		-- :: PortNumber
    iNADDR_ANY,		-- :: HostAddress
    sOMAXCONN,		-- :: Int
    sOL_SOCKET,         -- :: Int

{-# LINE 126 "Network/Socket.hsc" #-}
    sCM_RIGHTS,         -- :: Int

{-# LINE 128 "Network/Socket.hsc" #-}
    maxListenQueue,	-- :: Int

    -- * Initialisation
    withSocketsDo,	-- :: IO a -> IO a
    
    -- * Very low level operations
     -- in case you ever want to get at the underlying file descriptor..
    fdSocket,           -- :: Socket -> CInt
    mkSocket,           -- :: CInt   -> Family 
    			-- -> SocketType
			-- -> ProtocolNumber
			-- -> SocketStatus
			-- -> IO Socket

    -- * Internal

    -- | The following are exported ONLY for use in the BSD module and
    -- should not be used anywhere else.

    packFamily, unpackFamily,
    packSocketType,
    throwSocketErrorIfMinus1_

) where


{-# LINE 154 "Network/Socket.hsc" #-}
import Hugs.Prelude ( IOException(..), IOErrorType(..) )
import Hugs.IO ( openFd )

{-# CFILES cbits/HsNet.c #-}

{-# LINE 159 "Network/Socket.hsc" #-}
{-# CFILES cbits/ancilData.c #-}

{-# LINE 161 "Network/Socket.hsc" #-}

{-# LINE 164 "Network/Socket.hsc" #-}

{-# LINE 165 "Network/Socket.hsc" #-}

import Data.Word ( Word8, Word16, Word32 )
import Foreign.Ptr ( Ptr, castPtr, plusPtr )
import Foreign.Storable ( Storable(..) )
import Foreign.C.Error
import Foreign.C.String ( withCString, peekCString, peekCStringLen, castCharToCChar )
import Foreign.C.Types ( CInt, CUInt, CChar, CSize )
import Foreign.Marshal.Alloc ( alloca, allocaBytes )
import Foreign.Marshal.Array ( peekArray, pokeArray0 )
import Foreign.Marshal.Utils ( with )

import System.IO
import Control.Monad ( liftM, when )
import Data.Ratio ( (%) )

import qualified Control.Exception
import Control.Concurrent.MVar
import Data.Typeable


{-# LINE 194 "Network/Socket.hsc" #-}
import System.IO.Unsafe	(unsafePerformIO)

{-# LINE 196 "Network/Socket.hsc" #-}

-----------------------------------------------------------------------------
-- Socket types

-- There are a few possible ways to do this.  The first is convert the
-- structs used in the C library into an equivalent Haskell type. An
-- other possible implementation is to keep all the internals in the C
-- code and use an Int## and a status flag. The second method is used
-- here since a lot of the C structures are not required to be
-- manipulated.

-- Originally the status was non-mutable so we had to return a new
-- socket each time we changed the status.  This version now uses
-- mutable variables to avoid the need to do this.  The result is a
-- cleaner interface and better security since the application
-- programmer now can't circumvent the status information to perform
-- invalid operations on sockets.

data SocketStatus
  -- Returned Status	Function called
  = NotConnected	-- socket
  | Bound		-- bindSocket
  | Listening		-- listen
  | Connected		-- connect/accept
  | ConvertedToHandle   -- is now a Handle, don't touch
    deriving (Eq, Show)

socketStatusTc = mkTyCon "SocketStatus"; instance Typeable SocketStatus where { typeOf _ = mkTyConApp socketStatusTc [] }

data Socket
  = MkSocket
	    CInt	         -- File Descriptor
	    Family				  
	    SocketType				  
	    ProtocolNumber	 -- Protocol Number
	    (MVar SocketStatus)  -- Status Flag

socketTc = mkTyCon "Socket"; instance Typeable Socket where { typeOf _ = mkTyConApp socketTc [] }

mkSocket :: CInt
	 -> Family
	 -> SocketType
	 -> ProtocolNumber
	 -> SocketStatus
	 -> IO Socket
mkSocket fd fam sType pNum stat = do
   mStat <- newMVar stat
   return (MkSocket fd fam sType pNum mStat)

instance Eq Socket where
  (MkSocket _ _ _ _ m1) == (MkSocket _ _ _ _ m2) = m1 == m2

instance Show Socket where
  showsPrec n (MkSocket fd _ _ _ _) = 
	showString "<socket: " . shows fd . showString ">"


fdSocket :: Socket -> CInt
fdSocket (MkSocket fd _ _ _ _) = fd

type ProtocolNumber = CInt

-- NOTE: HostAddresses are represented in network byte order.
--       Functions that expect the address in machine byte order
--       will have to perform the necessary translation.
type HostAddress = Word32

----------------------------------------------------------------------------
-- Port Numbers
--
-- newtyped to prevent accidental use of sane-looking
-- port numbers that haven't actually been converted to
-- network-byte-order first.
--
newtype PortNumber = PortNum Word16 deriving ( Eq, Ord )

portNumberTc = mkTyCon "PortNumber"; instance Typeable PortNumber where { typeOf _ = mkTyConApp portNumberTc [] }

instance Show PortNumber where
  showsPrec p pn = showsPrec p (portNumberToInt pn)

intToPortNumber :: Int -> PortNumber
intToPortNumber v = PortNum (htons (fromIntegral v))

portNumberToInt :: PortNumber -> Int
portNumberToInt (PortNum po) = fromIntegral (ntohs po)

foreign import ccall unsafe "ntohs" ntohs :: Word16 -> Word16
foreign import ccall unsafe "htons" htons :: Word16 -> Word16
--foreign import CALLCONV unsafe "ntohl" ntohl :: Word32 -> Word32
foreign import ccall unsafe "htonl" htonl :: Word32 -> Word32

instance Enum PortNumber where
    toEnum   = intToPortNumber
    fromEnum = portNumberToInt

instance Num PortNumber where
   fromInteger i = intToPortNumber (fromInteger i)
    -- for completeness.
   (+) x y   = intToPortNumber (portNumberToInt x + portNumberToInt y)
   (-) x y   = intToPortNumber (portNumberToInt x - portNumberToInt y)
   negate x  = intToPortNumber (-portNumberToInt x)
   (*) x y   = intToPortNumber (portNumberToInt x * portNumberToInt y)
   abs n     = intToPortNumber (abs (portNumberToInt n))
   signum n  = intToPortNumber (signum (portNumberToInt n))

instance Real PortNumber where
    toRational x = toInteger x % 1

instance Integral PortNumber where
    quotRem a b = let (c,d) = quotRem (portNumberToInt a) (portNumberToInt b) in
		  (intToPortNumber c, intToPortNumber d)
    toInteger a = toInteger (portNumberToInt a)

instance Storable PortNumber where
   sizeOf    _ = sizeOf    (undefined :: Word16)
   alignment _ = alignment (undefined :: Word16)
   poke p (PortNum po) = poke (castPtr p) po
   peek p = PortNum `liftM` peek (castPtr p)

-----------------------------------------------------------------------------
-- SockAddr

-- The scheme used for addressing sockets is somewhat quirky. The
-- calls in the BSD socket API that need to know the socket address
-- all operate in terms of struct sockaddr, a `virtual' type of
-- socket address.

-- The Internet family of sockets are addressed as struct sockaddr_in,
-- so when calling functions that operate on struct sockaddr, we have
-- to type cast the Internet socket address into a struct sockaddr.
-- Instances of the structure for different families might *not* be
-- the same size. Same casting is required of other families of
-- sockets such as Xerox NS. Similarly for Unix domain sockets.

-- To represent these socket addresses in Haskell-land, we do what BSD
-- didn't do, and use a union/algebraic type for the different
-- families. Currently only Unix domain sockets and the Internet family
-- are supported.

data SockAddr		-- C Names				
  = SockAddrInet
	PortNumber	-- sin_port  (network byte order)
	HostAddress	-- sin_addr  (ditto)

{-# LINE 341 "Network/Socket.hsc" #-}
  | SockAddrUnix
        String          -- sun_path

{-# LINE 344 "Network/Socket.hsc" #-}
  deriving (Eq)

sockAddrTc = mkTyCon "SockAddr"; instance Typeable SockAddr where { typeOf _ = mkTyConApp sockAddrTc [] }


{-# LINE 353 "Network/Socket.hsc" #-}
type CSaFamily = (Word16)
{-# LINE 354 "Network/Socket.hsc" #-}

{-# LINE 355 "Network/Socket.hsc" #-}

instance Show SockAddr where

{-# LINE 358 "Network/Socket.hsc" #-}
  showsPrec _ (SockAddrUnix str) = showString str

{-# LINE 360 "Network/Socket.hsc" #-}
  showsPrec _ (SockAddrInet port ha)
   = showString (unsafePerformIO (inet_ntoa ha)) 
   . showString ":"
   . shows port

-- we can't write an instance of Storable for SockAddr, because the Storable
-- class can't easily handle alternatives. Also note that on Darwin, the
-- sockaddr structure must be zeroed before use.


{-# LINE 370 "Network/Socket.hsc" #-}
pokeSockAddr p (SockAddrUnix path) = do

{-# LINE 374 "Network/Socket.hsc" #-}
	((\hsc_ptr -> pokeByteOff hsc_ptr 0)) p ((1) :: CSaFamily)
{-# LINE 375 "Network/Socket.hsc" #-}
	let pathC = map castCharToCChar path
	pokeArray0 0 (((\hsc_ptr -> hsc_ptr `plusPtr` 2)) p) pathC
{-# LINE 377 "Network/Socket.hsc" #-}

{-# LINE 378 "Network/Socket.hsc" #-}
pokeSockAddr p (SockAddrInet (PortNum port) addr) = do

{-# LINE 382 "Network/Socket.hsc" #-}
	((\hsc_ptr -> pokeByteOff hsc_ptr 0)) p ((2) :: CSaFamily)
{-# LINE 383 "Network/Socket.hsc" #-}
	((\hsc_ptr -> pokeByteOff hsc_ptr 2)) p port
{-# LINE 384 "Network/Socket.hsc" #-}
	((\hsc_ptr -> pokeByteOff hsc_ptr 4)) p addr	
{-# LINE 385 "Network/Socket.hsc" #-}

peekSockAddr p = do
  family <- ((\hsc_ptr -> peekByteOff hsc_ptr 0)) p
{-# LINE 388 "Network/Socket.hsc" #-}
  case family :: CSaFamily of

{-# LINE 390 "Network/Socket.hsc" #-}
	(1) -> do
{-# LINE 391 "Network/Socket.hsc" #-}
		str <- peekCString (((\hsc_ptr -> hsc_ptr `plusPtr` 2)) p)
{-# LINE 392 "Network/Socket.hsc" #-}
		return (SockAddrUnix str)

{-# LINE 394 "Network/Socket.hsc" #-}
	(2) -> do
{-# LINE 395 "Network/Socket.hsc" #-}
		addr <- ((\hsc_ptr -> peekByteOff hsc_ptr 4)) p
{-# LINE 396 "Network/Socket.hsc" #-}
		port <- ((\hsc_ptr -> peekByteOff hsc_ptr 2)) p
{-# LINE 397 "Network/Socket.hsc" #-}
		return (SockAddrInet (PortNum port) addr)

-- helper function used to zero a structure
zeroMemory :: Ptr a -> CSize -> IO ()
zeroMemory dest nbytes = memset dest 0 (fromIntegral nbytes)
foreign import ccall unsafe "string.h" memset :: Ptr a -> CInt -> CSize -> IO ()

-- size of struct sockaddr by family

{-# LINE 406 "Network/Socket.hsc" #-}
sizeOfSockAddr_Family AF_UNIX = 110
{-# LINE 407 "Network/Socket.hsc" #-}

{-# LINE 408 "Network/Socket.hsc" #-}
sizeOfSockAddr_Family AF_INET = 16
{-# LINE 409 "Network/Socket.hsc" #-}

-- size of struct sockaddr by SockAddr

{-# LINE 412 "Network/Socket.hsc" #-}
sizeOfSockAddr (SockAddrUnix _)   = 110
{-# LINE 413 "Network/Socket.hsc" #-}

{-# LINE 414 "Network/Socket.hsc" #-}
sizeOfSockAddr (SockAddrInet _ _) = 16
{-# LINE 415 "Network/Socket.hsc" #-}

withSockAddr :: SockAddr -> (Ptr SockAddr -> Int -> IO a) -> IO a
withSockAddr addr f = do
 let sz = sizeOfSockAddr addr
 allocaBytes sz $ \p -> pokeSockAddr p addr >> f (castPtr p) sz

withNewSockAddr :: Family -> (Ptr SockAddr -> Int -> IO a) -> IO a
withNewSockAddr family f = do
 let sz = sizeOfSockAddr_Family family
 allocaBytes sz $ \ptr -> f ptr sz

-----------------------------------------------------------------------------
-- Connection Functions

-- In the following connection and binding primitives.  The names of
-- the equivalent C functions have been preserved where possible. It
-- should be noted that some of these names used in the C library,
-- \tr{bind} in particular, have a different meaning to many Haskell
-- programmers and have thus been renamed by appending the prefix
-- Socket.

-- Create an unconnected socket of the given family, type and
-- protocol.  The most common invocation of $socket$ is the following:
--    ...
--    my_socket <- socket AF_INET Stream 6
--    ...

socket :: Family 	 -- Family Name (usually AF_INET)
       -> SocketType 	 -- Socket Type (usually Stream)
       -> ProtocolNumber -- Protocol Number (getProtocolByName to find value)
       -> IO Socket	 -- Unconnected Socket

socket family stype protocol = do
    fd <- throwSocketErrorIfMinus1Retry "socket" $
		c_socket (packFamily family) (packSocketType stype) protocol

{-# LINE 453 "Network/Socket.hsc" #-}
    socket_status <- newMVar NotConnected
    return (MkSocket fd family stype protocol socket_status)

-- Create an unnamed pair of connected sockets, given family, type and
-- protocol. Differs from a normal pipe in being a bi-directional channel
-- of communication.


{-# LINE 461 "Network/Socket.hsc" #-}
socketPair :: Family 	          -- Family Name (usually AF_INET)
           -> SocketType 	  -- Socket Type (usually Stream)
           -> ProtocolNumber      -- Protocol Number
           -> IO (Socket, Socket) -- unnamed and connected.
socketPair family stype protocol = do
    allocaBytes (2 * sizeOf (1 :: CInt)) $ \ fdArr -> do
    rc <- throwSocketErrorIfMinus1Retry "socketpair" $
		c_socketpair (packFamily family)
			     (packSocketType stype)
			     protocol fdArr
    [fd1,fd2] <- peekArray 2 fdArr 
    s1 <- mkSocket fd1
    s2 <- mkSocket fd2
    return (s1,s2)
  where
    mkSocket fd = do

{-# LINE 480 "Network/Socket.hsc" #-}
       stat <- newMVar Connected
       return (MkSocket fd family stype protocol stat)

foreign import ccall unsafe "socketpair"
  c_socketpair :: CInt -> CInt -> CInt -> Ptr CInt -> IO CInt

{-# LINE 486 "Network/Socket.hsc" #-}

-----------------------------------------------------------------------------
-- Binding a socket
--
-- Given a port number this {\em binds} the socket to that port. This
-- means that the programmer is only interested in data being sent to
-- that port number. The $Family$ passed to $bindSocket$ must
-- be the same as that passed to $socket$.	 If the special port
-- number $aNY\_PORT$ is passed then the system assigns the next
-- available use port.
-- 
-- Port numbers for standard unix services can be found by calling
-- $getServiceEntry$.  These are traditionally port numbers below
-- 1000; although there are afew, namely NFS and IRC, which used higher
-- numbered ports.
-- 
-- The port number allocated to a socket bound by using $aNY\_PORT$ can be
-- found by calling $port$

bindSocket :: Socket	-- Unconnected Socket
	   -> SockAddr	-- Address to Bind to
	   -> IO ()

bindSocket (MkSocket s _family _stype _protocol socketStatus) addr = do
 modifyMVar_ socketStatus $ \ status -> do
 if status /= NotConnected 
  then
   ioError (userError ("bindSocket: can't peform bind on socket in status " ++
	 show status))
  else do
   withSockAddr addr $ \p_addr sz -> do
   status <- throwSocketErrorIfMinus1Retry "bind" $ c_bind s p_addr (fromIntegral sz)
   return Bound

-----------------------------------------------------------------------------
-- Connecting a socket
--
-- Make a connection to an already opened socket on a given machine
-- and port.  assumes that we have already called createSocket,
-- otherwise it will fail.
--
-- This is the dual to $bindSocket$.  The {\em server} process will
-- usually bind to a port number, the {\em client} will then connect
-- to the same port number.  Port numbers of user applications are
-- normally agreed in advance, otherwise we must rely on some meta
-- protocol for telling the other side what port number we have been
-- allocated.

connect :: Socket	-- Unconnected Socket
	-> SockAddr 	-- Socket address stuff
	-> IO ()

connect sock@(MkSocket s _family _stype _protocol socketStatus) addr = do
 modifyMVar_ socketStatus $ \currentStatus -> do
 if currentStatus /= NotConnected 
  then
   ioError (userError ("connect: can't peform connect on socket in status " ++
         show currentStatus))
  else do
   withSockAddr addr $ \p_addr sz -> do

   let  connectLoop = do
       	   r <- c_connect s p_addr (fromIntegral sz)
       	   if r == -1
       	       then do 

{-# LINE 552 "Network/Socket.hsc" #-}
	       	       err <- getErrno
		       case () of
			 _ | err == eINTR       -> connectLoop
			 _ | err == eINPROGRESS -> connectBlocked
--			 _ | err == eAGAIN      -> connectBlocked
			 otherwise              -> throwErrno "connect"

{-# LINE 569 "Network/Socket.hsc" #-}
       	       else return r

	connectBlocked = do 

{-# LINE 575 "Network/Socket.hsc" #-}
	   err <- getSocketOption sock SoError
	   if (err == 0)
	   	then return 0
	   	else do ioError (errnoToIOError "connect" 
	   			(Errno (fromIntegral err))
	   			Nothing Nothing)

   connectLoop
   return Connected

-----------------------------------------------------------------------------
-- Listen
--
-- The programmer must call $listen$ to tell the system software that
-- they are now interested in receiving data on this port.  This must
-- be called on the bound socket before any calls to read or write
-- data are made.

-- The programmer also gives a number which indicates the length of
-- the incoming queue of unread messages for this socket. On most
-- systems the maximum queue length is around 5.  To remove a message
-- from the queue for processing a call to $accept$ should be made.

listen :: Socket  -- Connected & Bound Socket
       -> Int 	  -- Queue Length
       -> IO ()

listen (MkSocket s _family _stype _protocol socketStatus) backlog = do
 modifyMVar_ socketStatus $ \ status -> do
 if status /= Bound 
   then
    ioError (userError ("listen: can't peform listen on socket in status " ++
          show status))
   else do
    throwSocketErrorIfMinus1Retry "listen" (c_listen s (fromIntegral backlog))
    return Listening

-----------------------------------------------------------------------------
-- Accept
--
-- A call to `accept' only returns when data is available on the given
-- socket, unless the socket has been set to non-blocking.  It will
-- return a new socket which should be used to read the incoming data and
-- should then be closed. Using the socket returned by `accept' allows
-- incoming requests to be queued on the original socket.

accept :: Socket			-- Queue Socket
       -> IO (Socket,			-- Readable Socket
	      SockAddr)			-- Peer details

accept sock@(MkSocket s family stype protocol status) = do
 currentStatus <- readMVar status
 okay <- sIsAcceptable sock
 if not okay
   then
     ioError (userError ("accept: can't perform accept on socket (" ++ (show (family,stype,protocol)) ++") in status " ++
	 show currentStatus))
   else do
     let sz = sizeOfSockAddr_Family family
     allocaBytes sz $ \ sockaddr -> do

{-# LINE 650 "Network/Socket.hsc" #-}
     with (fromIntegral sz) $ \ ptr_len -> do
     new_sock <- 

{-# LINE 656 "Network/Socket.hsc" #-}
			(c_accept s sockaddr ptr_len)

{-# LINE 660 "Network/Socket.hsc" #-}

{-# LINE 661 "Network/Socket.hsc" #-}
     addr <- peekSockAddr sockaddr
     new_status <- newMVar Connected
     return ((MkSocket new_sock family stype protocol new_status), addr)


{-# LINE 675 "Network/Socket.hsc" #-}

-----------------------------------------------------------------------------
-- sendTo & recvFrom

sendTo :: Socket	-- (possibly) bound/connected Socket
       -> String	-- Data to send
       -> SockAddr
       -> IO Int	-- Number of Bytes sent

sendTo sock xs addr = do
 withCString xs $ \str -> do
   sendBufTo sock str (length xs) addr

sendBufTo :: Socket	      -- (possibly) bound/connected Socket
          -> Ptr a -> Int     -- Data to send
          -> SockAddr
          -> IO Int	      -- Number of Bytes sent

sendBufTo (MkSocket s _family _stype _protocol status) ptr nbytes addr = do
 withSockAddr addr $ \p_addr sz -> do
   liftM fromIntegral $

{-# LINE 700 "Network/Socket.hsc" #-}
	c_sendto s ptr (fromIntegral $ nbytes) 0{-flags-} 
			p_addr (fromIntegral sz)

recvFrom :: Socket -> Int -> IO (String, Int, SockAddr)
recvFrom sock nbytes =
  allocaBytes nbytes $ \ptr -> do
    (len, sockaddr) <- recvBufFrom sock ptr nbytes
    str <- peekCStringLen (ptr, len)
    return (str, len, sockaddr)

recvBufFrom :: Socket -> Ptr a -> Int -> IO (Int, SockAddr)
recvBufFrom sock@(MkSocket s _family _stype _protocol status) ptr nbytes
 | nbytes <= 0 = ioError (mkInvalidRecvArgError "Network.Socket.recvFrom")
 | otherwise   = 
    withNewSockAddr AF_INET $ \ptr_addr sz -> do
      alloca $ \ptr_len -> do
      	poke ptr_len (fromIntegral sz)
        len <- 

{-# LINE 722 "Network/Socket.hsc" #-}
        	   c_recvfrom s ptr (fromIntegral nbytes) 0{-flags-} 
				ptr_addr ptr_len
        let len' = fromIntegral len
	if len' == 0
	 then ioError (mkEOFError "Network.Socket.recvFrom")
	 else do
   	   flg <- sIsConnected sock
	     -- For at least one implementation (WinSock 2), recvfrom() ignores
	     -- filling in the sockaddr for connected TCP sockets. Cope with 
	     -- this by using getPeerName instead.
	   sockaddr <- 
		if flg then
		   getPeerName sock
		else
		   peekSockAddr ptr_addr 
           return (len', sockaddr)

-----------------------------------------------------------------------------
-- send & recv

send :: Socket	-- Bound/Connected Socket
     -> String	-- Data to send
     -> IO Int	-- Number of Bytes sent
send (MkSocket s _family _stype _protocol status) xs = do
 let len = length xs
 withCString xs $ \str -> do
   liftM fromIntegral $

{-# LINE 753 "Network/Socket.hsc" #-}

{-# LINE 757 "Network/Socket.hsc" #-}
	c_send s str (fromIntegral len) 0{-flags-} 

{-# LINE 759 "Network/Socket.hsc" #-}

recv :: Socket -> Int -> IO String
recv sock l = recvLen sock l >>= \ (s,_) -> return s

recvLen :: Socket -> Int -> IO (String, Int)
recvLen sock@(MkSocket s _family _stype _protocol status) nbytes 
 | nbytes <= 0 = ioError (mkInvalidRecvArgError "Network.Socket.recv")
 | otherwise   = do
     allocaBytes nbytes $ \ptr -> do
        len <- 

{-# LINE 773 "Network/Socket.hsc" #-}

{-# LINE 777 "Network/Socket.hsc" #-}
        	   c_recv s ptr (fromIntegral nbytes) 0{-flags-} 

{-# LINE 779 "Network/Socket.hsc" #-}
        let len' = fromIntegral len
	if len' == 0
	 then ioError (mkEOFError "Network.Socket.recv")
	 else do
	   s <- peekCStringLen (ptr,len')
	   return (s, len')

-- ---------------------------------------------------------------------------
-- socketPort
--
-- The port number the given socket is currently connected to can be
-- determined by calling $port$, is generally only useful when bind
-- was given $aNY\_PORT$.

socketPort :: Socket		-- Connected & Bound Socket
	   -> IO PortNumber	-- Port Number of Socket
socketPort sock@(MkSocket _ AF_INET _ _ _) = do
    (SockAddrInet port _) <- getSocketName sock
    return port
socketPort (MkSocket _ family _ _ _) =
    ioError (userError ("socketPort: not supported for Family " ++ show family))


-- ---------------------------------------------------------------------------
-- getPeerName

-- Calling $getPeerName$ returns the address details of the machine,
-- other than the local one, which is connected to the socket. This is
-- used in programs such as FTP to determine where to send the
-- returning data.  The corresponding call to get the details of the
-- local machine is $getSocketName$.

getPeerName   :: Socket -> IO SockAddr
getPeerName (MkSocket s family _ _ _) = do
 withNewSockAddr family $ \ptr sz -> do
   with (fromIntegral sz) $ \int_star -> do
   throwSocketErrorIfMinus1Retry "getPeerName" $ c_getpeername s ptr int_star
   sz <- peek int_star
   peekSockAddr ptr
    
getSocketName :: Socket -> IO SockAddr
getSocketName (MkSocket s family _ _ _) = do
 withNewSockAddr family $ \ptr sz -> do
   with (fromIntegral sz) $ \int_star -> do
   throwSocketErrorIfMinus1Retry "getSocketName" $ c_getsockname s ptr int_star
   peekSockAddr ptr

-----------------------------------------------------------------------------
-- Socket Properties

data SocketOption
    = DummySocketOption__

{-# LINE 832 "Network/Socket.hsc" #-}
    | Debug         {- SO_DEBUG     -}

{-# LINE 834 "Network/Socket.hsc" #-}

{-# LINE 835 "Network/Socket.hsc" #-}
    | ReuseAddr     {- SO_REUSEADDR -}

{-# LINE 837 "Network/Socket.hsc" #-}

{-# LINE 838 "Network/Socket.hsc" #-}
    | Type          {- SO_TYPE      -}

{-# LINE 840 "Network/Socket.hsc" #-}

{-# LINE 841 "Network/Socket.hsc" #-}
    | SoError       {- SO_ERROR     -}

{-# LINE 843 "Network/Socket.hsc" #-}

{-# LINE 844 "Network/Socket.hsc" #-}
    | DontRoute     {- SO_DONTROUTE -}

{-# LINE 846 "Network/Socket.hsc" #-}

{-# LINE 847 "Network/Socket.hsc" #-}
    | Broadcast     {- SO_BROADCAST -}

{-# LINE 849 "Network/Socket.hsc" #-}

{-# LINE 850 "Network/Socket.hsc" #-}
    | SendBuffer    {- SO_SNDBUF    -}

{-# LINE 852 "Network/Socket.hsc" #-}

{-# LINE 853 "Network/Socket.hsc" #-}
    | RecvBuffer    {- SO_RCVBUF    -}

{-# LINE 855 "Network/Socket.hsc" #-}

{-# LINE 856 "Network/Socket.hsc" #-}
    | KeepAlive     {- SO_KEEPALIVE -}

{-# LINE 858 "Network/Socket.hsc" #-}

{-# LINE 859 "Network/Socket.hsc" #-}
    | OOBInline     {- SO_OOBINLINE -}

{-# LINE 861 "Network/Socket.hsc" #-}

{-# LINE 862 "Network/Socket.hsc" #-}
    | TimeToLive    {- IP_TTL       -}

{-# LINE 864 "Network/Socket.hsc" #-}

{-# LINE 865 "Network/Socket.hsc" #-}
    | MaxSegment    {- TCP_MAXSEG   -}

{-# LINE 867 "Network/Socket.hsc" #-}

{-# LINE 868 "Network/Socket.hsc" #-}
    | NoDelay       {- TCP_NODELAY  -}

{-# LINE 870 "Network/Socket.hsc" #-}

{-# LINE 871 "Network/Socket.hsc" #-}
    | Linger        {- SO_LINGER    -}

{-# LINE 873 "Network/Socket.hsc" #-}

{-# LINE 874 "Network/Socket.hsc" #-}
    | ReusePort     {- SO_REUSEPORT -}

{-# LINE 876 "Network/Socket.hsc" #-}

{-# LINE 877 "Network/Socket.hsc" #-}
    | RecvLowWater  {- SO_RCVLOWAT  -}

{-# LINE 879 "Network/Socket.hsc" #-}

{-# LINE 880 "Network/Socket.hsc" #-}
    | SendLowWater  {- SO_SNDLOWAT  -}

{-# LINE 882 "Network/Socket.hsc" #-}

{-# LINE 883 "Network/Socket.hsc" #-}
    | RecvTimeOut   {- SO_RCVTIMEO  -}

{-# LINE 885 "Network/Socket.hsc" #-}

{-# LINE 886 "Network/Socket.hsc" #-}
    | SendTimeOut   {- SO_SNDTIMEO  -}

{-# LINE 888 "Network/Socket.hsc" #-}

{-# LINE 891 "Network/Socket.hsc" #-}

socketOptionTc = mkTyCon "SocketOption"; instance Typeable SocketOption where { typeOf _ = mkTyConApp socketOptionTc [] }

socketOptLevel :: SocketOption -> CInt
socketOptLevel so = 
  case so of

{-# LINE 898 "Network/Socket.hsc" #-}
    TimeToLive   -> 0
{-# LINE 899 "Network/Socket.hsc" #-}

{-# LINE 900 "Network/Socket.hsc" #-}

{-# LINE 901 "Network/Socket.hsc" #-}
    MaxSegment   -> 6
{-# LINE 902 "Network/Socket.hsc" #-}

{-# LINE 903 "Network/Socket.hsc" #-}

{-# LINE 904 "Network/Socket.hsc" #-}
    NoDelay      -> 6
{-# LINE 905 "Network/Socket.hsc" #-}

{-# LINE 906 "Network/Socket.hsc" #-}
    _            -> 1
{-# LINE 907 "Network/Socket.hsc" #-}

packSocketOption :: SocketOption -> CInt
packSocketOption so =
  case so of

{-# LINE 912 "Network/Socket.hsc" #-}
    Debug         -> 1
{-# LINE 913 "Network/Socket.hsc" #-}

{-# LINE 914 "Network/Socket.hsc" #-}

{-# LINE 915 "Network/Socket.hsc" #-}
    ReuseAddr     -> 2
{-# LINE 916 "Network/Socket.hsc" #-}

{-# LINE 917 "Network/Socket.hsc" #-}

{-# LINE 918 "Network/Socket.hsc" #-}
    Type          -> 3
{-# LINE 919 "Network/Socket.hsc" #-}

{-# LINE 920 "Network/Socket.hsc" #-}

{-# LINE 921 "Network/Socket.hsc" #-}
    SoError       -> 4
{-# LINE 922 "Network/Socket.hsc" #-}

{-# LINE 923 "Network/Socket.hsc" #-}

{-# LINE 924 "Network/Socket.hsc" #-}
    DontRoute     -> 5
{-# LINE 925 "Network/Socket.hsc" #-}

{-# LINE 926 "Network/Socket.hsc" #-}

{-# LINE 927 "Network/Socket.hsc" #-}
    Broadcast     -> 6
{-# LINE 928 "Network/Socket.hsc" #-}

{-# LINE 929 "Network/Socket.hsc" #-}

{-# LINE 930 "Network/Socket.hsc" #-}
    SendBuffer    -> 7
{-# LINE 931 "Network/Socket.hsc" #-}

{-# LINE 932 "Network/Socket.hsc" #-}

{-# LINE 933 "Network/Socket.hsc" #-}
    RecvBuffer    -> 8
{-# LINE 934 "Network/Socket.hsc" #-}

{-# LINE 935 "Network/Socket.hsc" #-}

{-# LINE 936 "Network/Socket.hsc" #-}
    KeepAlive     -> 9
{-# LINE 937 "Network/Socket.hsc" #-}

{-# LINE 938 "Network/Socket.hsc" #-}

{-# LINE 939 "Network/Socket.hsc" #-}
    OOBInline     -> 10
{-# LINE 940 "Network/Socket.hsc" #-}

{-# LINE 941 "Network/Socket.hsc" #-}

{-# LINE 942 "Network/Socket.hsc" #-}
    TimeToLive    -> 2
{-# LINE 943 "Network/Socket.hsc" #-}

{-# LINE 944 "Network/Socket.hsc" #-}

{-# LINE 945 "Network/Socket.hsc" #-}
    MaxSegment    -> 2
{-# LINE 946 "Network/Socket.hsc" #-}

{-# LINE 947 "Network/Socket.hsc" #-}

{-# LINE 948 "Network/Socket.hsc" #-}
    NoDelay       -> 1
{-# LINE 949 "Network/Socket.hsc" #-}

{-# LINE 950 "Network/Socket.hsc" #-}

{-# LINE 951 "Network/Socket.hsc" #-}
    Linger	  -> 13
{-# LINE 952 "Network/Socket.hsc" #-}

{-# LINE 953 "Network/Socket.hsc" #-}

{-# LINE 954 "Network/Socket.hsc" #-}
    ReusePort     -> 15
{-# LINE 955 "Network/Socket.hsc" #-}

{-# LINE 956 "Network/Socket.hsc" #-}

{-# LINE 957 "Network/Socket.hsc" #-}
    RecvLowWater  -> 18
{-# LINE 958 "Network/Socket.hsc" #-}

{-# LINE 959 "Network/Socket.hsc" #-}

{-# LINE 960 "Network/Socket.hsc" #-}
    SendLowWater  -> 19
{-# LINE 961 "Network/Socket.hsc" #-}

{-# LINE 962 "Network/Socket.hsc" #-}

{-# LINE 963 "Network/Socket.hsc" #-}
    RecvTimeOut   -> 20
{-# LINE 964 "Network/Socket.hsc" #-}

{-# LINE 965 "Network/Socket.hsc" #-}

{-# LINE 966 "Network/Socket.hsc" #-}
    SendTimeOut   -> 21
{-# LINE 967 "Network/Socket.hsc" #-}

{-# LINE 968 "Network/Socket.hsc" #-}

{-# LINE 971 "Network/Socket.hsc" #-}

setSocketOption :: Socket 
		-> SocketOption -- Option Name
		-> Int		-- Option Value
		-> IO ()
setSocketOption (MkSocket s _ _ _ _) so v = do
   with (fromIntegral v) $ \ptr_v -> do
   throwErrnoIfMinus1_ "setSocketOption" $
       c_setsockopt s (socketOptLevel so) (packSocketOption so) ptr_v 
	  (fromIntegral (sizeOf v))
   return ()


getSocketOption :: Socket
		-> SocketOption  -- Option Name
		-> IO Int	 -- Option Value
getSocketOption (MkSocket s _ _ _ _) so = do
   alloca $ \ptr_v ->
     with (fromIntegral (sizeOf (undefined :: CInt))) $ \ptr_sz -> do
       throwErrnoIfMinus1 "getSocketOption" $
	 c_getsockopt s (socketOptLevel so) (packSocketOption so) ptr_v ptr_sz
       fromIntegral `liftM` peek ptr_v



{-# LINE 1013 "Network/Socket.hsc" #-}


{-# LINE 1015 "Network/Socket.hsc" #-}
-- sending/receiving ancillary socket data; low-level mechanism
-- for transmitting file descriptors, mainly.
sendFd :: Socket -> CInt -> IO ()
sendFd sock outfd = do
  let fd = fdSocket sock

{-# LINE 1025 "Network/Socket.hsc" #-}
  c_sendFd fd outfd

{-# LINE 1027 "Network/Socket.hsc" #-}
   -- Note: If Winsock supported FD-passing, thi would have been 
   -- incorrect (since socket FDs need to be closed via closesocket().)
  c_close outfd
  return ()
  
recvFd :: Socket -> IO CInt
recvFd sock = do
  let fd = fdSocket sock
  theFd <- 

{-# LINE 1040 "Network/Socket.hsc" #-}
         c_recvFd fd
  return theFd


sendAncillary :: Socket
	      -> Int
	      -> Int
	      -> Int
	      -> Ptr a
	      -> Int
	      -> IO ()
sendAncillary sock level ty flags datum len = do
  let fd = fdSocket sock
  _ <-

{-# LINE 1058 "Network/Socket.hsc" #-}
     c_sendAncillary fd (fromIntegral level) (fromIntegral ty)
     			(fromIntegral flags) datum (fromIntegral len)
  return ()

recvAncillary :: Socket
	      -> Int
	      -> Int
	      -> IO (Int,Int,Ptr a,Int)
recvAncillary sock flags len = do
  let fd = fdSocket sock
  alloca      $ \ ptr_len   ->
   alloca      $ \ ptr_lev   ->
    alloca      $ \ ptr_ty    ->
     alloca      $ \ ptr_pData -> do
      poke ptr_len (fromIntegral len)
      _ <- 

{-# LINE 1078 "Network/Socket.hsc" #-}
	    c_recvAncillary fd ptr_lev ptr_ty (fromIntegral flags) ptr_pData ptr_len
      len <- fromIntegral `liftM` peek ptr_len
      lev <- fromIntegral `liftM` peek ptr_lev
      ty  <- fromIntegral `liftM` peek ptr_ty
      pD  <- peek ptr_pData
      return (lev,ty,pD, len)
foreign import ccall unsafe "sendAncillary"
  c_sendAncillary :: CInt -> CInt -> CInt -> CInt -> Ptr a -> CInt -> IO CInt

foreign import ccall unsafe "recvAncillary"
  c_recvAncillary :: CInt -> Ptr CInt -> Ptr CInt -> CInt -> Ptr (Ptr a) -> Ptr CInt -> IO CInt

foreign import ccall unsafe "sendFd" c_sendFd :: CInt -> CInt -> IO CInt
foreign import ccall unsafe "recvFd" c_recvFd :: CInt -> IO CInt


{-# LINE 1094 "Network/Socket.hsc" #-}


{-
A calling sequence table for the main functions is shown in the table below.

\begin{figure}[h]
\begin{center}
\begin{tabular}{|l|c|c|c|c|c|c|c|}d
\hline
{\bf A Call to} & socket & connect & bindSocket & listen & accept & read & write \\
\hline
{\bf Precedes} & & & & & & & \\
\hline 
socket &	&	  &	       &	&	 &	& \\
\hline
connect & +	&	  &	       &	&	 &	& \\
\hline
bindSocket & +	&	  &	       &	&	 &	& \\
\hline
listen &	&	  & +	       &	&	 &	& \\
\hline
accept &	&	  &	       &  +	&	 &	& \\
\hline
read   &	&   +	  &	       &  +	&  +	 &  +	& + \\
\hline
write  &	&   +	  &	       &  +	&  +	 &  +	& + \\
\hline
\end{tabular}
\caption{Sequence Table for Major functions of Socket}
\label{tab:api-seq}
\end{center}
\end{figure}
-}

-- ---------------------------------------------------------------------------
-- OS Dependent Definitions
    
unpackFamily	:: CInt -> Family
packFamily	:: Family -> CInt

packSocketType	:: SocketType -> CInt

-- | Address Families.
--
-- This data type might have different constructors depending on what is
-- supported by the operating system.
data Family
	= AF_UNSPEC	-- unspecified

{-# LINE 1143 "Network/Socket.hsc" #-}
	| AF_UNIX	-- local to host (pipes, portals

{-# LINE 1145 "Network/Socket.hsc" #-}

{-# LINE 1146 "Network/Socket.hsc" #-}
	| AF_INET	-- internetwork: UDP, TCP, etc

{-# LINE 1148 "Network/Socket.hsc" #-}

{-# LINE 1149 "Network/Socket.hsc" #-}
        | AF_INET6	-- Internet Protocol version 6

{-# LINE 1151 "Network/Socket.hsc" #-}

{-# LINE 1154 "Network/Socket.hsc" #-}

{-# LINE 1157 "Network/Socket.hsc" #-}

{-# LINE 1160 "Network/Socket.hsc" #-}

{-# LINE 1163 "Network/Socket.hsc" #-}

{-# LINE 1166 "Network/Socket.hsc" #-}

{-# LINE 1169 "Network/Socket.hsc" #-}

{-# LINE 1172 "Network/Socket.hsc" #-}

{-# LINE 1175 "Network/Socket.hsc" #-}

{-# LINE 1176 "Network/Socket.hsc" #-}
	| AF_SNA	-- IBM SNA

{-# LINE 1178 "Network/Socket.hsc" #-}

{-# LINE 1179 "Network/Socket.hsc" #-}
	| AF_DECnet	-- DECnet

{-# LINE 1181 "Network/Socket.hsc" #-}

{-# LINE 1184 "Network/Socket.hsc" #-}

{-# LINE 1187 "Network/Socket.hsc" #-}

{-# LINE 1190 "Network/Socket.hsc" #-}

{-# LINE 1191 "Network/Socket.hsc" #-}
	| AF_APPLETALK	-- Apple Talk

{-# LINE 1193 "Network/Socket.hsc" #-}

{-# LINE 1194 "Network/Socket.hsc" #-}
	| AF_ROUTE	-- Internal Routing Protocol 

{-# LINE 1196 "Network/Socket.hsc" #-}

{-# LINE 1199 "Network/Socket.hsc" #-}

{-# LINE 1202 "Network/Socket.hsc" #-}

{-# LINE 1205 "Network/Socket.hsc" #-}

{-# LINE 1208 "Network/Socket.hsc" #-}

{-# LINE 1211 "Network/Socket.hsc" #-}

{-# LINE 1214 "Network/Socket.hsc" #-}

{-# LINE 1215 "Network/Socket.hsc" #-}
	| AF_X25	-- CCITT X.25

{-# LINE 1217 "Network/Socket.hsc" #-}

{-# LINE 1218 "Network/Socket.hsc" #-}
	| AF_AX25

{-# LINE 1220 "Network/Socket.hsc" #-}

{-# LINE 1223 "Network/Socket.hsc" #-}

{-# LINE 1226 "Network/Socket.hsc" #-}

{-# LINE 1227 "Network/Socket.hsc" #-}
	| AF_IPX	-- Novell Internet Protocol

{-# LINE 1229 "Network/Socket.hsc" #-}

{-# LINE 1232 "Network/Socket.hsc" #-}

{-# LINE 1235 "Network/Socket.hsc" #-}

{-# LINE 1238 "Network/Socket.hsc" #-}

{-# LINE 1241 "Network/Socket.hsc" #-}

{-# LINE 1244 "Network/Socket.hsc" #-}

{-# LINE 1247 "Network/Socket.hsc" #-}

{-# LINE 1250 "Network/Socket.hsc" #-}

{-# LINE 1253 "Network/Socket.hsc" #-}

{-# LINE 1256 "Network/Socket.hsc" #-}

{-# LINE 1259 "Network/Socket.hsc" #-}

{-# LINE 1262 "Network/Socket.hsc" #-}

{-# LINE 1265 "Network/Socket.hsc" #-}

{-# LINE 1266 "Network/Socket.hsc" #-}
        | AF_ISDN         -- Integrated Services Digital Network

{-# LINE 1268 "Network/Socket.hsc" #-}

{-# LINE 1271 "Network/Socket.hsc" #-}

{-# LINE 1274 "Network/Socket.hsc" #-}

{-# LINE 1277 "Network/Socket.hsc" #-}

{-# LINE 1280 "Network/Socket.hsc" #-}

{-# LINE 1283 "Network/Socket.hsc" #-}

{-# LINE 1286 "Network/Socket.hsc" #-}

{-# LINE 1289 "Network/Socket.hsc" #-}

{-# LINE 1292 "Network/Socket.hsc" #-}

{-# LINE 1293 "Network/Socket.hsc" #-}
	| AF_NETROM			-- Amateur radio NetROM

{-# LINE 1295 "Network/Socket.hsc" #-}

{-# LINE 1296 "Network/Socket.hsc" #-}
	| AF_BRIDGE			-- multiprotocol bridge

{-# LINE 1298 "Network/Socket.hsc" #-}

{-# LINE 1299 "Network/Socket.hsc" #-}
	| AF_ATMPVC			-- ATM PVCs

{-# LINE 1301 "Network/Socket.hsc" #-}

{-# LINE 1302 "Network/Socket.hsc" #-}
	| AF_ROSE			-- Amateur Radio X.25 PLP

{-# LINE 1304 "Network/Socket.hsc" #-}

{-# LINE 1305 "Network/Socket.hsc" #-}
	| AF_NETBEUI			-- 802.2LLC

{-# LINE 1307 "Network/Socket.hsc" #-}

{-# LINE 1308 "Network/Socket.hsc" #-}
	| AF_SECURITY			-- Security callback pseudo AF

{-# LINE 1310 "Network/Socket.hsc" #-}

{-# LINE 1311 "Network/Socket.hsc" #-}
	| AF_PACKET			-- Packet family

{-# LINE 1313 "Network/Socket.hsc" #-}

{-# LINE 1314 "Network/Socket.hsc" #-}
	| AF_ASH			-- Ash

{-# LINE 1316 "Network/Socket.hsc" #-}

{-# LINE 1317 "Network/Socket.hsc" #-}
	| AF_ECONET			-- Acorn Econet

{-# LINE 1319 "Network/Socket.hsc" #-}

{-# LINE 1320 "Network/Socket.hsc" #-}
	| AF_ATMSVC			-- ATM SVCs

{-# LINE 1322 "Network/Socket.hsc" #-}

{-# LINE 1323 "Network/Socket.hsc" #-}
	| AF_IRDA			-- IRDA sockets

{-# LINE 1325 "Network/Socket.hsc" #-}

{-# LINE 1326 "Network/Socket.hsc" #-}
	| AF_PPPOX			-- PPPoX sockets

{-# LINE 1328 "Network/Socket.hsc" #-}

{-# LINE 1329 "Network/Socket.hsc" #-}
	| AF_WANPIPE			-- Wanpipe API sockets

{-# LINE 1331 "Network/Socket.hsc" #-}

{-# LINE 1332 "Network/Socket.hsc" #-}
	| AF_BLUETOOTH			-- bluetooth sockets

{-# LINE 1334 "Network/Socket.hsc" #-}
	deriving (Eq, Ord, Read, Show)

------ ------
			
packFamily f = case f of
	AF_UNSPEC -> 0
{-# LINE 1340 "Network/Socket.hsc" #-}

{-# LINE 1341 "Network/Socket.hsc" #-}
	AF_UNIX -> 1
{-# LINE 1342 "Network/Socket.hsc" #-}

{-# LINE 1343 "Network/Socket.hsc" #-}

{-# LINE 1344 "Network/Socket.hsc" #-}
	AF_INET -> 2
{-# LINE 1345 "Network/Socket.hsc" #-}

{-# LINE 1346 "Network/Socket.hsc" #-}

{-# LINE 1347 "Network/Socket.hsc" #-}
        AF_INET6 -> 10
{-# LINE 1348 "Network/Socket.hsc" #-}

{-# LINE 1349 "Network/Socket.hsc" #-}

{-# LINE 1352 "Network/Socket.hsc" #-}

{-# LINE 1355 "Network/Socket.hsc" #-}

{-# LINE 1358 "Network/Socket.hsc" #-}

{-# LINE 1361 "Network/Socket.hsc" #-}

{-# LINE 1364 "Network/Socket.hsc" #-}

{-# LINE 1367 "Network/Socket.hsc" #-}

{-# LINE 1370 "Network/Socket.hsc" #-}

{-# LINE 1373 "Network/Socket.hsc" #-}

{-# LINE 1374 "Network/Socket.hsc" #-}
	AF_SNA -> 22
{-# LINE 1375 "Network/Socket.hsc" #-}

{-# LINE 1376 "Network/Socket.hsc" #-}

{-# LINE 1377 "Network/Socket.hsc" #-}
	AF_DECnet -> 12
{-# LINE 1378 "Network/Socket.hsc" #-}

{-# LINE 1379 "Network/Socket.hsc" #-}

{-# LINE 1382 "Network/Socket.hsc" #-}

{-# LINE 1385 "Network/Socket.hsc" #-}

{-# LINE 1388 "Network/Socket.hsc" #-}

{-# LINE 1389 "Network/Socket.hsc" #-}
	AF_APPLETALK -> 5
{-# LINE 1390 "Network/Socket.hsc" #-}

{-# LINE 1391 "Network/Socket.hsc" #-}

{-# LINE 1392 "Network/Socket.hsc" #-}
	AF_ROUTE -> 16
{-# LINE 1393 "Network/Socket.hsc" #-}

{-# LINE 1394 "Network/Socket.hsc" #-}

{-# LINE 1397 "Network/Socket.hsc" #-}

{-# LINE 1400 "Network/Socket.hsc" #-}

{-# LINE 1403 "Network/Socket.hsc" #-}

{-# LINE 1406 "Network/Socket.hsc" #-}

{-# LINE 1409 "Network/Socket.hsc" #-}

{-# LINE 1412 "Network/Socket.hsc" #-}

{-# LINE 1413 "Network/Socket.hsc" #-}
	AF_X25 -> 9
{-# LINE 1414 "Network/Socket.hsc" #-}

{-# LINE 1415 "Network/Socket.hsc" #-}

{-# LINE 1416 "Network/Socket.hsc" #-}
	AF_AX25 -> 3
{-# LINE 1417 "Network/Socket.hsc" #-}

{-# LINE 1418 "Network/Socket.hsc" #-}

{-# LINE 1421 "Network/Socket.hsc" #-}

{-# LINE 1424 "Network/Socket.hsc" #-}

{-# LINE 1425 "Network/Socket.hsc" #-}
	AF_IPX -> 4
{-# LINE 1426 "Network/Socket.hsc" #-}

{-# LINE 1427 "Network/Socket.hsc" #-}

{-# LINE 1430 "Network/Socket.hsc" #-}

{-# LINE 1433 "Network/Socket.hsc" #-}

{-# LINE 1436 "Network/Socket.hsc" #-}

{-# LINE 1439 "Network/Socket.hsc" #-}

{-# LINE 1442 "Network/Socket.hsc" #-}

{-# LINE 1445 "Network/Socket.hsc" #-}

{-# LINE 1448 "Network/Socket.hsc" #-}

{-# LINE 1451 "Network/Socket.hsc" #-}

{-# LINE 1454 "Network/Socket.hsc" #-}

{-# LINE 1457 "Network/Socket.hsc" #-}

{-# LINE 1460 "Network/Socket.hsc" #-}

{-# LINE 1463 "Network/Socket.hsc" #-}

{-# LINE 1464 "Network/Socket.hsc" #-}
        AF_ISDN -> 34
{-# LINE 1465 "Network/Socket.hsc" #-}

{-# LINE 1466 "Network/Socket.hsc" #-}

{-# LINE 1469 "Network/Socket.hsc" #-}

{-# LINE 1472 "Network/Socket.hsc" #-}

{-# LINE 1475 "Network/Socket.hsc" #-}

{-# LINE 1478 "Network/Socket.hsc" #-}

{-# LINE 1481 "Network/Socket.hsc" #-}

{-# LINE 1484 "Network/Socket.hsc" #-}

{-# LINE 1487 "Network/Socket.hsc" #-}

{-# LINE 1490 "Network/Socket.hsc" #-}

{-# LINE 1491 "Network/Socket.hsc" #-}
	AF_NETROM -> 6
{-# LINE 1492 "Network/Socket.hsc" #-}

{-# LINE 1493 "Network/Socket.hsc" #-}

{-# LINE 1494 "Network/Socket.hsc" #-}
	AF_BRIDGE -> 7
{-# LINE 1495 "Network/Socket.hsc" #-}

{-# LINE 1496 "Network/Socket.hsc" #-}

{-# LINE 1497 "Network/Socket.hsc" #-}
	AF_ATMPVC -> 8
{-# LINE 1498 "Network/Socket.hsc" #-}

{-# LINE 1499 "Network/Socket.hsc" #-}

{-# LINE 1500 "Network/Socket.hsc" #-}
	AF_ROSE -> 11
{-# LINE 1501 "Network/Socket.hsc" #-}

{-# LINE 1502 "Network/Socket.hsc" #-}

{-# LINE 1503 "Network/Socket.hsc" #-}
	AF_NETBEUI -> 13
{-# LINE 1504 "Network/Socket.hsc" #-}

{-# LINE 1505 "Network/Socket.hsc" #-}

{-# LINE 1506 "Network/Socket.hsc" #-}
	AF_SECURITY -> 14
{-# LINE 1507 "Network/Socket.hsc" #-}

{-# LINE 1508 "Network/Socket.hsc" #-}

{-# LINE 1509 "Network/Socket.hsc" #-}
	AF_PACKET -> 17
{-# LINE 1510 "Network/Socket.hsc" #-}

{-# LINE 1511 "Network/Socket.hsc" #-}

{-# LINE 1512 "Network/Socket.hsc" #-}
	AF_ASH -> 18
{-# LINE 1513 "Network/Socket.hsc" #-}

{-# LINE 1514 "Network/Socket.hsc" #-}

{-# LINE 1515 "Network/Socket.hsc" #-}
	AF_ECONET -> 19
{-# LINE 1516 "Network/Socket.hsc" #-}

{-# LINE 1517 "Network/Socket.hsc" #-}

{-# LINE 1518 "Network/Socket.hsc" #-}
	AF_ATMSVC -> 20
{-# LINE 1519 "Network/Socket.hsc" #-}

{-# LINE 1520 "Network/Socket.hsc" #-}

{-# LINE 1521 "Network/Socket.hsc" #-}
	AF_IRDA -> 23
{-# LINE 1522 "Network/Socket.hsc" #-}

{-# LINE 1523 "Network/Socket.hsc" #-}

{-# LINE 1524 "Network/Socket.hsc" #-}
	AF_PPPOX -> 24
{-# LINE 1525 "Network/Socket.hsc" #-}

{-# LINE 1526 "Network/Socket.hsc" #-}

{-# LINE 1527 "Network/Socket.hsc" #-}
	AF_WANPIPE -> 25
{-# LINE 1528 "Network/Socket.hsc" #-}

{-# LINE 1529 "Network/Socket.hsc" #-}

{-# LINE 1530 "Network/Socket.hsc" #-}
	AF_BLUETOOTH -> 31
{-# LINE 1531 "Network/Socket.hsc" #-}

{-# LINE 1532 "Network/Socket.hsc" #-}

--------- ----------

unpackFamily f = case f of
	(0) -> AF_UNSPEC
{-# LINE 1537 "Network/Socket.hsc" #-}

{-# LINE 1538 "Network/Socket.hsc" #-}
	(1) -> AF_UNIX
{-# LINE 1539 "Network/Socket.hsc" #-}

{-# LINE 1540 "Network/Socket.hsc" #-}

{-# LINE 1541 "Network/Socket.hsc" #-}
	(2) -> AF_INET
{-# LINE 1542 "Network/Socket.hsc" #-}

{-# LINE 1543 "Network/Socket.hsc" #-}

{-# LINE 1544 "Network/Socket.hsc" #-}
        (10) -> AF_INET6
{-# LINE 1545 "Network/Socket.hsc" #-}

{-# LINE 1546 "Network/Socket.hsc" #-}

{-# LINE 1549 "Network/Socket.hsc" #-}

{-# LINE 1552 "Network/Socket.hsc" #-}

{-# LINE 1555 "Network/Socket.hsc" #-}

{-# LINE 1558 "Network/Socket.hsc" #-}

{-# LINE 1561 "Network/Socket.hsc" #-}

{-# LINE 1564 "Network/Socket.hsc" #-}

{-# LINE 1567 "Network/Socket.hsc" #-}

{-# LINE 1570 "Network/Socket.hsc" #-}

{-# LINE 1571 "Network/Socket.hsc" #-}
	(22) -> AF_SNA
{-# LINE 1572 "Network/Socket.hsc" #-}

{-# LINE 1573 "Network/Socket.hsc" #-}

{-# LINE 1574 "Network/Socket.hsc" #-}
	(12) -> AF_DECnet
{-# LINE 1575 "Network/Socket.hsc" #-}

{-# LINE 1576 "Network/Socket.hsc" #-}

{-# LINE 1579 "Network/Socket.hsc" #-}

{-# LINE 1582 "Network/Socket.hsc" #-}

{-# LINE 1585 "Network/Socket.hsc" #-}

{-# LINE 1586 "Network/Socket.hsc" #-}
	(5) -> AF_APPLETALK
{-# LINE 1587 "Network/Socket.hsc" #-}

{-# LINE 1588 "Network/Socket.hsc" #-}

{-# LINE 1589 "Network/Socket.hsc" #-}
	(16) -> AF_ROUTE
{-# LINE 1590 "Network/Socket.hsc" #-}

{-# LINE 1591 "Network/Socket.hsc" #-}

{-# LINE 1594 "Network/Socket.hsc" #-}

{-# LINE 1597 "Network/Socket.hsc" #-}

{-# LINE 1600 "Network/Socket.hsc" #-}

{-# LINE 1603 "Network/Socket.hsc" #-}

{-# LINE 1608 "Network/Socket.hsc" #-}

{-# LINE 1611 "Network/Socket.hsc" #-}

{-# LINE 1612 "Network/Socket.hsc" #-}
	(9) -> AF_X25
{-# LINE 1613 "Network/Socket.hsc" #-}

{-# LINE 1614 "Network/Socket.hsc" #-}

{-# LINE 1615 "Network/Socket.hsc" #-}
	(3) -> AF_AX25
{-# LINE 1616 "Network/Socket.hsc" #-}

{-# LINE 1617 "Network/Socket.hsc" #-}

{-# LINE 1620 "Network/Socket.hsc" #-}

{-# LINE 1623 "Network/Socket.hsc" #-}

{-# LINE 1624 "Network/Socket.hsc" #-}
	(4) -> AF_IPX
{-# LINE 1625 "Network/Socket.hsc" #-}

{-# LINE 1626 "Network/Socket.hsc" #-}

{-# LINE 1629 "Network/Socket.hsc" #-}

{-# LINE 1632 "Network/Socket.hsc" #-}

{-# LINE 1635 "Network/Socket.hsc" #-}

{-# LINE 1638 "Network/Socket.hsc" #-}

{-# LINE 1641 "Network/Socket.hsc" #-}

{-# LINE 1644 "Network/Socket.hsc" #-}

{-# LINE 1647 "Network/Socket.hsc" #-}

{-# LINE 1650 "Network/Socket.hsc" #-}

{-# LINE 1653 "Network/Socket.hsc" #-}

{-# LINE 1656 "Network/Socket.hsc" #-}

{-# LINE 1659 "Network/Socket.hsc" #-}

{-# LINE 1662 "Network/Socket.hsc" #-}

{-# LINE 1663 "Network/Socket.hsc" #-}
        (34) -> AF_ISDN
{-# LINE 1664 "Network/Socket.hsc" #-}

{-# LINE 1665 "Network/Socket.hsc" #-}

{-# LINE 1668 "Network/Socket.hsc" #-}

{-# LINE 1671 "Network/Socket.hsc" #-}

{-# LINE 1674 "Network/Socket.hsc" #-}

{-# LINE 1677 "Network/Socket.hsc" #-}

{-# LINE 1680 "Network/Socket.hsc" #-}

{-# LINE 1683 "Network/Socket.hsc" #-}

{-# LINE 1686 "Network/Socket.hsc" #-}

{-# LINE 1689 "Network/Socket.hsc" #-}

{-# LINE 1690 "Network/Socket.hsc" #-}
	(6) -> AF_NETROM
{-# LINE 1691 "Network/Socket.hsc" #-}

{-# LINE 1692 "Network/Socket.hsc" #-}

{-# LINE 1693 "Network/Socket.hsc" #-}
	(7) -> AF_BRIDGE
{-# LINE 1694 "Network/Socket.hsc" #-}

{-# LINE 1695 "Network/Socket.hsc" #-}

{-# LINE 1696 "Network/Socket.hsc" #-}
	(8) -> AF_ATMPVC
{-# LINE 1697 "Network/Socket.hsc" #-}

{-# LINE 1698 "Network/Socket.hsc" #-}

{-# LINE 1699 "Network/Socket.hsc" #-}
	(11) -> AF_ROSE
{-# LINE 1700 "Network/Socket.hsc" #-}

{-# LINE 1701 "Network/Socket.hsc" #-}

{-# LINE 1702 "Network/Socket.hsc" #-}
	(13) -> AF_NETBEUI
{-# LINE 1703 "Network/Socket.hsc" #-}

{-# LINE 1704 "Network/Socket.hsc" #-}

{-# LINE 1705 "Network/Socket.hsc" #-}
	(14) -> AF_SECURITY
{-# LINE 1706 "Network/Socket.hsc" #-}

{-# LINE 1707 "Network/Socket.hsc" #-}

{-# LINE 1708 "Network/Socket.hsc" #-}
	(17) -> AF_PACKET
{-# LINE 1709 "Network/Socket.hsc" #-}

{-# LINE 1710 "Network/Socket.hsc" #-}

{-# LINE 1711 "Network/Socket.hsc" #-}
	(18) -> AF_ASH
{-# LINE 1712 "Network/Socket.hsc" #-}

{-# LINE 1713 "Network/Socket.hsc" #-}

{-# LINE 1714 "Network/Socket.hsc" #-}
	(19) -> AF_ECONET
{-# LINE 1715 "Network/Socket.hsc" #-}

{-# LINE 1716 "Network/Socket.hsc" #-}

{-# LINE 1717 "Network/Socket.hsc" #-}
	(20) -> AF_ATMSVC
{-# LINE 1718 "Network/Socket.hsc" #-}

{-# LINE 1719 "Network/Socket.hsc" #-}

{-# LINE 1720 "Network/Socket.hsc" #-}
	(23) -> AF_IRDA
{-# LINE 1721 "Network/Socket.hsc" #-}

{-# LINE 1722 "Network/Socket.hsc" #-}

{-# LINE 1723 "Network/Socket.hsc" #-}
	(24) -> AF_PPPOX
{-# LINE 1724 "Network/Socket.hsc" #-}

{-# LINE 1725 "Network/Socket.hsc" #-}

{-# LINE 1726 "Network/Socket.hsc" #-}
	(25) -> AF_WANPIPE
{-# LINE 1727 "Network/Socket.hsc" #-}

{-# LINE 1728 "Network/Socket.hsc" #-}

{-# LINE 1729 "Network/Socket.hsc" #-}
	(31) -> AF_BLUETOOTH
{-# LINE 1730 "Network/Socket.hsc" #-}

{-# LINE 1731 "Network/Socket.hsc" #-}

-- Socket Types.

-- | Socket Types.
--
-- This data type might have different constructors depending on what is
-- supported by the operating system.
data SocketType
	= NoSocketType

{-# LINE 1741 "Network/Socket.hsc" #-}
	| Stream 

{-# LINE 1743 "Network/Socket.hsc" #-}

{-# LINE 1744 "Network/Socket.hsc" #-}
	| Datagram

{-# LINE 1746 "Network/Socket.hsc" #-}

{-# LINE 1747 "Network/Socket.hsc" #-}
	| Raw 

{-# LINE 1749 "Network/Socket.hsc" #-}

{-# LINE 1750 "Network/Socket.hsc" #-}
	| RDM 

{-# LINE 1752 "Network/Socket.hsc" #-}

{-# LINE 1753 "Network/Socket.hsc" #-}
	| SeqPacket

{-# LINE 1755 "Network/Socket.hsc" #-}
	deriving (Eq, Ord, Read, Show)
	
socketTypeTc = mkTyCon "SocketType"; instance Typeable SocketType where { typeOf _ = mkTyConApp socketTypeTc [] }

packSocketType stype = case stype of
	NoSocketType -> 0

{-# LINE 1762 "Network/Socket.hsc" #-}
	Stream -> 1
{-# LINE 1763 "Network/Socket.hsc" #-}

{-# LINE 1764 "Network/Socket.hsc" #-}

{-# LINE 1765 "Network/Socket.hsc" #-}
	Datagram -> 2
{-# LINE 1766 "Network/Socket.hsc" #-}

{-# LINE 1767 "Network/Socket.hsc" #-}

{-# LINE 1768 "Network/Socket.hsc" #-}
	Raw -> 3
{-# LINE 1769 "Network/Socket.hsc" #-}

{-# LINE 1770 "Network/Socket.hsc" #-}

{-# LINE 1771 "Network/Socket.hsc" #-}
	RDM -> 4
{-# LINE 1772 "Network/Socket.hsc" #-}

{-# LINE 1773 "Network/Socket.hsc" #-}

{-# LINE 1774 "Network/Socket.hsc" #-}
	SeqPacket -> 5
{-# LINE 1775 "Network/Socket.hsc" #-}

{-# LINE 1776 "Network/Socket.hsc" #-}

-- ---------------------------------------------------------------------------
-- Utility Functions

aNY_PORT :: PortNumber 
aNY_PORT = 0

iNADDR_ANY :: HostAddress
iNADDR_ANY = htonl (0)
{-# LINE 1785 "Network/Socket.hsc" #-}

sOMAXCONN :: Int
sOMAXCONN = 128
{-# LINE 1788 "Network/Socket.hsc" #-}

sOL_SOCKET :: Int
sOL_SOCKET = 1
{-# LINE 1791 "Network/Socket.hsc" #-}


{-# LINE 1793 "Network/Socket.hsc" #-}
sCM_RIGHTS :: Int
sCM_RIGHTS = 1
{-# LINE 1795 "Network/Socket.hsc" #-}

{-# LINE 1796 "Network/Socket.hsc" #-}

maxListenQueue :: Int
maxListenQueue = sOMAXCONN

-- -----------------------------------------------------------------------------

data ShutdownCmd 
 = ShutdownReceive
 | ShutdownSend
 | ShutdownBoth

shutdownCmdTc = mkTyCon "ShutdownCmd"; instance Typeable ShutdownCmd where { typeOf _ = mkTyConApp shutdownCmdTc [] }

sdownCmdToInt :: ShutdownCmd -> CInt
sdownCmdToInt ShutdownReceive = 0
sdownCmdToInt ShutdownSend    = 1
sdownCmdToInt ShutdownBoth    = 2

shutdown :: Socket -> ShutdownCmd -> IO ()
shutdown (MkSocket s _ _ _ _) stype = do
  throwSocketErrorIfMinus1Retry "shutdown" (c_shutdown s (sdownCmdToInt stype))
  return ()

-- -----------------------------------------------------------------------------

-- | Closes a socket
sClose	 :: Socket -> IO ()
sClose (MkSocket s _ _ _ socketStatus) = do 
 withMVar socketStatus $ \ status ->
   if status == ConvertedToHandle
	then ioError (userError ("sClose: converted to a Handle, use hClose instead"))
	else c_close s; return ()

-- -----------------------------------------------------------------------------

sIsConnected :: Socket -> IO Bool
sIsConnected (MkSocket _ _ _ _ status) = do
    value <- readMVar status
    return (value == Connected)	

-- -----------------------------------------------------------------------------
-- Socket Predicates

sIsBound :: Socket -> IO Bool
sIsBound (MkSocket _ _ _ _ status) = do
    value <- readMVar status
    return (value == Bound)	

sIsListening :: Socket -> IO Bool
sIsListening (MkSocket _ _ _  _ status) = do
    value <- readMVar status
    return (value == Listening)	

sIsReadable  :: Socket -> IO Bool
sIsReadable (MkSocket _ _ _ _ status) = do
    value <- readMVar status
    return (value == Listening || value == Connected)

sIsWritable  :: Socket -> IO Bool
sIsWritable = sIsReadable -- sort of.

sIsAcceptable :: Socket -> IO Bool

{-# LINE 1859 "Network/Socket.hsc" #-}
sIsAcceptable (MkSocket _ AF_UNIX Stream _ status) = do
    value <- readMVar status
    return (value == Connected || value == Bound || value == Listening)
sIsAcceptable (MkSocket _ AF_UNIX _ _ _) = return False

{-# LINE 1864 "Network/Socket.hsc" #-}
sIsAcceptable (MkSocket _ _ _ _ status) = do
    value <- readMVar status
    return (value == Connected || value == Listening)
    
-- -----------------------------------------------------------------------------
-- Internet address manipulation routines:

inet_addr :: String -> IO HostAddress
inet_addr ipstr = do
   withCString ipstr $ \str -> do
   had <- c_inet_addr str
   if had == -1
    then ioError (userError ("inet_addr: Malformed address: " ++ ipstr))
    else return had  -- network byte order

inet_ntoa :: HostAddress -> IO String
inet_ntoa haddr = do
  pstr <- c_inet_ntoa haddr
  peekCString pstr

-- | turns a Socket into an 'Handle'. By default, the new handle is
-- unbuffered. Use 'System.IO.hSetBuffering' to change the buffering.
--
-- Note that since a 'Handle' is automatically closed by a finalizer
-- when it is no longer referenced, you should avoid doing any more
-- operations on the 'Socket' after calling 'socketToHandle'.  To
-- close the 'Socket' after 'socketToHandle', call 'System.IO.hClose'
-- on the 'Handle'.


{-# LINE 1894 "Network/Socket.hsc" #-}
socketToHandle :: Socket -> IOMode -> IO Handle
socketToHandle s@(MkSocket fd _ _ _ socketStatus) mode = do
 modifyMVar socketStatus $ \ status ->
    if status == ConvertedToHandle
	then ioError (userError ("socketToHandle: already a Handle"))
	else do

{-# LINE 1903 "Network/Socket.hsc" #-}

{-# LINE 1904 "Network/Socket.hsc" #-}
    h <- openFd (fromIntegral fd) True{-is a socket-} mode True{-bin-}

{-# LINE 1906 "Network/Socket.hsc" #-}
    return (ConvertedToHandle, h)

{-# LINE 1911 "Network/Socket.hsc" #-}

mkInvalidRecvArgError :: String -> IOError
mkInvalidRecvArgError loc = IOError Nothing 

{-# LINE 1917 "Network/Socket.hsc" #-}
				    IllegalOperation

{-# LINE 1919 "Network/Socket.hsc" #-}
				    loc "non-positive length" Nothing

mkEOFError :: String -> IOError
mkEOFError loc = IOError Nothing EOF loc "end of file" Nothing

-- ---------------------------------------------------------------------------
-- WinSock support

{-| On Windows operating systems, the networking subsystem has to be
initialised using 'withSocketsDo' before any networking operations can
be used.  eg.

> main = withSocketsDo $ do {...}

Although this is only strictly necessary on Windows platforms, it is
harmless on other platforms, so for portability it is good practice to
use it all the time.
-}
withSocketsDo :: IO a -> IO a

{-# LINE 1939 "Network/Socket.hsc" #-}
withSocketsDo x = x

{-# LINE 1952 "Network/Socket.hsc" #-}

-- ---------------------------------------------------------------------------
-- foreign imports from the C library

foreign import ccall unsafe "my_inet_ntoa"
  c_inet_ntoa :: HostAddress -> IO (Ptr CChar)

foreign import ccall unsafe "inet_addr"
  c_inet_addr :: Ptr CChar -> IO HostAddress

foreign import ccall unsafe "shutdown"
  c_shutdown :: CInt -> CInt -> IO CInt 


{-# LINE 1966 "Network/Socket.hsc" #-}
foreign import ccall unsafe "close"
  c_close :: CInt -> IO CInt

{-# LINE 1972 "Network/Socket.hsc" #-}

foreign import ccall unsafe "socket"
  c_socket :: CInt -> CInt -> CInt -> IO CInt
foreign import ccall unsafe "bind"
  c_bind :: CInt -> Ptr SockAddr -> CInt{-CSockLen???-} -> IO CInt
foreign import ccall unsafe "connect"
  c_connect :: CInt -> Ptr SockAddr -> CInt{-CSockLen???-} -> IO CInt
foreign import ccall unsafe "accept"
  c_accept :: CInt -> Ptr SockAddr -> Ptr CInt{-CSockLen???-} -> IO CInt
foreign import ccall safe "accept"
  c_accept_safe :: CInt -> Ptr SockAddr -> Ptr CInt{-CSockLen???-} -> IO CInt
foreign import ccall unsafe "listen"
  c_listen :: CInt -> CInt -> IO CInt


{-# LINE 1989 "Network/Socket.hsc" #-}

foreign import ccall unsafe "send"
  c_send :: CInt -> Ptr a -> CSize -> CInt -> IO CInt
foreign import ccall unsafe "sendto"
  c_sendto :: CInt -> Ptr a -> CSize -> CInt -> Ptr SockAddr -> CInt -> IO CInt
foreign import ccall unsafe "recv"
  c_recv :: CInt -> Ptr CChar -> CSize -> CInt -> IO CInt
foreign import ccall unsafe "recvfrom"
  c_recvfrom :: CInt -> Ptr a -> CSize -> CInt -> Ptr SockAddr -> Ptr CInt -> IO CInt
foreign import ccall unsafe "getpeername"
  c_getpeername :: CInt -> Ptr SockAddr -> Ptr CInt -> IO CInt
foreign import ccall unsafe "getsockname"
  c_getsockname :: CInt -> Ptr SockAddr -> Ptr CInt -> IO CInt

foreign import ccall unsafe "getsockopt"
  c_getsockopt :: CInt -> CInt -> CInt -> Ptr CInt -> Ptr CInt -> IO CInt
foreign import ccall unsafe "setsockopt"
  c_setsockopt :: CInt -> CInt -> CInt -> Ptr CInt -> CInt -> IO CInt

-----------------------------------------------------------------------------
-- Support for thread-safe blocking operations in GHC.


{-# LINE 2040 "Network/Socket.hsc" #-}

throwErrnoIfMinus1Retry_mayBlock name _ act
  = throwSocketErrorIfMinus1Retry name act

throwErrnoIfMinus1Retry_repeatOnBlock name _ act
  = throwSocketErrorIfMinus1Retry name act

throwSocketErrorIfMinus1_ :: Num a => String -> IO a -> IO ()
throwSocketErrorIfMinus1_ name act = do
  throwSocketErrorIfMinus1Retry name act
  return ()


{-# LINE 2084 "Network/Socket.hsc" #-}
throwSocketErrorIfMinus1Retry name act = throwErrnoIfMinus1Retry name act

{-# LINE 2086 "Network/Socket.hsc" #-}

{-# LINE 2087 "Network/Socket.hsc" #-}

