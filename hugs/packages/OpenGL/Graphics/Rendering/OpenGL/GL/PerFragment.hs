--------------------------------------------------------------------------------
-- |
-- Module      :  Graphics.Rendering.OpenGL.GL.PerFragment
-- Copyright   :  (c) Sven Panne 2002-2005
-- License     :  BSD-style (see the file libraries/OpenGL/LICENSE)
-- 
-- Maintainer  :  sven.panne@aedion.de
-- Stability   :  provisional
-- Portability :  portable
--
-- This module corresponds to section 4.1 (Per-Fragment Operations) of the
-- OpenGL 1.5 specs.
--
--------------------------------------------------------------------------------

module Graphics.Rendering.OpenGL.GL.PerFragment (
   -- * Scissor Test
   scissor,

   -- * Multisample Fragment Operations
   sampleAlphaToCoverage,  sampleAlphaToOne, sampleCoverage,

   -- * Depth Bounds Test
   depthBounds,

   -- * Alpha Test
   ComparisonFunction(..), alphaFunc,

   -- * Stencil Test
   stencilTest, stencilFunc, StencilOp(..), stencilOp, activeStencilFace,

   -- * Depth Buffer Test
   depthFunc,

   -- * Occlusion Queries
   QueryObject(QueryObject), QueryTarget(..), withQuery,
   queryCounterBits, currentQuery,
   queryResult, queryResultAvailable,

   -- * Blending
   blend, BlendEquation(..), blendEquation,
   BlendingFactor(..), blendFuncSeparate, blendFunc, blendColor,

   -- * Dithering
   dither,

   -- * Logical Operation
   LogicOp(..), logicOp
) where

import Control.Monad ( liftM2, liftM3 )
import Foreign.Marshal.Alloc ( alloca )
import Foreign.Marshal.Array ( withArrayLen, peekArray, allocaArray )
import Foreign.Ptr ( Ptr )
import Graphics.Rendering.OpenGL.GL.BufferObjects ( ObjectName(..) )
import Graphics.Rendering.OpenGL.GL.Capability (
   EnableCap(CapScissorTest,CapSampleAlphaToCoverage,CapSampleAlphaToOne,
             CapSampleCoverage,CapDepthBoundsTest,CapAlphaTest,CapStencilTest,
             CapStencilTestTwoSide,CapDepthTest,CapBlend,CapDither,
             CapIndexLogicOp,CapColorLogicOp),
   makeCapability, makeStateVarMaybe )
import Graphics.Rendering.OpenGL.GL.BasicTypes (
   GLboolean, GLint, GLuint, GLsizei, GLenum, GLclampf, GLclampd, Capability )
import Graphics.Rendering.OpenGL.GL.BlendingFactor (
   BlendingFactor(..), marshalBlendingFactor, unmarshalBlendingFactor )
import Graphics.Rendering.OpenGL.GL.ComparisonFunction ( ComparisonFunction(..),
   marshalComparisonFunction, unmarshalComparisonFunction )
import Graphics.Rendering.OpenGL.GL.CoordTrans ( Position(..), Size(..) )
import Graphics.Rendering.OpenGL.GL.Exception ( bracket_ )
import Graphics.Rendering.OpenGL.GL.Extensions (
   FunPtr, unsafePerformIO, Invoker, getProcAddress )
import Graphics.Rendering.OpenGL.GL.Face ( marshalFace, unmarshalFace )
import Graphics.Rendering.OpenGL.GL.Colors ( Face )
import Graphics.Rendering.OpenGL.GL.GLboolean (
   marshalGLboolean, unmarshalGLboolean )
import Graphics.Rendering.OpenGL.GL.PeekPoke ( peek1 )
import Graphics.Rendering.OpenGL.GL.QueryUtils (
   GetPName(GetScissorBox,GetSampleCoverageValue,GetSampleCoverageInvert,
            GetDepthBounds,GetAlphaTestFunc,GetAlphaTestRef,GetStencilFunc,
            GetStencilRef,GetStencilValueMask,GetStencilFail,
            GetStencilPassDepthFail,GetStencilPassDepthPass,
            GetActiveStencilFace,GetDepthFunc,GetBlendEquation,GetBlendDstRGB,
            GetBlendSrcRGB,GetBlendDstAlpha,GetBlendSrcAlpha,GetBlendSrc,
            GetBlendDst,GetBlendColor,GetLogicOpMode),
   getInteger1, getInteger4, getEnum1, getFloat1, getFloat4, getDouble2,
   getBoolean1 )
