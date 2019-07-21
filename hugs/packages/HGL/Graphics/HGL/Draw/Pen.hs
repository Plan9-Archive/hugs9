-----------------------------------------------------------------------------
-- |
-- Module      :  Graphics.HGL.Draw.Pen
-- Copyright   :  (c) Alastair Reid, 1999-2003
-- License     :  BSD-style (see the file libraries/base/LICENSE)
-- 
-- Maintainer  :  libraries@haskell.org
-- Stability   :  provisional
-- Portability :  non-portable (requires concurrency)
--
-- Pens, used for drawing lines.
--
-- Portability notes:
--
-- * On Win32, the pen is also used to draw a line round all the filled
--   shapes --- so the pen color also affects how polygons, ellipses
--   and regions are drawn.
--
-- * On Win32, the 'Style' is ignored (i.e. treated as 'Solid') for pens
--   of width greater than 1.  This problem does not apply to X11.
--
-----------------------------------------------------------------------------

                                                                            
                                                                            

                                                           
                            

                                                         
                          

                                                         
                          

                                                         
                          

                                                          
                           

                                                         
                          

                                                           
                            

                                                            
                             

                                                         
                          

                                                                              


                                              


                                                          


                                                          


                                            


                                                        


                                                      
                         

                                                                      
                              



module Graphics.HGL.Draw.Pen
	( Pen
	, Style(Solid, Dash, Dot, DashDot, DashDotDot, Null, InsideFrame)
	, createPen	-- :: Style -> Int -> RGB -> IO Pen
	, deletePen
	, selectPen	-- :: Pen -> Draw Pen
	, mkPen		-- :: Style -> Int -> RGB -> (Pen -> Draw a) -> Draw a
	) where

import Graphics.HGL.Draw.Text (RGB)
import Graphics.HGL.Draw.Monad (Draw, ioToDraw)
import Graphics.HGL.Internals.Types (Style(..))
import Graphics.HGL.Internals.Draw (mkDraw) 


import Graphics.HGL.X11.Types
import Graphics.HGL.X11.Display
import qualified Graphics.X11.Xlib as X
import Control.Concurrent (takeMVar, putMVar)






----------------------------------------------------------------




-- | Create a 'Pen'.
createPen :: Style -> Int -> RGB -> IO Pen

-- | Destroy a 'Pen' created with 'createPen'.
deletePen :: Pen -> IO ()

-- | Set the 'Pen' for subsequent drawing, returning the previous setting.
selectPen :: Pen -> Draw Pen

-- | Create a 'Pen' locally to a drawing.
mkPen     :: Style -> Int -> RGB -> (Pen -> Draw a) -> Draw a
----------------------------------------------------------------



----------------------------------------------------------------
-- Pens
--
-- Used to draw lines and boundaries of filled shapes
----------------------------------------------------------------

createPen style width col = do
  display <- getDisplay
  pixel <- lookupColor display col
  return (Pen style width pixel)

deletePen _ = return ()

-- ToDo: how do I set background colour for brush and pen?
selectPen p@(Pen _ lwidth c) = mkDraw $ \ dc -> do
  bs <- takeMVar (ref_bits dc)
  putMVar (ref_bits dc) bs{pen=p}
  X.setForeground (disp dc) (paintGC dc) c
  X.setLineAttributes (disp dc) (paintGC dc) lwidth X.lineSolid X.capButt X.joinMiter
  return (pen bs)

mkPen style width color g = do
  p <- ioToDraw $ createPen style width color
  g p




























----------------------------------------------------------------
-- The end
----------------------------------------------------------------
