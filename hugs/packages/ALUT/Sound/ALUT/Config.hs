-- #hide
--------------------------------------------------------------------------------
-- |
-- Module      :  Sound.ALUT.Config
-- Copyright   :  (c) Sven Panne 2006
-- License     :  BSD-style (see the file libraries/ALUT/LICENSE)
-- 
-- Maintainer  :  sven.panne@aedion.de
-- Stability   :  provisional
-- Portability :  portable
--
-- This purely internal module defines the platform-specific stuff which has
-- been figured out by configure.
--
--------------------------------------------------------------------------------

module Sound.ALUT.Config (
   alut_Init,
   alut_InitWithoutContext,
   alut_Exit,

   alut_GetError,
   alut_GetErrorString,

   alut_CreateBufferFromFile,
   alut_CreateBufferFromFileImage,
   alut_CreateBufferHelloWorld,
   alut_CreateBufferWaveform,

   alut_LoadMemoryFromFile,
   alut_LoadMemoryFromFileImage,
   alut_LoadMemoryHelloWorld,
   alut_LoadMemoryWaveform,

   alut_GetMIMETypes,

   alut_GetMajorVersion,
   alut_GetMinorVersion,

   alut_Sleep
) where

--------------------------------------------------------------------------------

                                                                              
                                                                             

                                             
                          

                                             
                          

                                                     


                                                             


                                                           


                                          


                                          


                                      


                                      


                                         


                                          


                                      


                                        


                                            


                                                                      


                                                                           


                                                                        


                                                                      


                                                          


                                                                


                                                                 


                                                              


                                                                 


                                                                    


                                                                    


                                                                         


                                                                      


                                                                    


                                                       


                                                          


                                                           


                                                         


                                                              
                               

                                                         


                                                         


                                                          


                                                         


                                                           


                                                            


                                                         


                                                                              


                                              


                                                          


                                                          


                                            


                                                      




--------------------------------------------------------------------------------

import Foreign.C
import Foreign.Ptr
import Sound.OpenAL.AL.BasicTypes














--------------------------------------------------------------------------------











foreign import ccall unsafe "alutInit"
   alut_Init :: Ptr CInt -> Ptr CString -> IO ALboolean



--------------------------------------------------------------------------------



foreign import ccall unsafe "alutInitWithoutContext"
   alut_InitWithoutContext :: Ptr CInt -> Ptr CString -> IO ALboolean








--------------------------------------------------------------------------------











foreign import ccall unsafe "alutExit"
   alut_Exit :: IO ALboolean



--------------------------------------------------------------------------------



foreign import ccall unsafe "alutGetError"
   alut_GetError :: IO ALenum








--------------------------------------------------------------------------------

alut_GetErrorString :: ALenum -> IO String



alut_GetErrorString e = peekCString =<< alutGetErrorString e

foreign import ccall unsafe "alutGetErrorString"
   alutGetErrorString :: ALenum -> IO CString







--------------------------------------------------------------------------------



foreign import ccall unsafe "alutCreateBufferFromFile"
   alut_CreateBufferFromFile :: CString -> IO ALuint








--------------------------------------------------------------------------------



foreign import ccall unsafe "alutCreateBufferFromFileImage"
   alut_CreateBufferFromFileImage :: Ptr a -> ALsizei -> IO ALuint








--------------------------------------------------------------------------------



foreign import ccall unsafe "alutCreateBufferHelloWorld"
   alut_CreateBufferHelloWorld :: IO ALuint








--------------------------------------------------------------------------------



foreign import ccall unsafe "alutCreateBufferWaveform"
   alut_CreateBufferWaveform :: ALenum -> ALfloat -> ALfloat -> ALfloat -> IO ALuint








--------------------------------------------------------------------------------



foreign import ccall unsafe "alutLoadMemoryFromFile"
   alut_LoadMemoryFromFile :: CString -> Ptr ALenum -> Ptr ALsizei -> Ptr ALfloat -> IO (Ptr b)








--------------------------------------------------------------------------------



foreign import ccall unsafe "alutLoadMemoryFromFileImage"
   alut_LoadMemoryFromFileImage :: Ptr a -> ALsizei -> Ptr ALenum -> Ptr ALsizei -> Ptr ALfloat -> IO (Ptr b)








--------------------------------------------------------------------------------



foreign import ccall unsafe "alutLoadMemoryHelloWorld"
   alut_LoadMemoryHelloWorld :: Ptr ALenum -> Ptr ALsizei -> Ptr ALfloat -> IO (Ptr b)








--------------------------------------------------------------------------------



foreign import ccall unsafe "alutLoadMemoryWaveform"
   alut_LoadMemoryWaveform :: ALenum -> ALfloat -> ALfloat -> ALfloat -> Ptr ALenum -> Ptr ALsizei -> Ptr ALfloat -> IO (Ptr b)








--------------------------------------------------------------------------------



foreign import ccall unsafe "alutGetMIMETypes"
   alut_GetMIMETypes :: ALenum -> IO CString








--------------------------------------------------------------------------------



foreign import ccall unsafe "alutGetMajorVersion"
   alut_GetMajorVersion :: IO ALint








--------------------------------------------------------------------------------



foreign import ccall unsafe "alutGetMinorVersion"
   alut_GetMinorVersion :: IO ALint








--------------------------------------------------------------------------------



foreign import ccall unsafe "alutSleep"
   alut_Sleep :: ALfloat -> IO ALboolean



















