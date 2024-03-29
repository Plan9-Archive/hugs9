--------------------------------------------------------------------------------
-- |
-- Module      :  Graphics.Rendering.OpenGL.GL.BufferObjects
-- Copyright   :  (c) Sven Panne 2002-2005
-- License     :  BSD-style (see the file libraries/OpenGL/LICENSE)
-- 
-- Maintainer  :  sven.panne@aedion.de
-- Stability   :  provisional
-- Portability :  portable
--
-- This module corresponds to section 2.9 (Buffer Objects) of the OpenGL 1.5
-- specs.
--
--------------------------------------------------------------------------------

module Graphics.Rendering.OpenGL.GL.BufferObjects (
   -- * Object Names
   ObjectName(..),

   -- * Buffer Objects
   BufferObject(BufferObject),

   -- * Binding Buffer Objects
   BufferTarget(..), bindBuffer, arrayBufferBinding,

   -- * Handling Buffer Data
   BufferUsage(..), bufferData, TransferDirection(..), bufferSubData,

   -- * Mapping Buffer Objects
   BufferAccess(..), MappingFailure(..), withMappedBuffer,
   bufferAccess, bufferMapped
) where

import Foreign.Marshal.Alloc ( alloca )
import Foreign.Marshal.Array ( withArrayLen, peekArray, allocaArray )
import Foreign.Ptr ( Ptr, nullPtr )
import Foreign.Storable ( Storable(peek) )
import Graphics.Rendering.OpenGL.GL.BasicTypes (
   GLboolean, GLenum, GLint, GLintptr, GLuint, GLsizei, GLsizeiptr )
import Graphics.Rendering.OpenGL.GL.Exception ( finallyRet )
import Graphics.Rendering.OpenGL.GL.Extensions (
   FunPtr, unsafePerformIO, Invoker, getProcAddress )
import Graphics.Rendering.OpenGL.GL.GLboolean ( unmarshalGLboolean )
import Graphics.Rendering.OpenGL.GL.PeekPoke ( peek1 )
import Graphics.Rendering.OpenGL.GL.QueryUtils (
   GetPName(GetArrayBufferBinding,GetElementArrayBufferBinding,
            GetVertexArrayBufferBinding,GetNormalArrayBufferBinding,
            GetColorArrayBufferBinding,GetIndexArrayBufferBinding,
            GetTextureCoordArrayBufferBinding,GetEdgeFlagArrayBufferBinding,
            GetFogCoordArrayBufferBinding,GetSecondaryColorArrayBufferBinding),
   getInteger1 )
import Graphics.Rendering.OpenGL.GL.StateVar (
   GettableStateVar, makeGettableStateVar, StateVar, makeStateVar )
import Graphics.Rendering.OpenGL.GL.VertexArrays ( ClientArrayType(..) )
import Graphics.Rendering.OpenGL.GLU.ErrorsInternal ( recordInvalidEnum )

--------------------------------------------------------------------------------

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         




                                                                                                                                                                          












--------------------------------------------------------------------------------

-- | An 'ObjectName' corresponds to the general OpenGL notion of an explicitly
-- handled object name, e.g. a display list name, a texture object name, a
-- buffer object name, etc.

class ObjectName a where
   genObjectNames :: Int -> IO [a]
   deleteObjectNames:: [a] -> IO ()
   isObjectName :: a -> IO Bool

--------------------------------------------------------------------------------

newtype BufferObject = BufferObject { bufferID :: GLuint }
   deriving ( Eq, Ord, Show )

--------------------------------------------------------------------------------

instance ObjectName BufferObject where
   genObjectNames n =
      allocaArray n $ \buf -> do
        glGenBuffersARB (fromIntegral n) buf
        fmap (map BufferObject) $ peekArray n buf

   deleteObjectNames bufferObjects =
      withArrayLen (map bufferID bufferObjects) $
         glDeleteBuffersARB . fromIntegral

   isObjectName = fmap unmarshalGLboolean . glIsBufferARB . bufferID

