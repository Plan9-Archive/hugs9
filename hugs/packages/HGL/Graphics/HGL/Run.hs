-----------------------------------------------------------------------------
-- |
-- Module      :  Graphics.HGL.Run
-- Copyright   :  (c) Alastair Reid, 1999-2003
-- License     :  BSD-style (see the file libraries/base/LICENSE)
--
-- Maintainer  :  libraries@haskell.org
-- Stability   :  provisional
-- Portability :  non-portable (requires concurrency)
--
-- Running graphical actions.
--
-----------------------------------------------------------------------------

                                                                            
                                                                            

                                                           
                            

                                                         
                          

                                                         
                          

                                                         
                          

                                                          
                           

                                                         
                          

                                                           
                            

                                                            
                             

                                                         
                          

                                                                              


                                              


                                                          


                                                          


                                            


                                                        


                                                      
                         

                                                                      
                              



module Graphics.HGL.Run
	( runGraphics		-- :: IO () -> IO ()
	) where


import Graphics.HGL.X11.Display (getDisplayName)
import Graphics.HGL.X11.Window (runGraphicsEx)








----------------------------------------------------------------
-- Interface
----------------------------------------------------------------

-- | Initialize the system to do graphics, run an action while collecting
-- user interface events and forwarding them to the action, and then clean
-- up everything else at the end.
-- The other functions of the library may only be used inside 'runGraphics'.
runGraphics :: IO () -> IO ()  -- SOE, p48

----------------------------------------------------------------
-- Implementation
----------------------------------------------------------------



runGraphics m = do
  disp <- getDisplayName
  runGraphicsEx disp m




















