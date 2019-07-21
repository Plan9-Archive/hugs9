-----------------------------------------------------------------------------
-- |
-- Module      :  Graphics.HGL.Draw.Brush
-- Copyright   :  (c) Alastair Reid, 1999-2003
-- License     :  BSD-style (see the file libraries/base/LICENSE)
-- 
-- Maintainer  :  libraries@haskell.org
-- Stability   :  provisional
-- Portability :  non-portable (requires concurrency)
--
-- Brushes, used for filling shapes.
--
-----------------------------------------------------------------------------

                                                                            
                                                                            

                                                           
                            

                                                         
                          

                                                         
                          

                                                         
                          

                                                          
                           

                                                         
                          

                                                           
                            

                                                            
                             

                                                         
                          

                                                                              


                                              


                                                          


                                                          


                                            


                                                        


                                                      
                         

                                                                      
                              



module Graphics.HGL.Draw.Brush
	( Brush
	, createBrush
	, deleteBrush
	, selectBrush	-- :: Brush -> Draw Brush
	, mkBrush
	-- , blackBrush, whiteBrush
	) where

import Graphics.HGL.Draw.Text (RGB(..))
import Graphics.HGL.Draw.Monad (Draw)
import Graphics.HGL.Internals.Draw (mkDraw)

import Graphics.HGL.X11.Types
import qualified Graphics.X11.Xlib as X
import Control.Concurrent (takeMVar, putMVar)





----------------------------------------------------------------
-- The interface
----------------------------------------------------------------





-- | Create a 'Brush'.
createBrush :: RGB   -> IO Brush

-- | Destroy a 'Brush' created with 'createBrush'.
deleteBrush :: Brush -> IO ()

-- | Set the 'Brush' for subsequent drawing, returning the previous setting.
selectBrush :: Brush -> Draw Brush

-- | Create a 'Brush' locally to a drawing.
mkBrush     :: RGB   -> (Brush -> Draw a) -> Draw a

----------------------------------------------------------------
-- The implementation
----------------------------------------------------------------



createBrush col = return (Brush col)

deleteBrush _ = return ()

-- ToDo: how do I set background colour for brush and pen?
selectBrush b@(Brush x) = mkDraw $ \ dc -> do
  bs <- takeMVar (ref_bits dc)
  putMVar (ref_bits dc) bs{brush=b}
  p <- lookupColor (disp dc) x
  X.setForeground (disp dc) (brushGC dc) p
  return (brush bs)

mkBrush c g = g (Brush c)





