foreign import ccall unsafe "dynamic" dyn_glGenBuffersARB :: Graphics.Rendering.OpenGL.GL.Extensions.Invoker (GLsizei -> Ptr GLuint -> IO ()) ; glGenBuffersARB :: (GLsizei -> Ptr GLuint -> IO ()) ; glGenBuffersARB = dyn_glGenBuffersARB ptr_glGenBuffersARB ; ptr_glGenBuffersARB :: FunPtr a ; ptr_glGenBuffersARB = unsafePerformIO (Graphics.Rendering.OpenGL.GL.Extensions.getProcAddress ("GL_ARB_vertex_buffer_object or OpenGL 1.5") ("glGenBuffersARB")) ; {-# NOINLINE ptr_glGenBuffersARB #-}

foreign import ccall unsafe "dynamic" dyn_glDeleteBuffersARB :: Graphics.Rendering.OpenGL.GL.Extensions.Invoker (GLsizei -> Ptr GLuint -> IO ()) ; glDeleteBuffersARB :: (GLsizei -> Ptr GLuint -> IO ()) ; glDeleteBuffersARB = dyn_glDeleteBuffersARB ptr_glDeleteBuffersARB ; ptr_glDeleteBuffersARB :: FunPtr a ; ptr_glDeleteBuffersARB = unsafePerformIO (Graphics.Rendering.OpenGL.GL.Extensions.getProcAddress ("GL_ARB_vertex_buffer_object or OpenGL 1.5") ("glDeleteBuffersARB")) ; {-# NOINLINE ptr_glDeleteBuffersARB #-}

foreign import ccall unsafe "dynamic" dyn_glIsBufferARB :: Graphics.Rendering.OpenGL.GL.Extensions.Invoker (GLuint -> IO GLboolean) ; glIsBufferARB :: (GLuint -> IO GLboolean) ; glIsBufferARB = dyn_glIsBufferARB ptr_glIsBufferARB ; ptr_glIsBufferARB :: FunPtr a ; ptr_glIsBufferARB = unsafePerformIO (Graphics.Rendering.OpenGL.GL.Extensions.getProcAddress ("GL_ARB_vertex_buffer_object or OpenGL 1.5") ("glIsBufferARB")) ; {-# NOINLINE ptr_glIsBufferARB #-}

--------------------------------------------------------------------------------

data BufferTarget =
     ArrayBuffer
   | ElementArrayBuffer
   deriving ( Eq, Ord, Show )

marshalBufferTarget :: BufferTarget -> GLenum
marshalBufferTarget x = case x of
   ArrayBuffer -> 0x8892
   ElementArrayBuffer -> 0x8893

bufferTargetToGetPName :: BufferTarget -> GetPName
bufferTargetToGetPName x = case x of
   ArrayBuffer -> GetArrayBufferBinding
   ElementArrayBuffer -> GetElementArrayBufferBinding

--------------------------------------------------------------------------------

data BufferUsage =
     StreamDraw
   | StreamRead
   | StreamCopy
   | StaticDraw
   | StaticRead
   | StaticCopy
   | DynamicDraw
   | DynamicRead
   | DynamicCopy
   deriving ( Eq, Ord, Show )

marshalBufferUsage :: BufferUsage -> GLenum
marshalBufferUsage x = case x of
   StreamDraw -> 0x88e0
   StreamRead -> 0x88e1
   StreamCopy -> 0x88e2
   StaticDraw -> 0x88e4
   StaticRead -> 0x88e5
   StaticCopy -> 0x88e6
   DynamicDraw -> 0x88e8
   DynamicRead -> 0x88e9
   DynamicCopy -> 0x88ea

unmarshalBufferUsage :: GLenum -> BufferUsage
unmarshalBufferUsage x
   | x == 0x88e0 = StreamDraw
   | x == 0x88e1 = StreamRead
   | x == 0x88e2 = StreamCopy
   | x == 0x88e4 = StaticDraw
   | x == 0x88e5 = StaticRead
   | x == 0x88e6 = StaticCopy
   | x == 0x88e8 = DynamicDraw
   | x == 0x88e9 = DynamicRead
   | x == 0x88ea = DynamicCopy
   | otherwise = error ("unmarshalBufferUsage: illegal value " ++ show x)

--------------------------------------------------------------------------------

data BufferAccess =
     ReadOnly
   | WriteOnly
   | ReadWrite
   deriving ( Eq, Ord, Show )

marshalBufferAccess :: BufferAccess -> GLenum
marshalBufferAccess x = case x of
   ReadOnly -> 0x88b8
   WriteOnly -> 0x88b9
   ReadWrite -> 0x88ba

unmarshalBufferAccess :: GLenum -> BufferAccess
unmarshalBufferAccess x
   | x == 0x88b8 = ReadOnly
   | x == 0x88b9 = WriteOnly
   | x == 0x88ba = ReadWrite
   | otherwise = error ("unmarshalBufferAccess: illegal value " ++ show x)

--------------------------------------------------------------------------------

bindBuffer :: BufferTarget -> StateVar (Maybe BufferObject)
bindBuffer t = makeStateVar (getBindBuffer t) (setBindBuffer t)

getBindBuffer :: BufferTarget -> IO (Maybe BufferObject)
getBindBuffer = bufferQuery bufferTargetToGetPName

bufferQuery :: (a -> GetPName) -> a -> IO (Maybe BufferObject)
bufferQuery func t = do
   buf <- getInteger1 (BufferObject . fromIntegral) (func t)
   return $ if buf == noBufferObject then Nothing else Just buf

noBufferObject :: BufferObject
noBufferObject = BufferObject 0

setBindBuffer :: BufferTarget -> Maybe BufferObject -> IO ()
setBindBuffer t =
   glBindBufferARB (marshalBufferTarget t) . bufferID . maybe noBufferObject id

foreign import ccall unsafe "dynamic" dyn_glBindBufferARB :: Graphics.Rendering.OpenGL.GL.Extensions.Invoker (GLenum -> GLuint -> IO ()) ; glBindBufferARB :: (GLenum -> GLuint -> IO ()) ; glBindBufferARB = dyn_glBindBufferARB ptr_glBindBufferARB ; ptr_glBindBufferARB :: FunPtr a ; ptr_glBindBufferARB = unsafePerformIO (Graphics.Rendering.OpenGL.GL.Extensions.getProcAddress ("GL_ARB_vertex_buffer_object or OpenGL 1.5") ("glBindBufferARB")) ; {-# NOINLINE ptr_glBindBufferARB #-}

clientArrayTypeToGetPName :: ClientArrayType -> GetPName
clientArrayTypeToGetPName x = case x of
   VertexArray -> GetVertexArrayBufferBinding
   NormalArray -> GetNormalArrayBufferBinding
   ColorArray -> GetColorArrayBufferBinding
   IndexArray -> GetIndexArrayBufferBinding
   TextureCoordArray -> GetTextureCoordArrayBufferBinding
   EdgeFlagArray -> GetEdgeFlagArrayBufferBinding
   FogCoordArray -> GetFogCoordArrayBufferBinding
   SecondaryColorArray -> GetSecondaryColorArrayBufferBinding
   MatrixIndexArray -> error "clientArrayTypeToGetPName: impossible"

arrayBufferBinding :: ClientArrayType -> GettableStateVar (Maybe BufferObject)
arrayBufferBinding t =
   makeGettableStateVar $ case t of
      MatrixIndexArray -> do recordInvalidEnum ; return Nothing
      _ -> bufferQuery clientArrayTypeToGetPName t

--------------------------------------------------------------------------------

bufferData :: BufferTarget -> StateVar (GLsizeiptr, Ptr a, BufferUsage)
bufferData t = makeStateVar (getBufferData t) (setBufferData t)

getBufferData :: BufferTarget -> IO (GLsizeiptr, Ptr a, BufferUsage)
getBufferData t = do
   s <- getBufferParameter t fromIntegral GetBufferSize
   p <- getBufferPointer t
   u <- getBufferParameter t unmarshalBufferUsage GetBufferUsage
   return (s, p, u)

setBufferData :: BufferTarget -> (GLsizeiptr, Ptr a, BufferUsage) -> IO ()
setBufferData t (s, p, u) =
   glBufferDataARB (marshalBufferTarget t) s p (marshalBufferUsage u)

foreign import ccall unsafe "dynamic" dyn_glBufferDataARB :: Graphics.Rendering.OpenGL.GL.Extensions.Invoker (GLenum -> GLsizeiptr -> Ptr a -> GLenum -> IO ()) ; glBufferDataARB :: (GLenum -> GLsizeiptr -> Ptr a -> GLenum -> IO ()) ; glBufferDataARB = dyn_glBufferDataARB ptr_glBufferDataARB ; ptr_glBufferDataARB :: FunPtr a ; ptr_glBufferDataARB = unsafePerformIO (Graphics.Rendering.OpenGL.GL.Extensions.getProcAddress ("GL_ARB_vertex_buffer_object or OpenGL 1.5") ("glBufferDataARB")) ; {-# NOINLINE ptr_glBufferDataARB #-}

--------------------------------------------------------------------------------

data TransferDirection =
     ReadFromBuffer
   | WriteToBuffer
   deriving ( Eq, Ord, Show )

bufferSubData ::
   BufferTarget -> TransferDirection -> GLintptr -> GLsizeiptr -> Ptr a -> IO ()
bufferSubData t WriteToBuffer = glBufferSubDataARB (marshalBufferTarget t)
bufferSubData t ReadFromBuffer = glGetBufferSubDataARB (marshalBufferTarget t)

foreign import ccall unsafe "dynamic" dyn_glBufferSubDataARB :: Graphics.Rendering.OpenGL.GL.Extensions.Invoker (GLenum -> GLintptr -> GLsizeiptr -> Ptr a -> IO ()) ; glBufferSubDataARB :: (GLenum -> GLintptr -> GLsizeiptr -> Ptr a -> IO ()) ; glBufferSubDataARB = dyn_glBufferSubDataARB ptr_glBufferSubDataARB ; ptr_glBufferSubDataARB :: FunPtr a ; ptr_glBufferSubDataARB = unsafePerformIO (Graphics.Rendering.OpenGL.GL.Extensions.getProcAddress ("GL_ARB_vertex_buffer_object or OpenGL 1.5") ("glBufferSubDataARB")) ; {-# NOINLINE ptr_glBufferSubDataARB #-}

foreign import ccall unsafe "dynamic" dyn_glGetBufferSubDataARB :: Graphics.Rendering.OpenGL.GL.Extensions.Invoker (GLenum -> GLintptr -> GLsizeiptr -> Ptr a -> IO ()) ; glGetBufferSubDataARB :: (GLenum -> GLintptr -> GLsizeiptr -> Ptr a -> IO ()) ; glGetBufferSubDataARB = dyn_glGetBufferSubDataARB ptr_glGetBufferSubDataARB ; ptr_glGetBufferSubDataARB :: FunPtr a ; ptr_glGetBufferSubDataARB = unsafePerformIO (Graphics.Rendering.OpenGL.GL.Extensions.getProcAddress ("GL_ARB_vertex_buffer_object or OpenGL 1.5") ("glGetBufferSubDataARB")) ; {-# NOINLINE ptr_glGetBufferSubDataARB #-}

--------------------------------------------------------------------------------

data GetBufferPName =
     GetBufferSize
   | GetBufferUsage
   | GetBufferAccess
   | GetBufferMapped

marshalGetBufferPName :: GetBufferPName -> GLenum
marshalGetBufferPName x = case x of
   GetBufferSize -> 0x8764
   GetBufferUsage -> 0x8765
   GetBufferAccess -> 0x88bb
   GetBufferMapped -> 0x88bc

getBufferParameter :: BufferTarget -> (GLenum -> a) -> GetBufferPName -> IO a
getBufferParameter t f p = alloca $ \buf -> do
   glGetBufferParameterivARB (marshalBufferTarget t)
                             (marshalGetBufferPName p) buf
   peek1 (f . fromIntegral) buf

foreign import ccall unsafe "dynamic" dyn_glGetBufferParameterivARB :: Graphics.Rendering.OpenGL.GL.Extensions.Invoker (GLenum -> GLenum -> Ptr GLint -> IO ()) ; glGetBufferParameterivARB :: (GLenum -> GLenum -> Ptr GLint -> IO ()) ; glGetBufferParameterivARB = dyn_glGetBufferParameterivARB ptr_glGetBufferParameterivARB ; ptr_glGetBufferParameterivARB :: FunPtr a ; ptr_glGetBufferParameterivARB = unsafePerformIO (Graphics.Rendering.OpenGL.GL.Extensions.getProcAddress ("GL_ARB_vertex_buffer_object or OpenGL 1.5") ("glGetBufferParameterivARB")) ; {-# NOINLINE ptr_glGetBufferParameterivARB #-}

--------------------------------------------------------------------------------

getBufferPointer :: BufferTarget -> IO (Ptr a)
getBufferPointer t = alloca $ \buf -> do
   -- only one pname: GL_BUFFER_MAP_POINTER
   glGetBufferPointervARB (marshalBufferTarget t) 0x88bd buf
   peek buf

foreign import ccall unsafe "dynamic" dyn_glGetBufferPointervARB :: Graphics.Rendering.OpenGL.GL.Extensions.Invoker (GLenum -> GLenum -> Ptr (Ptr a) -> IO ()) ; glGetBufferPointervARB :: (GLenum -> GLenum -> Ptr (Ptr a) -> IO ()) ; glGetBufferPointervARB = dyn_glGetBufferPointervARB ptr_glGetBufferPointervARB ; ptr_glGetBufferPointervARB :: FunPtr a ; ptr_glGetBufferPointervARB = unsafePerformIO (Graphics.Rendering.OpenGL.GL.Extensions.getProcAddress ("GL_ARB_vertex_buffer_object or OpenGL 1.5") ("glGetBufferPointervARB")) ; {-# NOINLINE ptr_glGetBufferPointervARB #-}

--------------------------------------------------------------------------------

data MappingFailure =
     MappingFailed
   | UnmappingFailed
   deriving ( Eq, Ord, Show )

withMappedBuffer :: BufferTarget -> BufferAccess -> (Ptr a -> IO b) -> (MappingFailure -> IO b) -> IO b
withMappedBuffer t a action err = do
   buf <- mapBuffer t a
   if buf == nullPtr
      then err MappingFailed
      else do (ret, ok) <- action buf `finallyRet` unmapBuffer t
              if ok
                 then return ret
                 else err UnmappingFailed

mapBuffer :: BufferTarget -> BufferAccess -> IO (Ptr a)
mapBuffer t = glMapBufferARB (marshalBufferTarget t) . marshalBufferAccess

foreign import ccall unsafe "dynamic" dyn_glMapBufferARB :: Graphics.Rendering.OpenGL.GL.Extensions.Invoker (GLenum -> GLenum -> IO (Ptr a)) ; glMapBufferARB :: (GLenum -> GLenum -> IO (Ptr a)) ; glMapBufferARB = dyn_glMapBufferARB ptr_glMapBufferARB ; ptr_glMapBufferARB :: FunPtr a ; ptr_glMapBufferARB = unsafePerformIO (Graphics.Rendering.OpenGL.GL.Extensions.getProcAddress ("GL_ARB_vertex_buffer_object or OpenGL 1.5") ("glMapBufferARB")) ; {-# NOINLINE ptr_glMapBufferARB #-}

unmapBuffer :: BufferTarget -> IO Bool
unmapBuffer = fmap unmarshalGLboolean . glUnmapBufferARB . marshalBufferTarget

foreign import ccall unsafe "dynamic" dyn_glUnmapBufferARB :: Graphics.Rendering.OpenGL.GL.Extensions.Invoker (GLenum -> IO GLboolean) ; glUnmapBufferARB :: (GLenum -> IO GLboolean) ; glUnmapBufferARB = dyn_glUnmapBufferARB ptr_glUnmapBufferARB ; ptr_glUnmapBufferARB :: FunPtr a ; ptr_glUnmapBufferARB = unsafePerformIO (Graphics.Rendering.OpenGL.GL.Extensions.getProcAddress ("GL_ARB_vertex_buffer_object or OpenGL 1.5") ("glUnmapBufferARB")) ; {-# NOINLINE ptr_glUnmapBufferARB #-}

bufferAccess :: BufferTarget -> GettableStateVar BufferAccess
bufferAccess t = makeGettableStateVar $
   getBufferParameter t unmarshalBufferAccess GetBufferAccess

bufferMapped :: BufferTarget -> GettableStateVar Bool
bufferMapped t = makeGettableStateVar $
   getBufferParameter t unmarshalGLboolean GetBufferMapped
