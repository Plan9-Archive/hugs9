-----------------------------------------------------------------------------
-- |
-- Module      :  Graphics.HGL.Draw.Text
-- Copyright   :  (c) Alastair Reid, 1999-2003
-- License     :  BSD-style (see the file libraries/base/LICENSE)
-- 
-- Maintainer  :  libraries@haskell.org
-- Stability   :  provisional
-- Portability :  non-portable (requires concurrency)
--
-- Drawing text.
--
-----------------------------------------------------------------------------

                                                                            
                                                                            

                                                           
                            

                                                         
                          

                                                         
                          

                                                         
                          

                                                          
                           

                                                         
                          

                                                           
                            

                                                            
                             

                                                         
                          

                                                                              


                                              


                                                          


                                                          


                                            


                                                        


                                                      
                         

                                                                      
                              



module Graphics.HGL.Draw.Text
        (
	-- * Drawing text
          text
	-- ToDo: add textInfo to Win32

        , textInfo

	-- * Color
	, RGB(RGB)
	, setTextColor		-- :: RGB -> Draw RGB
	, setBkColor		-- :: RGB -> Draw RGB
	, BkMode(Opaque, Transparent)
	, setBkMode		-- :: BkMode -> Draw BkMode
	-- * Alignment
	, Alignment		-- = (HAlign, VAlign)
	, HAlign(Left', Center, Right')
	, VAlign(Top, Baseline, Bottom)
	, setTextAlignment	-- :: Alignment -> Draw Alignment
	) where


import qualified Graphics.X11.Xlib as X
import Graphics.HGL.X11.Types
import Control.Concurrent.MVar (readMVar, takeMVar, putMVar)






import Graphics.HGL.Units (Point, Size)
import Graphics.HGL.Draw.Monad (Graphic, Draw)
import Graphics.HGL.Internals.Draw (mkDraw)
import Graphics.HGL.Internals.Types
	(RGB(..), BkMode(..), Alignment, HAlign(..), VAlign(..))

----------------------------------------------------------------
-- The Interface (SOE, p50)
----------------------------------------------------------------

-- | Render a 'String' positioned relative to the specified 'Point'.
text         :: Point -> String                  -> Graphic  -- filled


-- | @'textInfo' s@ returns:
--
-- (1) The offset at which the string would be drawn according to the
--     current text alignment (e.g., @('Center', 'Baseline')@ will result
--     in an offset of (-width\/2,0))
--
-- (2) The size at which the text would be drawn using the current font.
--
textInfo :: String -> Draw (Point,Size)


-- | Set the foreground color for drawing text, returning the previous value.
setTextColor     :: RGB           -> Draw RGB

-- | Set the background color for drawing text, returning the previous value.
-- The background color is ignored when the mode is 'Transparent'.
setBkColor       :: RGB           -> Draw RGB

-- | Set the background mode for drawing text, returning the previous value.
setBkMode        :: BkMode        -> Draw BkMode

-- | Set the alignment for drawing text, returning the previous value.
setTextAlignment :: Alignment     -> Draw Alignment

----------------------------------------------------------------
-- The Implementation
----------------------------------------------------------------



text p s = mkDraw (\ dc -> do
  bs <- readMVar (ref_bits dc)
  let
    Font f  = font bs
    (halign, valign) = textAlignment bs

    width   = X.textWidth f s
    ascent  = X.ascentFromFontStruct f
    descent = X.descentFromFontStruct f

    x' = case halign of
         Left'  -> x
         Center -> x - width `div` 2
         Right' -> x - width + 1
    y' = case valign of
         Top      -> y + ascent
         Baseline -> y
         Bottom   -> y - descent + 1

  draw (bkMode bs) (disp dc) (drawable dc) (textGC dc) x' y' s
 )
 where
  X.Point x y = fromPoint p

  -- Win32's DeviceContext has a BkMode in it.  In X, we call two different
  -- routines depending on what mode we want.
  draw Transparent = X.drawString
  draw Opaque      = X.drawImageString

textInfo s = mkDraw $ \ dc -> do
  bs <- readMVar (ref_bits dc)
  let
    Font f  = font bs
    (halign, valign) = textAlignment bs

    width   = X.textWidth f s
    ascent  = X.ascentFromFontStruct f
    descent = X.descentFromFontStruct f

    x1 = case halign of
          Left'  -> 0
          Center -> - width `div` 2
          Right' -> - width + 1
    y1 = case valign of
          Top      -> ascent
          Baseline -> 0
          Bottom   -> - descent + 1

    x2 = x1 + width
    y2 = y1 + ascent + descent

    (x1',x2') = (min x1 x2, max x1 x2)
    (y1',y2') = (min y1 y2, max y1 y2)

  return (toPoint (X.Point x1 y1), toSize (fromIntegral (x2'-x1'), fromIntegral (y2'-y1')))

setTextColor     x = mkDraw $ \ dc -> do
  bs <- takeMVar (ref_bits dc)
  putMVar (ref_bits dc) bs{textColor=x}
  p <- lookupColor (disp dc) x
  X.setForeground (disp dc) (textGC dc) p
  return (textColor bs)

setBkColor       x = mkDraw $ \ dc -> do
  bs <- takeMVar (ref_bits dc)
  putMVar (ref_bits dc) bs{bkColor=x}
  p <- lookupColor (disp dc) x
  X.setBackground (disp dc) (textGC dc) p
  return (bkColor bs)

setBkMode        x = mkDraw $ \ dc -> do
  bs <- takeMVar (ref_bits dc)
  putMVar (ref_bits dc) bs{bkMode=x}
  return (bkMode bs)

setTextAlignment x = mkDraw $ \ dc -> do
  bs <- takeMVar (ref_bits dc)
  putMVar (ref_bits dc) bs{textAlignment=x}
  return (textAlignment bs)










































































----------------------------------------------------------------
-- End
----------------------------------------------------------------
