-- #hide
--------------------------------------------------------------------------------
-- |
-- Module      :  Graphics.UI.GLUT.QueryUtils
-- Copyright   :  (c) Sven Panne 2002-2005
-- License     :  BSD-style (see the file libraries/GLUT/LICENSE)
-- 
-- Maintainer  :  sven.panne@aedion.de
-- Stability   :  stable
-- Portability :  portable
--
-- This is a purely internal module with utilities to query GLUT state.
--
--------------------------------------------------------------------------------

module Graphics.UI.GLUT.QueryUtils (
  Getter, simpleGet, layerGet, deviceGet, glutSetOption
) where

import Foreign.C.Types ( CInt )
import Graphics.Rendering.OpenGL.GL.BasicTypes ( GLenum )
import Graphics.UI.GLUT.Extensions

--------------------------------------------------------------------------------

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  




                                                                                                                                                                          












--------------------------------------------------------------------------------

type PrimGetter =                GLenum -> IO CInt
type Getter a   = (CInt -> a) -> GLenum -> IO a

makeGetter :: PrimGetter -> Getter a
makeGetter g f = fmap f . g

simpleGet, layerGet, deviceGet :: Getter a
simpleGet = makeGetter glutGet
layerGet  = makeGetter glutLayerGet
deviceGet = makeGetter glutDeviceGet

foreign import ccall unsafe "glutGet"       glutGet       :: PrimGetter
foreign import ccall unsafe "glutLayerGet"  glutLayerGet  :: PrimGetter
foreign import ccall unsafe "glutDeviceGet" glutDeviceGet :: PrimGetter

-- Not really a query function, but it's quite handy to have it here
foreign import ccall unsafe "dynamic" dyn_glutSetOption :: Graphics.UI.GLUT.Extensions.Invoker (GLenum -> CInt -> IO ()) ; glutSetOption :: (GLenum -> CInt -> IO ()) ; glutSetOption = dyn_glutSetOption ptr_glutSetOption ; ptr_glutSetOption :: FunPtr a ; ptr_glutSetOption = unsafePerformIO (Graphics.UI.GLUT.Extensions.getProcAddress ("freeglut") ("glutSetOption")) ; {-# NOINLINE ptr_glutSetOption #-}
