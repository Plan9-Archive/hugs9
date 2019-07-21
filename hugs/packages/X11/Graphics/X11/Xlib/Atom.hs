{-# OPTIONS_GHC -optc-D__HUGS__ #-}
{-# INCLUDE "HsXlib.h" #-}
{-# LINE 1 "Graphics/X11/Xlib/Atom.hsc" #-}
-----------------------------------------------------------------------------
{-# LINE 2 "Graphics/X11/Xlib/Atom.hsc" #-}
-- |
-- Module      :  Graphics.X11.Xlib.Atom
-- Copyright   :  (c) Alastair Reid, 1999-2003
-- License     :  BSD-style (see the file libraries/base/LICENSE)
--
-- Maintainer  :  libraries@haskell.org
-- Stability   :  provisional
-- Portability :  portable
--
-- A collection of type declarations for interfacing with X11 Atoms.
--
-----------------------------------------------------------------------------

module Graphics.X11.Xlib.Atom(
        internAtom,

        pRIMARY,
        sECONDARY,
        aRC,
        aTOM,
        bITMAP,
        cARDINAL,
        cOLORMAP,
        cURSOR,
        cUT_BUFFER0,
        cUT_BUFFER1,
        cUT_BUFFER2,
        cUT_BUFFER3,
        cUT_BUFFER4,
        cUT_BUFFER5,
        cUT_BUFFER6,
        cUT_BUFFER7,
        dRAWABLE,
        fONT,
        iNTEGER,
        pIXMAP,
        pOINT,
        rECTANGLE,
        rESOURCE_MANAGER,
        rGB_COLOR_MAP,
        rGB_BEST_MAP,
        rGB_BLUE_MAP,
        rGB_DEFAULT_MAP,
        rGB_GRAY_MAP,
        rGB_GREEN_MAP,
        rGB_RED_MAP,
        sTRING,
        vISUALID,
        wINDOW,
        wM_COMMAND,
        wM_HINTS,
        wM_CLIENT_MACHINE,
        wM_ICON_NAME,
        wM_ICON_SIZE,
        wM_NAME,
        wM_NORMAL_HINTS,
        wM_SIZE_HINTS,
        wM_ZOOM_HINTS,
        mIN_SPACE,
        nORM_SPACE,
        mAX_SPACE,
        eND_SPACE,
        sUPERSCRIPT_X,
        sUPERSCRIPT_Y,
        sUBSCRIPT_X,
        sUBSCRIPT_Y,
        uNDERLINE_POSITION,
        uNDERLINE_THICKNESS,
        sTRIKEOUT_ASCENT,
        sTRIKEOUT_DESCENT,
        iTALIC_ANGLE,
        x_HEIGHT,
        qUAD_WIDTH,
        wEIGHT,
        pOINT_SIZE,
        rESOLUTION,
        cOPYRIGHT,
        nOTICE,
        fONT_NAME,
        fAMILY_NAME,
        fULL_NAME,
        cAP_HEIGHT,
        wM_CLASS,
        wM_TRANSIENT_FOR,
        lAST_PREDEFINED,

        ) where

import Graphics.X11.Types
import Graphics.X11.Xlib.Types

import Foreign.C.String


{-# LINE 96 "Graphics/X11/Xlib/Atom.hsc" #-}

----------------------------------------------------------------
-- Atoms
----------------------------------------------------------------

-- AC, 1/9/2000: Added definition for XInternAtom

-- | interface to the X11 library function @XInternAtom()@.
internAtom :: Display -> String -> Bool -> IO Atom
internAtom display atom_name only_if_exists =
	withCString atom_name $ \ c_atom_name ->
	xInternAtom display c_atom_name only_if_exists
foreign import ccall unsafe "XInternAtom"
	xInternAtom :: Display -> CString -> Bool -> IO Atom

-- XInternAtoms omitted
-- XGetAtomName omitted
-- XGetAtomNames omitted
-- XConvertSelection omitted
-- XListProperties omitted
-- XChangeProperty omitted
-- XDeleteProperty omitted

pRIMARY 		 :: Atom
pRIMARY 		 =  1
sECONDARY 		 :: Atom
sECONDARY 		 =  2
aRC 			 :: Atom
aRC 			 =  3
aTOM 		 :: Atom
aTOM 		 =  4
bITMAP 		 :: Atom
bITMAP 		 =  5
cARDINAL 		 :: Atom
cARDINAL 		 =  6
cOLORMAP 		 :: Atom
cOLORMAP 		 =  7
cURSOR 		 :: Atom
cURSOR 		 =  8
cUT_BUFFER0 		 :: Atom
cUT_BUFFER0 		 =  9
cUT_BUFFER1 		 :: Atom
cUT_BUFFER1 		 =  10
cUT_BUFFER2 		 :: Atom
cUT_BUFFER2 		 =  11
cUT_BUFFER3 		 :: Atom
cUT_BUFFER3 		 =  12
cUT_BUFFER4 		 :: Atom
cUT_BUFFER4 		 =  13
cUT_BUFFER5 		 :: Atom
cUT_BUFFER5 		 =  14
cUT_BUFFER6 		 :: Atom
cUT_BUFFER6 		 =  15
cUT_BUFFER7 		 :: Atom
cUT_BUFFER7 		 =  16
dRAWABLE 		 :: Atom
dRAWABLE 		 =  17
fONT 		 :: Atom
fONT 		 =  18
iNTEGER 		 :: Atom
iNTEGER 		 =  19
pIXMAP 		 :: Atom
pIXMAP 		 =  20
pOINT 		 :: Atom
pOINT 		 =  21
rECTANGLE 		 :: Atom
rECTANGLE 		 =  22
rESOURCE_MANAGER 	 :: Atom
rESOURCE_MANAGER 	 =  23
rGB_COLOR_MAP 	 :: Atom
rGB_COLOR_MAP 	 =  24
rGB_BEST_MAP 	 :: Atom
rGB_BEST_MAP 	 =  25
rGB_BLUE_MAP 	 :: Atom
rGB_BLUE_MAP 	 =  26
rGB_DEFAULT_MAP 	 :: Atom
rGB_DEFAULT_MAP 	 =  27
rGB_GRAY_MAP 	 :: Atom
rGB_GRAY_MAP 	 =  28
rGB_GREEN_MAP 	 :: Atom
rGB_GREEN_MAP 	 =  29
rGB_RED_MAP 		 :: Atom
rGB_RED_MAP 		 =  30
sTRING 		 :: Atom
sTRING 		 =  31
vISUALID 		 :: Atom
vISUALID 		 =  32
wINDOW 		 :: Atom
wINDOW 		 =  33
wM_COMMAND 		 :: Atom
wM_COMMAND 		 =  34
wM_HINTS 		 :: Atom
wM_HINTS 		 =  35
wM_CLIENT_MACHINE 	 :: Atom
wM_CLIENT_MACHINE 	 =  36
wM_ICON_NAME 	 :: Atom
wM_ICON_NAME 	 =  37
wM_ICON_SIZE 	 :: Atom
wM_ICON_SIZE 	 =  38
wM_NAME 		 :: Atom
wM_NAME 		 =  39
wM_NORMAL_HINTS 	 :: Atom
wM_NORMAL_HINTS 	 =  40
wM_SIZE_HINTS 	 :: Atom
wM_SIZE_HINTS 	 =  41
wM_ZOOM_HINTS 	 :: Atom
wM_ZOOM_HINTS 	 =  42
mIN_SPACE 		 :: Atom
mIN_SPACE 		 =  43
nORM_SPACE 		 :: Atom
nORM_SPACE 		 =  44
mAX_SPACE 		 :: Atom
mAX_SPACE 		 =  45
eND_SPACE 		 :: Atom
eND_SPACE 		 =  46
sUPERSCRIPT_X 	 :: Atom
sUPERSCRIPT_X 	 =  47
sUPERSCRIPT_Y 	 :: Atom
sUPERSCRIPT_Y 	 =  48
sUBSCRIPT_X 		 :: Atom
sUBSCRIPT_X 		 =  49
sUBSCRIPT_Y 		 :: Atom
sUBSCRIPT_Y 		 =  50
uNDERLINE_POSITION 	 :: Atom
uNDERLINE_POSITION 	 =  51
uNDERLINE_THICKNESS 	 :: Atom
uNDERLINE_THICKNESS 	 =  52
sTRIKEOUT_ASCENT 	 :: Atom
sTRIKEOUT_ASCENT 	 =  53
sTRIKEOUT_DESCENT 	 :: Atom
sTRIKEOUT_DESCENT 	 =  54
iTALIC_ANGLE 	 :: Atom
iTALIC_ANGLE 	 =  55
x_HEIGHT 		 :: Atom
x_HEIGHT 		 =  56
qUAD_WIDTH 		 :: Atom
qUAD_WIDTH 		 =  57
wEIGHT 		 :: Atom
wEIGHT 		 =  58
pOINT_SIZE 		 :: Atom
pOINT_SIZE 		 =  59
rESOLUTION 		 :: Atom
rESOLUTION 		 =  60
cOPYRIGHT 		 :: Atom
cOPYRIGHT 		 =  61
nOTICE 		 :: Atom
nOTICE 		 =  62
fONT_NAME 		 :: Atom
fONT_NAME 		 =  63
fAMILY_NAME 		 :: Atom
fAMILY_NAME 		 =  64
fULL_NAME 		 :: Atom
fULL_NAME 		 =  65
cAP_HEIGHT 		 :: Atom
cAP_HEIGHT 		 =  66
wM_CLASS 		 :: Atom
wM_CLASS 		 =  67
wM_TRANSIENT_FOR 	 :: Atom
wM_TRANSIENT_FOR 	 =  68
lAST_PREDEFINED 	 :: Atom
lAST_PREDEFINED 	 =  68

{-# LINE 190 "Graphics/X11/Xlib/Atom.hsc" #-}

----------------------------------------------------------------
-- End
----------------------------------------------------------------