import Graphics.Rendering.OpenGL.GL.StateVar (
   HasGetter(get), GettableStateVar, makeGettableStateVar,
   StateVar, makeStateVar )
import Graphics.Rendering.OpenGL.GL.VertexSpec ( Color4(..), rgbaMode )

--------------------------------------------------------------------------------

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         




                                                                                                                                                                          












--------------------------------------------------------------------------------

scissor :: StateVar (Maybe (Position, Size))
scissor =
   makeStateVarMaybe
      (return CapScissorTest)
      (getInteger4 makeSB GetScissorBox)
      (\(Position x y, Size w h) -> glScissor x y w h)
   where makeSB x y w h = (Position x y, Size (fromIntegral w) (fromIntegral h))
       
foreign import ccall unsafe "glScissor" glScissor ::
   GLint -> GLint -> GLsizei -> GLsizei -> IO ()

--------------------------------------------------------------------------------

sampleAlphaToCoverage :: StateVar Capability
sampleAlphaToCoverage = makeCapability CapSampleAlphaToCoverage

sampleAlphaToOne :: StateVar Capability
sampleAlphaToOne = makeCapability CapSampleAlphaToOne

sampleCoverage :: StateVar (Maybe (GLclampf, Bool))
sampleCoverage =
   makeStateVarMaybe
      (return CapSampleCoverage)
      (liftM2 (,) (getFloat1 id GetSampleCoverageValue)
                  (getBoolean1 unmarshalGLboolean GetSampleCoverageInvert))
      (\(value, invert) -> glSampleCoverageARB value (marshalGLboolean invert))

