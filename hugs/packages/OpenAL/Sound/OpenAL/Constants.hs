-- #hide
--------------------------------------------------------------------------------
-- |
-- Module      :  Sound.OpenAL.Constants
-- Copyright   :  (c) Sven Panne 2005
-- License     :  BSD-style (see the file libraries/OpenAL/LICENSE)
-- 
-- Maintainer  :  sven.panne@aedion.de
-- Stability   :  provisional
-- Portability :  portable
--
-- This purely internal module defines all AL\/ALC constants, which have been
-- figured out by configure. In contrast to OpenGL and GLUT, these constants
-- varied on different platforms in the past and have evolved quite a bit.
--
--------------------------------------------------------------------------------

module Sound.OpenAL.Constants where

import Sound.OpenAL.Config (
   ALboolean, ALint, ALenum, ALCboolean, ALCint, ALCenum )

--------------------------------------------------------------------------------

                                                                                  
                                                                               

                                                   
                                

                                                      


                                                          
                                       

                                                      


                                                           


                                                         


                                      


                                       


                                                        


                                                


                                       


                                                


                                        


                                  


                             


                                 


                                       


                                      


                                    


                                         


                                     


                                     


                                     


                                    


                                


                                     


                               


                                      


                            


                            


                           


                             


                                        


                                     


                                  


                               


                                       


                                       


                                      


                                


                                     


                                     


                                        


                                                


                                 


                            


                                    


                                   


                                      


                                     


                                


                           


                              


                                   


                                   


                                        


                                    


                                       


                                               


                                      


                                              


                              


                                   


                               


                               


                           


                               


                                  


                                    


                             


                            


                              


                               


                                         


                               


                                     


                                    


                                 


                           


                                      


                                   


                                  


                                     


                             


                              


                                


                           


                                   


                               


                             


                              


                                                         


                                                           


                                                        


                                                           


                                                         


                                                             
                              

                                                               
                                

                                                            
                             

                                                         


                                                         


                                                          


                                                         


                                                           


                                                            


                                                         


                                          


                                       


                                           


                                        


                                        


                                          


                                        


                                         


                                       


                                       


                                         


                                         


                                         


                                        


                                          


                                         


                                       


                                        


                                      


                                        


                                        


                                        


                                       


                                         


                                                                              


                                              


                                                          


                                                          


                                            


                                                      




--------------------------------------------------------------------------------

al_FALSE, al_TRUE :: ALboolean
al_FALSE                            = 0
al_TRUE                             = 1

al_NO_ERROR, al_INVALID_NAME, al_INVALID_ENUM, al_INVALID_VALUE,
   al_INVALID_OPERATION, al_OUT_OF_MEMORY :: ALenum
al_NO_ERROR                         = 0
al_INVALID_NAME                     = 40961
al_INVALID_ENUM                     = 40962
al_INVALID_VALUE                    = 40963
al_INVALID_OPERATION                = 40964
al_OUT_OF_MEMORY                    = 40965

--------------------------------------------------------------------------------

al_DISTANCE_MODEL, al_DOPPLER_FACTOR, al_SPEED_OF_SOUND :: ALenum
al_DISTANCE_MODEL                   = 53248
al_DOPPLER_FACTOR                   = 49152
al_SPEED_OF_SOUND                   = 49155

al_VERSION, al_RENDERER, al_VENDOR, al_EXTENSIONS :: ALenum
al_VERSION                          = 45058
al_RENDERER                         = 45059
al_VENDOR                           = 45057
al_EXTENSIONS                       = 45060

al_NONE, al_INVERSE_DISTANCE, al_INVERSE_DISTANCE_CLAMPED, al_LINEAR_DISTANCE,
   al_LINEAR_DISTANCE_CLAMPED, al_EXPONENT_DISTANCE,
   al_EXPONENT_DISTANCE_CLAMPED :: ALenum
al_NONE                             = 0
al_INVERSE_DISTANCE                 = 53249
al_INVERSE_DISTANCE_CLAMPED         = 53250
al_LINEAR_DISTANCE                  = 53251
al_LINEAR_DISTANCE_CLAMPED          = 53252
al_EXPONENT_DISTANCE                = 53253
al_EXPONENT_DISTANCE_CLAMPED        = 53254

--------------------------------------------------------------------------------

al_POSITION, al_VELOCITY, al_GAIN :: ALenum
al_POSITION                         = 4100
al_VELOCITY                         = 4102
al_GAIN                             = 4106

al_ORIENTATION :: ALenum
al_ORIENTATION                      = 4111

