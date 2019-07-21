{-# OPTIONS_GHC -optc-D__HUGS__ #-}
{-# INCLUDE "HsXlib.h" #-}
{-# LINE 1 "Graphics/X11/Xlib/Event.hsc" #-}
{-# OPTIONS_GHC -fglasgow-exts #-}
{-# LINE 2 "Graphics/X11/Xlib/Event.hsc" #-}
-----------------------------------------------------------------------------
-- |
-- Module      :  Graphics.X11.Xlib.Event
-- Copyright   :  (c) Alastair Reid, 1999-2003
-- License     :  BSD-style (see the file libraries/base/LICENSE)
--
-- Maintainer  :  libraries@haskell.org
-- Stability   :  provisional
-- Portability :  portable
--
-- A collection of FFI declarations for interfacing with Xlib Events.
--
-----------------------------------------------------------------------------

module Graphics.X11.Xlib.Event(
        QueuedMode,
        queuedAlready,
        queuedAfterFlush,
        queuedAfterReading,
        XEvent,
        XEventPtr,
        allocaXEvent,
        get_EventType,
        get_Window,
        XKeyEvent,
        XKeyEventPtr,
        asKeyEvent,
        XButtonEvent,
        get_KeyEvent,
        get_ButtonEvent,
        get_MotionEvent,
        XMotionEvent,
        XExposeEvent,
        get_ExposeEvent,
        XMappingEvent,
        XConfigureEvent,
        get_ConfigureEvent,
        waitForEvent,
        gettimeofday_in_milliseconds,
        -- gettimeofday_in_milliseconds_internal,
        flush,
        sync,
        pending,
        eventsQueued,
        nextEvent,
        allowEvents,
        selectInput,
        sendEvent,
        windowEvent,
        checkWindowEvent,
        maskEvent,
        checkMaskEvent,
        checkTypedEvent,
        checkTypedWindowEvent,
        putBackEvent,
        peekEvent,
        refreshKeyboardMapping,

        ) where

import Graphics.X11.Types
import Graphics.X11.Xlib.Types
import Graphics.X11.Xlib.Display( connectionNumber )

import Foreign


{-# LINE 71 "Graphics/X11/Xlib/Event.hsc" #-}


{-# LINE 73 "Graphics/X11/Xlib/Event.hsc" #-}

{-# CFILES cbits/fdset.c #-}

----------------------------------------------------------------
-- Events
----------------------------------------------------------------

type   QueuedMode   = Int
queuedAlready	 :: QueuedMode
queuedAlready	 =  0
queuedAfterFlush	 :: QueuedMode
queuedAfterFlush	 =  2
queuedAfterReading	 :: QueuedMode
queuedAfterReading	 =  1

{-# LINE 86 "Graphics/X11/Xlib/Event.hsc" #-}

-- Because of the way the corresponding C types are defined,
-- These "structs" are somewhat unusual - they omit fields which can
-- be found in more general structs.
-- For example, XAnyEvent omits type since it is in XEvent.
-- Therefore, to get the complete contents of an event one typically
-- writes:
--   do
--     ty <- get_XEvent e
--     (serial,send_event,display,window) <- get_XAnyEvent
--     window' <- get_XDestroyWindowEvent

newtype XEvent = XEvent XEventPtr

{-# LINE 102 "Graphics/X11/Xlib/Event.hsc" #-}
	deriving (Eq, Ord, Show)

{-# LINE 104 "Graphics/X11/Xlib/Event.hsc" #-}
type XEventPtr = Ptr XEvent

allocaXEvent :: (XEventPtr -> IO a) -> IO a
allocaXEvent = allocaBytes (192)
{-# LINE 108 "Graphics/X11/Xlib/Event.hsc" #-}

get_EventType :: XEventPtr -> IO EventType
get_EventType = (\hsc_ptr -> peekByteOff hsc_ptr 0)
{-# LINE 111 "Graphics/X11/Xlib/Event.hsc" #-}

get_Window :: XEventPtr -> IO Window
get_Window = (\hsc_ptr -> peekByteOff hsc_ptr 32)
{-# LINE 114 "Graphics/X11/Xlib/Event.hsc" #-}

-- %struct : XAnyEvent : XAnyEvent arg1
--   Int32     : serial            # # of last request processed by server
--   Bool      : send_event        # true if this came from a SendEvent request
--   Display   : display           # Display the event was read from
--   Window    : window            # window on which event was requested in event mask

type XKeyEvent =
	( Window    -- root window that the event occured on
	, Window    -- child window
	, Time      -- milliseconds
	, Int       -- pointer x, y coordinates in event window
	, Int       --
	, Int       -- coordinates relative to root
	, Int       --
	, Modifier  -- key or button mask
	, KeyCode   -- detail
	, Bool      -- same screen flag
	)

peekXKeyEvent :: Ptr XKeyEvent -> IO XKeyEvent
peekXKeyEvent p = do
	root		<- (\hsc_ptr -> peekByteOff hsc_ptr 40) p
{-# LINE 137 "Graphics/X11/Xlib/Event.hsc" #-}
	subwindow	<- (\hsc_ptr -> peekByteOff hsc_ptr 48) p
{-# LINE 138 "Graphics/X11/Xlib/Event.hsc" #-}
	time		<- (\hsc_ptr -> peekByteOff hsc_ptr 56) p
{-# LINE 139 "Graphics/X11/Xlib/Event.hsc" #-}
	x		<- (\hsc_ptr -> peekByteOff hsc_ptr 64) p
{-# LINE 140 "Graphics/X11/Xlib/Event.hsc" #-}
	y		<- (\hsc_ptr -> peekByteOff hsc_ptr 68) p
{-# LINE 141 "Graphics/X11/Xlib/Event.hsc" #-}
	x_root		<- (\hsc_ptr -> peekByteOff hsc_ptr 72) p
{-# LINE 142 "Graphics/X11/Xlib/Event.hsc" #-}
	y_root		<- (\hsc_ptr -> peekByteOff hsc_ptr 76) p
{-# LINE 143 "Graphics/X11/Xlib/Event.hsc" #-}
	state		<- (\hsc_ptr -> peekByteOff hsc_ptr 80) p
{-# LINE 144 "Graphics/X11/Xlib/Event.hsc" #-}
	keycode		<- (\hsc_ptr -> peekByteOff hsc_ptr 84) p
{-# LINE 145 "Graphics/X11/Xlib/Event.hsc" #-}
	same_screen	<- (\hsc_ptr -> peekByteOff hsc_ptr 88) p
{-# LINE 146 "Graphics/X11/Xlib/Event.hsc" #-}
	return (root, subwindow, time, x, y, x_root, y_root,
		state, keycode, same_screen)

get_KeyEvent :: XEventPtr -> IO XKeyEvent
get_KeyEvent p = peekXKeyEvent (castPtr p)

type XKeyEventPtr   = Ptr XKeyEvent

asKeyEvent :: XEventPtr -> XKeyEventPtr
asKeyEvent = castPtr

type XButtonEvent =
	( Window    --	root window that the event occured on
	, Window    --	child window
	, Time      --	milliseconds
	, Int       --	pointer x, y coordinates in event window
	, Int
	, Int       --	coordinates relative to root
	, Int
	, Modifier  --	key or button mask
	, Button    --	detail
	, Bool      --	same screen flag
	)

peekXButtonEvent :: Ptr XButtonEvent -> IO XButtonEvent
peekXButtonEvent p = do
	root		<- (\hsc_ptr -> peekByteOff hsc_ptr 40) p
{-# LINE 173 "Graphics/X11/Xlib/Event.hsc" #-}
	subwindow	<- (\hsc_ptr -> peekByteOff hsc_ptr 48) p
{-# LINE 174 "Graphics/X11/Xlib/Event.hsc" #-}
	time		<- (\hsc_ptr -> peekByteOff hsc_ptr 56) p
{-# LINE 175 "Graphics/X11/Xlib/Event.hsc" #-}
	x		<- (\hsc_ptr -> peekByteOff hsc_ptr 64) p
{-# LINE 176 "Graphics/X11/Xlib/Event.hsc" #-}
	y		<- (\hsc_ptr -> peekByteOff hsc_ptr 68) p
{-# LINE 177 "Graphics/X11/Xlib/Event.hsc" #-}
	x_root		<- (\hsc_ptr -> peekByteOff hsc_ptr 72) p
{-# LINE 178 "Graphics/X11/Xlib/Event.hsc" #-}
	y_root		<- (\hsc_ptr -> peekByteOff hsc_ptr 76) p
{-# LINE 179 "Graphics/X11/Xlib/Event.hsc" #-}
	state		<- (\hsc_ptr -> peekByteOff hsc_ptr 80) p
{-# LINE 180 "Graphics/X11/Xlib/Event.hsc" #-}
	button		<- (\hsc_ptr -> peekByteOff hsc_ptr 84) p
{-# LINE 181 "Graphics/X11/Xlib/Event.hsc" #-}
	same_screen	<- (\hsc_ptr -> peekByteOff hsc_ptr 88) p
{-# LINE 182 "Graphics/X11/Xlib/Event.hsc" #-}
	return (root, subwindow, time, x, y, x_root, y_root,
		state, button, same_screen)

get_ButtonEvent :: XEventPtr -> IO XButtonEvent
get_ButtonEvent p = peekXButtonEvent (castPtr p)

type XMotionEvent =
	( Window      -- root window that the event occured on
	, Window      -- child window
	, Time        -- milliseconds
	, Int         -- pointer x, y coordinates in event window
	, Int
	, Int         -- coordinates relative to root
	, Int
	, Modifier    -- key or button mask
	, NotifyMode  -- detail
	, Bool        -- same screen flag
	)

peekXMotionEvent :: Ptr XMotionEvent -> IO XMotionEvent
peekXMotionEvent p = do
	root		<- (\hsc_ptr -> peekByteOff hsc_ptr 40) p
{-# LINE 204 "Graphics/X11/Xlib/Event.hsc" #-}
	subwindow	<- (\hsc_ptr -> peekByteOff hsc_ptr 48) p
{-# LINE 205 "Graphics/X11/Xlib/Event.hsc" #-}
	time		<- (\hsc_ptr -> peekByteOff hsc_ptr 56) p
{-# LINE 206 "Graphics/X11/Xlib/Event.hsc" #-}
	x		<- (\hsc_ptr -> peekByteOff hsc_ptr 64) p
{-# LINE 207 "Graphics/X11/Xlib/Event.hsc" #-}
	y		<- (\hsc_ptr -> peekByteOff hsc_ptr 68) p
{-# LINE 208 "Graphics/X11/Xlib/Event.hsc" #-}
	x_root		<- (\hsc_ptr -> peekByteOff hsc_ptr 72) p
{-# LINE 209 "Graphics/X11/Xlib/Event.hsc" #-}
	y_root		<- (\hsc_ptr -> peekByteOff hsc_ptr 76) p
{-# LINE 210 "Graphics/X11/Xlib/Event.hsc" #-}
	state		<- (\hsc_ptr -> peekByteOff hsc_ptr 80) p
{-# LINE 211 "Graphics/X11/Xlib/Event.hsc" #-}
	is_hint		<- (\hsc_ptr -> peekByteOff hsc_ptr 84) p
{-# LINE 212 "Graphics/X11/Xlib/Event.hsc" #-}
	same_screen	<- (\hsc_ptr -> peekByteOff hsc_ptr 88) p
{-# LINE 213 "Graphics/X11/Xlib/Event.hsc" #-}
	return (root, subwindow, time, x, y, x_root, y_root,
		state, is_hint, same_screen)

get_MotionEvent :: XEventPtr -> IO XMotionEvent
get_MotionEvent p = peekXMotionEvent (castPtr p)

-- %struct : XCrossingEvent : XCrossingEvent arg1
--   Window       : root 	        # root window that the event occured on
--   Window       : subwindow 	# child window
--   Time         : time 		# milliseconds
--   Int          : x 		# pointer x, y coordinates in event window
--   Int          : y
--   Int          : x_root	 	# coordinates relative to root
--   Int          : y_root
--   NotifyMode   : mode
--   NotifyDetail : detail
--   Bool         : same_screen	# same screen flag
--   Bool         : focus		# boolean focus
--   Modifier     : state	        # key or button mask
--
-- %struct : XFocusChangeEvent : XFocusChangeEvent arg1
--   NotifyMode   : mode
--   NotifyDetail : detail
--
-- -- omitted: should be translated into bitmaps
-- -- PURE void	getKeymapEvent(event)
-- -- IN XEvent*	event
-- -- OUT Window	window	 	= ((XKeymapEvent*)event)->window
-- -- OUT array[32] Char key_vector 	= ((XKeymapEvent*)event)->key_vector
-- -- RESULT:

type XExposeEvent =
	( Position	-- x
	, Position	-- y
	, Dimension	-- width
	, Dimension	-- height
	, Int		-- count
	)

peekXExposeEvent :: Ptr XExposeEvent -> IO XExposeEvent
peekXExposeEvent p = do
	x	<- (\hsc_ptr -> peekByteOff hsc_ptr 40) p
{-# LINE 255 "Graphics/X11/Xlib/Event.hsc" #-}
	y	<- (\hsc_ptr -> peekByteOff hsc_ptr 44) p
{-# LINE 256 "Graphics/X11/Xlib/Event.hsc" #-}
	width	<- (\hsc_ptr -> peekByteOff hsc_ptr 48) p
{-# LINE 257 "Graphics/X11/Xlib/Event.hsc" #-}
	height	<- (\hsc_ptr -> peekByteOff hsc_ptr 52) p
{-# LINE 258 "Graphics/X11/Xlib/Event.hsc" #-}
	count	<- (\hsc_ptr -> peekByteOff hsc_ptr 56) p
{-# LINE 259 "Graphics/X11/Xlib/Event.hsc" #-}
	return (x, y, width, height, count)

get_ExposeEvent :: XEventPtr -> IO XExposeEvent
get_ExposeEvent p = peekXExposeEvent (castPtr p)

-- %struct : XGraphicsExposeEvent : XGraphicsExposeEvent arg1
--   Position	: x
--   Position	: y
--   Dimension	: width	 	.
--   Dimension	: height
--   Int		: count
--   Int		: major_code
--   Int		: minor_code
--
-- %struct : XCirculateEvent : XCirculateEvent arg1
--   Window	: window
--   Place		: place
--
-- %struct : XConfigureEvent : XConfigureEvent arg1
--   Window	: window
--   Position	: x
--   Position	: y
--   Dimension	: width
--   Dimension	: height
--   Dimension	: border_width
--   Window	: above
--   Bool	        : override_redirect
--
-- %struct : XCreateWindowEvent : XCreateWindowEvent arg1
--   Window	: window
--   Position	: x
--   Position	: y
--   Dimension	: width
--   Dimension	: height
--   Dimension	: border_width
--   Bool	        : override_redirect
--
-- %struct : XDestroyWindowEvent : XDestroyWindowEvent arg1
--   Window	: window
--
-- %struct : XGravityEvent : XGravityEvent arg1
--   Window	: window
--   Position	: x
--   Position	: y
--
-- %struct : XMapEvent : XMapEvent arg1
--   Bool	        : override_redirect

type XMappingEvent =
	( MappingRequest  -- request
	, KeyCode	  -- first_keycode
	, Int		  -- count
	)

withXMappingEvent :: XMappingEvent -> (Ptr XMappingEvent -> IO a) -> IO a
withXMappingEvent event_map f =
	allocaBytes (56) $ \ event_map_ptr -> do
{-# LINE 316 "Graphics/X11/Xlib/Event.hsc" #-}
	pokeXMappingEvent event_map_ptr event_map
	f event_map_ptr

pokeXMappingEvent :: Ptr XMappingEvent -> XMappingEvent -> IO ()
pokeXMappingEvent p (request, first_keycode, count) = do
	(\hsc_ptr -> pokeByteOff hsc_ptr 40)		p request
{-# LINE 322 "Graphics/X11/Xlib/Event.hsc" #-}
	(\hsc_ptr -> pokeByteOff hsc_ptr 44)	p first_keycode
{-# LINE 323 "Graphics/X11/Xlib/Event.hsc" #-}
	(\hsc_ptr -> pokeByteOff hsc_ptr 48)		p count
{-# LINE 324 "Graphics/X11/Xlib/Event.hsc" #-}

type XConfigureEvent =
	( Position
	, Position
	, Dimension
	, Dimension
	)

peekXConfigureEvent :: Ptr XConfigureEvent -> IO XConfigureEvent
peekXConfigureEvent p = do
	x	<- (\hsc_ptr -> peekByteOff hsc_ptr 48) p
{-# LINE 335 "Graphics/X11/Xlib/Event.hsc" #-}
	y	<- (\hsc_ptr -> peekByteOff hsc_ptr 52) p
{-# LINE 336 "Graphics/X11/Xlib/Event.hsc" #-}
	width	<- (\hsc_ptr -> peekByteOff hsc_ptr 56) p
{-# LINE 337 "Graphics/X11/Xlib/Event.hsc" #-}
	height	<- (\hsc_ptr -> peekByteOff hsc_ptr 60) p
{-# LINE 338 "Graphics/X11/Xlib/Event.hsc" #-}
	return (x, y, width, height)

get_ConfigureEvent :: XEventPtr -> IO XConfigureEvent
get_ConfigureEvent p = peekXConfigureEvent (castPtr p)

-- %struct : XResizeRequestEvent : XResizeRequestEvent arg1
--   Dimension	: width
--   Dimension	: height
--

-- %struct : XReparentEvent : XReparentEvent arg1
--   Window	: window
--   Window	: parent
--   Position	: x
--   Position	: y
--   Bool	        : override_redirect
--
-- %struct : XUnmapEvent : XUnmapEvent arg1
--   Window	: window
--   Bool	        : from_configure
--
-- %struct : XVisibilityEvent : XVisibilityEvent arg1
--   Visibility	: state
--
-- %struct : XCirculateRequestEvent : XCirculateRequestEvent arg1
--   Place	        : place
--
-- -- omitted because valuemask looks tricky
-- -- %struct : XConfigureRequestEvent : XConfigureRequestEvent arg1
-- --   Window	 : window
-- --   Position	 : x
-- --   Position	 : y
-- --   Dimension	 : width
-- --   Dimension	 : height
-- --   Dimension	 : border_width
-- --   Window	 : above
-- --   StackingMethod : detail
-- --   ???	         : valuemask
--
-- %struct : XMapRequestEvent : XMapRequestEvent arg1
--   Window	: window
--
-- %struct : XColormapEvent : XColormapEvent arg1
--   Colormap		: colormap
--   Bool		        : new
--   ColormapNotification	: state
--
-- -- getClientMessageEvent omitted
-- -- getPropertyEvent omitted
-- -- getSelectionClearEvent omitted
-- -- getSelectionRequestEvent omitted
-- -- getSelectionEvent omitted

-- functions

-- The following is useful if you want to do a read with timeout.

-- | Reads an event with a timeout (in microseconds).
-- Returns True if timeout occurs.
waitForEvent :: Display -> Word32 -> IO Bool
waitForEvent display usecs =
	with (TimeVal (usecs `div` 1000000) (usecs `mod` 1000000)) $ \ tv_ptr ->
	allocaBytes (128) $ \ readfds ->
{-# LINE 401 "Graphics/X11/Xlib/Event.hsc" #-}
	allocaBytes (128) $ \ nofds -> do
{-# LINE 402 "Graphics/X11/Xlib/Event.hsc" #-}
	let fd = connectionNumber display
	fdZero readfds
	fdZero nofds
	fdSet fd readfds
	n <- select (fd+1) readfds nofds nofds tv_ptr
	return (n == 0)

newtype FdSet = FdSet (Ptr FdSet)

{-# LINE 413 "Graphics/X11/Xlib/Event.hsc" #-}
	deriving (Eq, Ord, Show)

{-# LINE 415 "Graphics/X11/Xlib/Event.hsc" #-}

foreign import ccall unsafe "HsXlib.h" fdZero :: Ptr FdSet -> IO ()
foreign import ccall unsafe "HsXlib.h" fdSet :: Int -> Ptr FdSet -> IO ()

foreign import ccall unsafe "HsXlib.h" select ::
	Int -> Ptr FdSet -> Ptr FdSet -> Ptr FdSet -> Ptr TimeVal -> IO Int

-- | This function is somewhat compatible with Win32's @TimeGetTime()@
gettimeofday_in_milliseconds :: IO Integer
gettimeofday_in_milliseconds =
	alloca $ \ tv_ptr -> do
	rc <- gettimeofday tv_ptr nullPtr
	TimeVal sec usec <- peek tv_ptr
	return (toInteger sec * 1000 + toInteger usec `div` 1000)

data TimeVal = TimeVal Word32 Word32

instance Storable TimeVal where
	alignment _ = (4)
{-# LINE 434 "Graphics/X11/Xlib/Event.hsc" #-}
	sizeOf _ = (16)
{-# LINE 435 "Graphics/X11/Xlib/Event.hsc" #-}
	peek p = do
		sec <- (\hsc_ptr -> peekByteOff hsc_ptr 0) p
{-# LINE 437 "Graphics/X11/Xlib/Event.hsc" #-}
		usec <- (\hsc_ptr -> peekByteOff hsc_ptr 8) p
{-# LINE 438 "Graphics/X11/Xlib/Event.hsc" #-}
		return (TimeVal sec usec)
	poke p (TimeVal sec usec) = do
		(\hsc_ptr -> pokeByteOff hsc_ptr 0) p sec
{-# LINE 441 "Graphics/X11/Xlib/Event.hsc" #-}
		(\hsc_ptr -> pokeByteOff hsc_ptr 8) p usec
{-# LINE 442 "Graphics/X11/Xlib/Event.hsc" #-}

newtype TimeZone = TimeZone (Ptr TimeZone)

{-# LINE 447 "Graphics/X11/Xlib/Event.hsc" #-}
	deriving (Eq, Ord, Show)

{-# LINE 449 "Graphics/X11/Xlib/Event.hsc" #-}

foreign import ccall unsafe "HsXlib.h"
	gettimeofday :: Ptr TimeVal -> Ptr TimeZone -> IO ()

-- | interface to the X11 library function @XFlush()@.
foreign import ccall unsafe "HsXlib.h XFlush"
	flush        :: Display ->               IO ()

-- | interface to the X11 library function @XSync()@.
foreign import ccall unsafe "HsXlib.h XSync"
	sync         :: Display -> Bool ->       IO ()

-- | interface to the X11 library function @XPending()@.
foreign import ccall unsafe "HsXlib.h XPending"
	pending      :: Display ->               IO Int

-- | interface to the X11 library function @XEventsQueued()@.
foreign import ccall unsafe "HsXlib.h XEventsQueued"
	eventsQueued :: Display -> QueuedMode -> IO Int

-- | interface to the X11 library function @XNextEvent()@.
foreign import ccall unsafe "HsXlib.h XNextEvent"
	nextEvent    :: Display -> XEventPtr  -> IO ()

-- | interface to the X11 library function @XAllowEvents()@.
foreign import ccall unsafe "HsXlib.h XAllowEvents"
	allowEvents  :: Display -> AllowEvents -> Time -> IO ()

-- ToDo: XFree(res1) after constructing result
-- %fun XGetMotionEvents :: Display -> Window -> Time -> Time -> IO ListXTimeCoord
-- %code res1 = XGetMotionEvents(arg1,arg2,arg3,arg4,&res1_size)

-- | interface to the X11 library function @XSelectInput()@.
foreign import ccall unsafe "HsXlib.h XSelectInput"
	selectInput :: Display -> Window -> EventMask -> IO ()

-- | interface to the X11 library function @XSendEvent()@.
sendEvent :: Display -> Window -> Bool -> EventMask -> XEventPtr -> IO ()
sendEvent display w propagate event_mask event_send =
	throwIfZero "sendEvent" $
		xSendEvent display w propagate event_mask event_send
foreign import ccall unsafe "HsXlib.h XSendEvent"
	xSendEvent :: Display -> Window -> Bool -> EventMask ->
		XEventPtr -> IO Status

-- | interface to the X11 library function @XWindowEvent()@.
foreign import ccall unsafe "HsXlib.h XWindowEvent"
	windowEvent :: Display -> Window -> EventMask -> XEventPtr -> IO ()

-- | interface to the X11 library function @XCheckWindowEvent()@.
foreign import ccall unsafe "HsXlib.h XCheckWindowEvent"
	checkWindowEvent :: Display -> Window -> EventMask ->
		XEventPtr -> IO Bool

-- | interface to the X11 library function @XMaskEvent()@.
foreign import ccall unsafe "HsXlib.h XMaskEvent"
	maskEvent :: Display -> EventMask -> XEventPtr -> IO ()

-- | interface to the X11 library function @XCheckMaskEvent()@.
foreign import ccall unsafe "HsXlib.h XCheckMaskEvent"
	checkMaskEvent :: Display -> EventMask -> XEventPtr -> IO Bool

-- | interface to the X11 library function @XCheckTypedEvent()@.
foreign import ccall unsafe "HsXlib.h XCheckTypedEvent"
	checkTypedEvent :: Display -> EventType -> XEventPtr -> IO Bool

-- | interface to the X11 library function @XCheckTypedWindowEvent()@.
foreign import ccall unsafe "HsXlib.h XCheckTypedWindowEvent"
	checkTypedWindowEvent :: Display -> Window -> EventType ->
		XEventPtr -> IO Bool

-- | interface to the X11 library function @XPutBackEvent()@.
foreign import ccall unsafe "HsXlib.h XPutBackEvent"
	putBackEvent :: Display -> XEventPtr -> IO ()

-- | interface to the X11 library function @XPeekEvent()@.
foreign import ccall unsafe "HsXlib.h XPeekEvent"
	peekEvent :: Display -> XEventPtr -> IO ()

-- XFilterEvent omitted (can't find documentation)
-- XIfEvent omitted (can't pass predicates (yet))
-- XCheckIfEvent omitted (can't pass predicates (yet))
-- XPeekIfEvent omitted (can't pass predicates (yet))

-- | interface to the X11 library function @XRefreshKeyboardMapping()@.
refreshKeyboardMapping :: XMappingEvent -> IO ()
refreshKeyboardMapping event_map =
	withXMappingEvent event_map $ \ event_map_ptr ->
	xRefreshKeyboardMapping event_map_ptr
foreign import ccall unsafe "HsXlib.h XRefreshKeyboardMapping"
	xRefreshKeyboardMapping :: Ptr XMappingEvent -> IO ()

-- XSynchronize omitted (returns C function)
-- XSetAfterFunction omitted (can't pass functions (yet))

----------------------------------------------------------------
-- End
----------------------------------------------------------------
