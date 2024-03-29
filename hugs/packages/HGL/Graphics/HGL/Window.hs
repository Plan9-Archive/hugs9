-----------------------------------------------------------------------------
-- |
-- Module      :  Graphics.HGL.Window
-- Copyright   :  (c) Alastair Reid, 1999-2003
-- License     :  BSD-style (see the file libraries/base/LICENSE)
--
-- Maintainer  :  libraries@haskell.org
-- Stability   :  provisional
-- Portability :  non-portable (requires concurrency)
--
-- Windows in a simple graphics library.
--
-----------------------------------------------------------------------------

                                                                            
                                                                            

                                                           
                            

                                                         
                          

                                                         
                          

                                                         
                          

                                                          
                           

                                                         
                          

                                                           
                            

                                                            
                             

                                                         
                          

                                                                              


                                              


                                                          


                                                          


                                            


                                                        


                                                      
                         

                                                                      
                              



module Graphics.HGL.Window
	(
	-- * Windows
	  Window
	, Title			-- = String
	, RedrawMode(Unbuffered, DoubleBuffered)
	, openWindowEx		-- :: Title -> Maybe Point -> Maybe Size ->
				--    RedrawMode -> Maybe Time -> IO Window
	, getWindowRect		-- :: Window -> IO (Point,Point)
	, closeWindow		-- :: Window -> IO ()

	-- * Drawing in a window
	, setGraphic		-- :: Window -> Graphic -> IO ()
	, getGraphic		-- :: Window -> IO Graphic
	, modGraphic		-- :: Window -> (Graphic -> Graphic) -> IO ()
	, directDraw		-- :: Window -> Graphic -> IO ()
	-- not in X11: , redrawWindow		-- :: Window -> IO ()

	-- * Events in a window
	, Event(..)
	-- , Event(Char,Key,Button,MouseMove,Resize,Closed) -- deriving(Show)
	-- , char		-- :: Event -> Char
	-- , keysym		-- :: Event -> Key
	-- , isDown		-- :: Event -> Bool
	-- , pt			-- :: Event -> Point
	-- , isLeft		-- :: Event -> Bool
	, getWindowEvent	-- :: Window -> IO Event
	, maybeGetWindowEvent	-- :: Window -> IO (Maybe Event)

	-- * Timer ticks
	-- | Timers that tick at regular intervals are set up by 'openWindowEx'.
	, getWindowTick		-- :: Window -> IO ()
	, getTime		-- :: IO Time
	) where




import Graphics.HGL.Units
import Graphics.HGL.Draw( Graphic )
import Graphics.HGL.Internals.Event( Event(..) )
import Graphics.HGL.Internals.Types( Title, RedrawMode(..), getTime )
import qualified Graphics.HGL.Internals.Events as E
import Graphics.HGL.Internals.Utilities( modMVar, modMVar_ )

import Graphics.HGL.X11.Window (Window(..))
import qualified Graphics.HGL.X11.Window as X (openWindowEx, closeWindow,
	redrawWindow, directDraw, getWindowRect )













import Control.Concurrent.MVar

----------------------------------------------------------------
-- Interface
----------------------------------------------------------------

-- | Wait for the next event on the given window.
getWindowEvent      :: Window -> IO Event

-- | Check for a pending event on the given window.
maybeGetWindowEvent :: Window -> IO (Maybe Event)

-- | Wait for the next tick event from the timer on the given window.
getWindowTick       :: Window -> IO ()

-- | Get the current drawing in a window.
getGraphic :: Window -> IO Graphic

-- | Set the current drawing in a window.
setGraphic :: Window -> Graphic -> IO ()

-- | Update the drawing for a window.
-- Note that this does not force a redraw.
modGraphic :: Window -> (Graphic -> Graphic) -> IO ()

-- | General window creation.
openWindowEx
  :: Title		-- ^ title of the window
  -> Maybe Point	-- ^ the optional initial position of a window
  -> Size		-- ^ initial size of the window
  -> RedrawMode		-- ^ how to display a graphic on the window
  -> Maybe Time		-- ^ the time between ticks (in milliseconds) of an
			-- optional timer associated with the window
  -> IO Window

-- | Close the window.
closeWindow   :: Window -> IO ()

redrawWindow  :: Window -> IO ()

directDraw    :: Window -> Graphic -> IO ()

-- | The position of the top left corner of the window on the screen,
-- and the size of the window.
getWindowRect :: Window -> IO (Point, Size)

----------------------------------------------------------------
-- Implementation
----------------------------------------------------------------

getWindowEvent w     = E.getEvent (events w)

maybeGetWindowEvent w
  = do noEvent <- E.isNoEvent (events w)
       if noEvent 
          then return Nothing
          else do ev <- getWindowEvent w
                  return (Just ev)

getWindowTick w      = E.getTick (events w)

getGraphic w = readMVar (graphic w)

setGraphic w p = do
  modMVar (graphic w) (const p)
  redrawWindow w

modGraphic w = modMVar_ (graphic w)



openWindowEx    = X.openWindowEx
closeWindow     = X.closeWindow
getWindowRect   = X.getWindowRect
redrawWindow    = X.redrawWindow
directDraw      = X.directDraw






































----------------------------------------------------------------
-- End
----------------------------------------------------------------