al_SOURCE_RELATIVE, al_SOURCE_TYPE, al_LOOPING, al_BUFFER, al_BUFFERS_QUEUED,
   al_BUFFERS_PROCESSED, al_MIN_GAIN, al_MAX_GAIN, al_REFERENCE_DISTANCE,
   al_ROLLOFF_FACTOR, al_MAX_DISTANCE, al_PITCH, al_DIRECTION,
   al_CONE_INNER_ANGLE, al_CONE_OUTER_ANGLE, al_CONE_OUTER_GAIN, al_SEC_OFFSET,
   al_SAMPLE_OFFSET, al_BYTE_OFFSET, al_SOURCE_STATE :: ALenum
al_SOURCE_RELATIVE                  = 514
al_SOURCE_TYPE                      = 4135
al_LOOPING                          = 4103
al_BUFFER                           = 4105
al_BUFFERS_QUEUED                   = 4117
al_BUFFERS_PROCESSED                = 4118
al_MIN_GAIN                         = 4109
al_MAX_GAIN                         = 4110
al_REFERENCE_DISTANCE               = 4128
al_ROLLOFF_FACTOR                   = 4129
al_MAX_DISTANCE                     = 4131
al_PITCH                            = 4099
al_DIRECTION                        = 4101
al_CONE_INNER_ANGLE                 = 4097
al_CONE_OUTER_ANGLE                 = 4098
al_CONE_OUTER_GAIN                  = 4130
al_SEC_OFFSET                       = 4132
al_SAMPLE_OFFSET                    = 4133
al_BYTE_OFFSET                      = 4134
al_SOURCE_STATE                     = 4112

al_UNDETERMINED, al_STATIC, al_STREAMING :: ALint
al_UNDETERMINED                     = 4144
al_STATIC                           = 4136
al_STREAMING                        = 4137

al_INITIAL, al_PLAYING, al_PAUSED, al_STOPPED :: ALint
al_INITIAL                          = 4113
al_PLAYING                          = 4114
al_PAUSED                           = 4115
al_STOPPED                          = 4116

--------------------------------------------------------------------------------

al_FREQUENCY, al_SIZE, al_BITS, al_CHANNELS :: ALenum
al_FREQUENCY                        = 8193
al_SIZE                             = 8196
al_BITS                             = 8194
al_CHANNELS                         = 8195

al_FORMAT_MONO8, al_FORMAT_MONO16, al_FORMAT_STEREO8,
   al_FORMAT_STEREO16 :: ALenum
al_FORMAT_MONO8                     = 4352
al_FORMAT_MONO16                    = 4353
al_FORMAT_STEREO8                   = 4354
al_FORMAT_STEREO16                  = 4355

--------------------------------------------------------------------------------

alc_FALSE, alc_TRUE :: ALCboolean
alc_FALSE                           = 0
alc_TRUE                            = 1

alc_FREQUENCY, alc_REFRESH, alc_SYNC, alc_MONO_SOURCES,
   alc_STEREO_SOURCES :: ALCint
alc_FREQUENCY                       = 4103
alc_REFRESH                         = 4104
alc_SYNC                            = 4105
alc_MONO_SOURCES                    = 4112
alc_STEREO_SOURCES                  = 4113

alc_NO_ERROR, alc_INVALID_DEVICE, alc_INVALID_CONTEXT, alc_INVALID_ENUM,
   alc_INVALID_VALUE, alc_INVALID_OPERATION, alc_OUT_OF_MEMORY :: ALCenum
alc_NO_ERROR                        = 0
alc_INVALID_DEVICE                  = 40961
alc_INVALID_CONTEXT                 = 40962
alc_INVALID_ENUM                    = 40963
alc_INVALID_VALUE                   = 40964
alc_INVALID_OPERATION               = 40966
alc_OUT_OF_MEMORY                   = 40965

alc_DEFAULT_DEVICE_SPECIFIER, alc_DEVICE_SPECIFIER, alc_EXTENSIONS,
   alc_CAPTURE_DEFAULT_DEVICE_SPECIFIER, alc_CAPTURE_DEVICE_SPECIFIER :: ALCenum
alc_DEFAULT_DEVICE_SPECIFIER        = 4100
alc_DEVICE_SPECIFIER                = 4101
alc_EXTENSIONS                      = 4102
alc_CAPTURE_DEFAULT_DEVICE_SPECIFIER= 785
alc_CAPTURE_DEVICE_SPECIFIER        = 784

alc_ATTRIBUTES_SIZE, alc_ALL_ATTRIBUTES, alc_MAJOR_VERSION, alc_MINOR_VERSION,
   alc_CAPTURE_SAMPLES :: ALCenum
alc_ATTRIBUTES_SIZE                 = 4098
alc_ALL_ATTRIBUTES                  = 4099
alc_MAJOR_VERSION                   = 4096
alc_MINOR_VERSION                   = 4097
alc_CAPTURE_SAMPLES                 = 786