foreign import ccall unsafe "dynamic" dyn_glSampleCoverageARB :: Graphics.Rendering.OpenGL.GL.Extensions.Invoker (GLclampf -> GLboolean -> IO ()) ; glSampleCoverageARB :: (GLclampf -> GLboolean -> IO ()) ; glSampleCoverageARB = dyn_glSampleCoverageARB ptr_glSampleCoverageARB ; ptr_glSampleCoverageARB :: FunPtr a ; ptr_glSampleCoverageARB = unsafePerformIO (Graphics.Rendering.OpenGL.GL.Extensions.getProcAddress ("GL_ARB_multisample or OpenGL 1.3") ("glSampleCoverageARB")) ; {-# NOINLINE ptr_glSampleCoverageARB #-}

--------------------------------------------------------------------------------

depthBounds :: StateVar (Maybe (GLclampd, GLclampd))
depthBounds =
   makeStateVarMaybe
      (return CapDepthBoundsTest)
      (getDouble2 (,) GetDepthBounds)
      (uncurry glDepthBoundsEXT)
       
foreign import ccall unsafe "dynamic" dyn_glDepthBoundsEXT :: Graphics.Rendering.OpenGL.GL.Extensions.Invoker (GLclampd -> GLclampd -> IO ()) ; glDepthBoundsEXT :: (GLclampd -> GLclampd -> IO ()) ; glDepthBoundsEXT = dyn_glDepthBoundsEXT ptr_glDepthBoundsEXT ; ptr_glDepthBoundsEXT :: FunPtr a ; ptr_glDepthBoundsEXT = unsafePerformIO (Graphics.Rendering.OpenGL.GL.Extensions.getProcAddress ("GL_EXT_depth_bounds_test") ("glDepthBoundsEXT")) ; {-# NOINLINE ptr_glDepthBoundsEXT #-}

--------------------------------------------------------------------------------

alphaFunc :: StateVar (Maybe (ComparisonFunction, GLclampf))
alphaFunc =
   makeStateVarMaybe
      (return CapAlphaTest)
      (liftM2 (,) (getEnum1 unmarshalComparisonFunction GetAlphaTestFunc)
                  (getFloat1 id GetAlphaTestRef))
      (uncurry (glAlphaFunc . marshalComparisonFunction))

foreign import ccall unsafe "glAlphaFunc" glAlphaFunc ::
   GLenum -> GLclampf -> IO ()

--------------------------------------------------------------------------------

stencilTest :: StateVar Capability
stencilTest = makeCapability CapStencilTest

--------------------------------------------------------------------------------

stencilFunc :: StateVar (ComparisonFunction, GLint, GLuint)
stencilFunc =
   makeStateVar
      (liftM3 (,,) (getEnum1 unmarshalComparisonFunction GetStencilFunc)
                   (getInteger1 id GetStencilRef)
                   (getInteger1 fromIntegral GetStencilValueMask))
      (\(func, ref, mask) ->
         glStencilFunc (marshalComparisonFunction func) ref mask)

foreign import ccall unsafe "glStencilFunc" glStencilFunc ::
   GLenum -> GLint -> GLuint -> IO ()

--------------------------------------------------------------------------------

data StencilOp =
     OpZero
   | OpKeep
   | OpReplace
   | OpIncr
   | OpIncrWrap
   | OpDecr
   | OpDecrWrap
   | OpInvert
   deriving ( Eq, Ord, Show )

marshalStencilOp :: StencilOp -> GLenum
marshalStencilOp x = case x of
   OpZero -> 0x0
   OpKeep -> 0x1e00
   OpReplace -> 0x1e01
   OpIncr -> 0x1e02
   OpIncrWrap -> 0x8507
   OpDecr -> 0x1e03
   OpDecrWrap -> 0x8508
   OpInvert -> 0x150a

unmarshalStencilOp :: GLenum -> StencilOp
unmarshalStencilOp x
   | x == 0x0 = OpZero
   | x == 0x1e00 = OpKeep
   | x == 0x1e01 = OpReplace
   | x == 0x1e02 = OpIncr
   | x == 0x8507 = OpIncrWrap
   | x == 0x1e03 = OpDecr
   | x == 0x8508 = OpDecrWrap
   | x == 0x150a = OpInvert
   | otherwise = error ("unmarshalStencilOp: illegal value " ++ show x)

--------------------------------------------------------------------------------

stencilOp :: StateVar (StencilOp, StencilOp, StencilOp)
stencilOp =
   makeStateVar
      (liftM3 (,,) (getEnum1 unmarshalStencilOp GetStencilFail)
                   (getEnum1 unmarshalStencilOp GetStencilPassDepthFail)
                   (getEnum1 unmarshalStencilOp GetStencilPassDepthPass))
      (\(sf, spdf, spdp) -> glStencilOp (marshalStencilOp sf)
                                        (marshalStencilOp spdf)
                                        (marshalStencilOp spdp))

foreign import ccall unsafe "glStencilOp" glStencilOp ::
   GLenum -> GLenum -> GLenum -> IO ()

--------------------------------------------------------------------------------

activeStencilFace :: StateVar (Maybe Face)
activeStencilFace =
   makeStateVarMaybe
      (return CapStencilTestTwoSide)
      (getEnum1 unmarshalFace GetActiveStencilFace)
      (glActiveStencilFaceEXT . marshalFace)

foreign import ccall unsafe "dynamic" dyn_glActiveStencilFaceEXT :: Graphics.Rendering.OpenGL.GL.Extensions.Invoker (GLenum -> IO ()) ; glActiveStencilFaceEXT :: (GLenum -> IO ()) ; glActiveStencilFaceEXT = dyn_glActiveStencilFaceEXT ptr_glActiveStencilFaceEXT ; ptr_glActiveStencilFaceEXT :: FunPtr a ; ptr_glActiveStencilFaceEXT = unsafePerformIO (Graphics.Rendering.OpenGL.GL.Extensions.getProcAddress ("GL_EXT_stencil_two_side") ("glActiveStencilFaceEXT")) ; {-# NOINLINE ptr_glActiveStencilFaceEXT #-}

--------------------------------------------------------------------------------

depthFunc :: StateVar (Maybe ComparisonFunction)
depthFunc =
   makeStateVarMaybe
      (return CapDepthTest)
      (getEnum1 unmarshalComparisonFunction GetDepthFunc)
      (glDepthFunc . marshalComparisonFunction)

foreign import ccall unsafe "glDepthFunc" glDepthFunc :: GLenum -> IO ()

--------------------------------------------------------------------------------

newtype QueryObject = QueryObject { queryID :: GLuint }
   deriving ( Eq, Ord, Show )

--------------------------------------------------------------------------------

instance ObjectName QueryObject where
   genObjectNames n =
      allocaArray n $ \buf -> do
        glGenQueriesARB (fromIntegral n) buf
        fmap (map QueryObject) $ peekArray n buf

   deleteObjectNames queryObjects =
      withArrayLen (map queryID queryObjects) $
         glDeleteQueriesARB . fromIntegral

   isObjectName = fmap unmarshalGLboolean . glIsQueryARB . queryID


foreign import ccall unsafe "dynamic" dyn_glGenQueriesARB :: Graphics.Rendering.OpenGL.GL.Extensions.Invoker (GLsizei -> Ptr GLuint -> IO ()) ; glGenQueriesARB :: (GLsizei -> Ptr GLuint -> IO ()) ; glGenQueriesARB = dyn_glGenQueriesARB ptr_glGenQueriesARB ; ptr_glGenQueriesARB :: FunPtr a ; ptr_glGenQueriesARB = unsafePerformIO (Graphics.Rendering.OpenGL.GL.Extensions.getProcAddress ("GL_ARB_occlusion_query or OpenGL 1.5") ("glGenQueriesARB")) ; {-# NOINLINE ptr_glGenQueriesARB #-}

foreign import ccall unsafe "dynamic" dyn_glDeleteQueriesARB :: Graphics.Rendering.OpenGL.GL.Extensions.Invoker (GLsizei -> Ptr GLuint -> IO ()) ; glDeleteQueriesARB :: (GLsizei -> Ptr GLuint -> IO ()) ; glDeleteQueriesARB = dyn_glDeleteQueriesARB ptr_glDeleteQueriesARB ; ptr_glDeleteQueriesARB :: FunPtr a ; ptr_glDeleteQueriesARB = unsafePerformIO (Graphics.Rendering.OpenGL.GL.Extensions.getProcAddress ("GL_ARB_occlusion_query or OpenGL 1.5") ("glDeleteQueriesARB")) ; {-# NOINLINE ptr_glDeleteQueriesARB #-}

foreign import ccall unsafe "dynamic" dyn_glIsQueryARB :: Graphics.Rendering.OpenGL.GL.Extensions.Invoker (GLuint -> IO GLboolean) ; glIsQueryARB :: (GLuint -> IO GLboolean) ; glIsQueryARB = dyn_glIsQueryARB ptr_glIsQueryARB ; ptr_glIsQueryARB :: FunPtr a ; ptr_glIsQueryARB = unsafePerformIO (Graphics.Rendering.OpenGL.GL.Extensions.getProcAddress ("GL_ARB_occlusion_query or OpenGL 1.5") ("glIsQueryARB")) ; {-# NOINLINE ptr_glIsQueryARB #-}

--------------------------------------------------------------------------------

data QueryTarget =
     SamplesPassed
   deriving ( Eq, Ord, Show )

marshalQueryTarget :: QueryTarget -> GLenum
marshalQueryTarget x = case x of
   SamplesPassed -> 0x8914

--------------------------------------------------------------------------------

beginQuery :: QueryTarget -> QueryObject -> IO ()
beginQuery t = glBeginQueryARB (marshalQueryTarget t) . queryID

foreign import ccall unsafe "dynamic" dyn_glBeginQueryARB :: Graphics.Rendering.OpenGL.GL.Extensions.Invoker (GLenum -> GLuint -> IO ()) ; glBeginQueryARB :: (GLenum -> GLuint -> IO ()) ; glBeginQueryARB = dyn_glBeginQueryARB ptr_glBeginQueryARB ; ptr_glBeginQueryARB :: FunPtr a ; ptr_glBeginQueryARB = unsafePerformIO (Graphics.Rendering.OpenGL.GL.Extensions.getProcAddress ("GL_ARB_occlusion_query or OpenGL 1.5") ("glBeginQueryARB")) ; {-# NOINLINE ptr_glBeginQueryARB #-}

endQuery :: QueryTarget -> IO ()
endQuery = glEndQueryARB . marshalQueryTarget

foreign import ccall unsafe "dynamic" dyn_glEndQueryARB :: Graphics.Rendering.OpenGL.GL.Extensions.Invoker (GLenum -> IO ()) ; glEndQueryARB :: (GLenum -> IO ()) ; glEndQueryARB = dyn_glEndQueryARB ptr_glEndQueryARB ; ptr_glEndQueryARB :: FunPtr a ; ptr_glEndQueryARB = unsafePerformIO (Graphics.Rendering.OpenGL.GL.Extensions.getProcAddress ("GL_ARB_occlusion_query or OpenGL 1.5") ("glEndQueryARB")) ; {-# NOINLINE ptr_glEndQueryARB #-}

withQuery :: QueryTarget -> QueryObject -> IO a -> IO a
withQuery t q = bracket_ (beginQuery t q) (endQuery t)

--------------------------------------------------------------------------------

data GetQueryPName =
     QueryCounterBits
   | CurrentQuery

marshalGetQueryPName :: GetQueryPName -> GLenum
marshalGetQueryPName x = case x of
   QueryCounterBits -> 0x8864
   CurrentQuery -> 0x8865

--------------------------------------------------------------------------------

queryCounterBits :: QueryTarget -> GettableStateVar GLsizei
queryCounterBits = getQueryi fromIntegral QueryCounterBits

currentQuery :: QueryTarget -> GettableStateVar (Maybe QueryObject)
currentQuery =
   getQueryi
      (\q -> if q == 0 then Nothing else Just (QueryObject (fromIntegral q)))
      CurrentQuery

getQueryi :: (GLint -> a) -> GetQueryPName -> QueryTarget -> GettableStateVar a
getQueryi f p t =
   makeGettableStateVar $
      alloca $ \buf -> do
         glGetQueryivARB (marshalQueryTarget t) (marshalGetQueryPName p) buf
         peek1 f buf

foreign import ccall unsafe "dynamic" dyn_glGetQueryivARB :: Graphics.Rendering.OpenGL.GL.Extensions.Invoker (GLenum -> GLenum -> Ptr GLint -> IO ()) ; glGetQueryivARB :: (GLenum -> GLenum -> Ptr GLint -> IO ()) ; glGetQueryivARB = dyn_glGetQueryivARB ptr_glGetQueryivARB ; ptr_glGetQueryivARB :: FunPtr a ; ptr_glGetQueryivARB = unsafePerformIO (Graphics.Rendering.OpenGL.GL.Extensions.getProcAddress ("GL_ARB_occlusion_query or OpenGL 1.5") ("glGetQueryivARB")) ; {-# NOINLINE ptr_glGetQueryivARB #-}

--------------------------------------------------------------------------------

data GetQueryObjectPName =
     QueryResult
   | QueryResultAvailable

marshalGetQueryObjectPName :: GetQueryObjectPName -> GLenum
marshalGetQueryObjectPName x = case x of
   QueryResult -> 0x8866
   QueryResultAvailable -> 0x8867

--------------------------------------------------------------------------------

queryResult :: QueryObject -> GettableStateVar GLuint
queryResult = getQueryObjectui id QueryResult

queryResultAvailable :: QueryObject -> GettableStateVar Bool
queryResultAvailable = getQueryObjectui unmarshalGLboolean QueryResultAvailable

getQueryObjectui ::
   (GLuint -> a) -> GetQueryObjectPName -> QueryObject -> GettableStateVar a
getQueryObjectui f p q =
   makeGettableStateVar $
      alloca $ \buf -> do
         glGetQueryObjectuivARB (queryID q) (marshalGetQueryObjectPName p) buf
         peek1 f buf

foreign import ccall unsafe "dynamic" dyn_glGetQueryObjectuivARB :: Graphics.Rendering.OpenGL.GL.Extensions.Invoker (GLuint -> GLenum -> Ptr GLuint -> IO ()) ; glGetQueryObjectuivARB :: (GLuint -> GLenum -> Ptr GLuint -> IO ()) ; glGetQueryObjectuivARB = dyn_glGetQueryObjectuivARB ptr_glGetQueryObjectuivARB ; ptr_glGetQueryObjectuivARB :: FunPtr a ; ptr_glGetQueryObjectuivARB = unsafePerformIO (Graphics.Rendering.OpenGL.GL.Extensions.getProcAddress ("GL_ARB_occlusion_query or OpenGL 1.5") ("glGetQueryObjectuivARB")) ; {-# NOINLINE ptr_glGetQueryObjectuivARB #-}

--------------------------------------------------------------------------------

blend :: StateVar Capability
blend = makeCapability CapBlend

--------------------------------------------------------------------------------

data BlendEquation =
     FuncAdd
   | FuncSubtract
   | FuncReverseSubtract
   | Min
   | Max
   | LogicOp
   deriving ( Eq, Ord, Show )

marshalBlendEquation :: BlendEquation -> GLenum
marshalBlendEquation x = case x of
   FuncAdd -> 0x8006
   FuncSubtract -> 0x800a
   FuncReverseSubtract -> 0x800b
   Min -> 0x8007
   Max -> 0x8008
   LogicOp -> 0xbf1

unmarshalBlendEquation :: GLenum -> BlendEquation
unmarshalBlendEquation x
   | x == 0x8006 = FuncAdd
   | x == 0x800a = FuncSubtract
   | x == 0x800b = FuncReverseSubtract
   | x == 0x8007 = Min
   | x == 0x8008 = Max
   | x == 0xbf1 = LogicOp
   | otherwise = error ("unmarshalBlendEquation: illegal value " ++ show x)

--------------------------------------------------------------------------------

blendEquation :: StateVar BlendEquation
blendEquation =
   makeStateVar
      (getEnum1 unmarshalBlendEquation GetBlendEquation)
      (glBlendEquationEXT . marshalBlendEquation)

foreign import ccall unsafe "dynamic" dyn_glBlendEquationEXT :: Graphics.Rendering.OpenGL.GL.Extensions.Invoker (GLenum -> IO ()) ; glBlendEquationEXT :: (GLenum -> IO ()) ; glBlendEquationEXT = dyn_glBlendEquationEXT ptr_glBlendEquationEXT ; ptr_glBlendEquationEXT :: FunPtr a ; ptr_glBlendEquationEXT = unsafePerformIO (Graphics.Rendering.OpenGL.GL.Extensions.getProcAddress ("GL_EXT_blend_minmax or GL_EXT_blend_subtract or OpenGL 1.4") ("glBlendEquationEXT")) ; {-# NOINLINE ptr_glBlendEquationEXT #-}

--------------------------------------------------------------------------------

blendFuncSeparate ::
   StateVar ((BlendingFactor, BlendingFactor), (BlendingFactor, BlendingFactor))
blendFuncSeparate =
   makeStateVar
      (do srcRGB   <- getEnum1 unmarshalBlendingFactor GetBlendSrcRGB
          srcAlpha <- getEnum1 unmarshalBlendingFactor GetBlendSrcAlpha
          dstRGB   <- getEnum1 unmarshalBlendingFactor GetBlendDstRGB
          dstAlpha <- getEnum1 unmarshalBlendingFactor GetBlendDstAlpha
          return ((srcRGB, srcAlpha), (dstRGB, dstAlpha)))
      (\((srcRGB, srcAlpha), (dstRGB, dstAlpha)) ->
         glBlendFuncSeparateEXT (marshalBlendingFactor srcRGB)
                                (marshalBlendingFactor srcAlpha)
                                (marshalBlendingFactor dstRGB)
                                (marshalBlendingFactor dstAlpha))

foreign import ccall unsafe "dynamic" dyn_glBlendFuncSeparateEXT :: Graphics.Rendering.OpenGL.GL.Extensions.Invoker (GLenum -> GLenum -> GLenum -> GLenum -> IO ()) ; glBlendFuncSeparateEXT :: (GLenum -> GLenum -> GLenum -> GLenum -> IO ()) ; glBlendFuncSeparateEXT = dyn_glBlendFuncSeparateEXT ptr_glBlendFuncSeparateEXT ; ptr_glBlendFuncSeparateEXT :: FunPtr a ; ptr_glBlendFuncSeparateEXT = unsafePerformIO (Graphics.Rendering.OpenGL.GL.Extensions.getProcAddress ("GL_EXT_blend_func_separate or OpenGL 1.4") ("glBlendFuncSeparateEXT")) ; {-# NOINLINE ptr_glBlendFuncSeparateEXT #-}

blendFunc :: StateVar (BlendingFactor, BlendingFactor)
blendFunc =
   makeStateVar
      (liftM2 (,) (getEnum1 unmarshalBlendingFactor GetBlendSrc)
                  (getEnum1 unmarshalBlendingFactor GetBlendDst))
      (\(s, d) ->
         glBlendFunc (marshalBlendingFactor s) (marshalBlendingFactor d))

foreign import ccall unsafe "glBlendFunc" glBlendFunc ::
   GLenum -> GLenum -> IO ()

blendColor :: StateVar (Color4 GLclampf)
blendColor =
   makeStateVar
      (getFloat4 Color4 GetBlendColor)
      (\(Color4 r g b a) -> glBlendColorEXT r g b a)

foreign import ccall unsafe "dynamic" dyn_glBlendColorEXT :: Graphics.Rendering.OpenGL.GL.Extensions.Invoker (GLclampf -> GLclampf -> GLclampf -> GLclampf -> IO ()) ; glBlendColorEXT :: (GLclampf -> GLclampf -> GLclampf -> GLclampf -> IO ()) ; glBlendColorEXT = dyn_glBlendColorEXT ptr_glBlendColorEXT ; ptr_glBlendColorEXT :: FunPtr a ; ptr_glBlendColorEXT = unsafePerformIO (Graphics.Rendering.OpenGL.GL.Extensions.getProcAddress ("GL_EXT_blend_color or OpenGL 1.4") ("glBlendColorEXT")) ; {-# NOINLINE ptr_glBlendColorEXT #-}

--------------------------------------------------------------------------------

dither :: StateVar Capability
dither = makeCapability CapDither

--------------------------------------------------------------------------------

data LogicOp =
     Clear
   | And
   | AndReverse
   | Copy
   | AndInverted
   | Noop
   | Xor
   | Or
   | Nor
   | Equiv
   | Invert
   | OrReverse
   | CopyInverted
   | OrInverted
   | Nand
   | Set
   deriving ( Eq, Ord, Show )

marshalLogicOp :: LogicOp -> GLenum
marshalLogicOp x = case x of
   Clear -> 0x1500
   And -> 0x1501
   AndReverse -> 0x1502
   Copy -> 0x1503
   AndInverted -> 0x1504
   Noop -> 0x1505
   Xor -> 0x1506
   Or -> 0x1507
   Nor -> 0x1508
   Equiv -> 0x1509
   Invert -> 0x150a
   OrReverse -> 0x150b
   CopyInverted -> 0x150c
   OrInverted -> 0x150d
   Nand -> 0x150e
   Set -> 0x150f

unmarshalLogicOp :: GLenum -> LogicOp
unmarshalLogicOp x
   | x == 0x1500 = Clear
   | x == 0x1501 = And
   | x == 0x1502 = AndReverse
   | x == 0x1503 = Copy
   | x == 0x1504 = AndInverted
   | x == 0x1505 = Noop
   | x == 0x1506 = Xor
   | x == 0x1507 = Or
   | x == 0x1508 = Nor
   | x == 0x1509 = Equiv
   | x == 0x150a = Invert
   | x == 0x150b = OrReverse
   | x == 0x150c = CopyInverted
   | x == 0x150d = OrInverted
   | x == 0x150e = Nand
   | x == 0x150f = Set
   | otherwise = error ("unmarshalLogicOp: illegal value " ++ show x)

--------------------------------------------------------------------------------

logicOp :: StateVar (Maybe LogicOp)
logicOp =
   makeStateVarMaybe
      (do rgba <- get rgbaMode
          return $ if rgba then CapColorLogicOp else CapIndexLogicOp)
      (getEnum1 unmarshalLogicOp GetLogicOpMode)
      (glLogicOp . marshalLogicOp)

foreign import ccall unsafe "glLogicOp" glLogicOp :: GLenum -> IO ()
