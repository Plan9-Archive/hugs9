{-# OPTIONS_GHC -optc-D__HUGS__ #-}
{-# INCLUDE "HsXlib.h" #-}
{-# LINE 1 "Graphics/X11/Xlib/Font.hsc" #-}
{-# OPTIONS_GHC -fglasgow-exts #-}
{-# LINE 2 "Graphics/X11/Xlib/Font.hsc" #-}
-----------------------------------------------------------------------------
-- |
-- Module      :  Graphics.X11.Xlib.Font
-- Copyright   :  (c) Alastair Reid, 1999-2003
-- License     :  BSD-style (see the file libraries/base/LICENSE)
--
-- Maintainer  :  libraries@haskell.org
-- Stability   :  provisional
-- Portability :  portable
--
-- A collection of FFI declarations for interfacing with Xlib Fonts.
--
-----------------------------------------------------------------------------

module Graphics.X11.Xlib.Font(

        Glyph,
        queryFont,
        fontFromGC,
        loadQueryFont,
        freeFont,
	FontStruct,
        fontFromFontStruct,
        ascentFromFontStruct,
        descentFromFontStruct,
        CharStruct,
        textExtents,
        textWidth,

        ) where


{-# LINE 34 "Graphics/X11/Xlib/Font.hsc" #-}

import Graphics.X11.Types
import Graphics.X11.Xlib.Types

import Foreign
import Foreign.C


{-# LINE 44 "Graphics/X11/Xlib/Font.hsc" #-}

----------------------------------------------------------------
-- Fonts
----------------------------------------------------------------

-- A glyph (or Char2b) is a 16 bit character identification.
-- The top 8 bits are zero in many fonts.
type Glyph = Word16

-- | pointer to an X11 @XFontStruct@ structure
newtype FontStruct = FontStruct (Ptr FontStruct)

{-# LINE 58 "Graphics/X11/Xlib/Font.hsc" #-}
	deriving (Eq, Ord, Show)

{-# LINE 60 "Graphics/X11/Xlib/Font.hsc" #-}

-- Disnae exist: %fun LoadFont       :: Display -> String -> IO Font
-- Disnae exist: %fun UnloadFont     :: Display -> Font -> IO ()

-- Argument can be a Font or a GContext.
-- But, if it's a GContext, the fontStruct will use the GContext as the
-- FontID - which will cause most things to break so it's probably
-- safer using XGetGCValues to get a genuine font ID

-- | interface to the X11 library function @XQueryFont()@.
foreign import ccall unsafe "HsXlib.h XQueryFont"
	queryFont     :: Display -> Font -> IO FontStruct

-- Note that this _WILL NOT WORK_ unless you have explicitly set the font.
-- I'm slowly but surely coming to the conclusion that Xlib is a pile of
-- steaming shit.

-- | interface to the X11 library function @XGetGCValues()@.
fontFromGC :: Display -> GC -> IO Font
fontFromGC display gc =
	allocaBytes (128) $ \ values -> do
{-# LINE 81 "Graphics/X11/Xlib/Font.hsc" #-}
	throwIfZero "fontFromGC" $
		xGetGCValues display gc 16384 values
{-# LINE 83 "Graphics/X11/Xlib/Font.hsc" #-}
	(\hsc_ptr -> peekByteOff hsc_ptr 88) values
{-# LINE 84 "Graphics/X11/Xlib/Font.hsc" #-}
foreign import ccall unsafe "HsXlib.h XGetGCValues"
	xGetGCValues :: Display -> GC -> ValueMask -> Ptr GCValues -> IO Int

type ValueMask = Word64
{-# LINE 88 "Graphics/X11/Xlib/Font.hsc" #-}

-- | interface to the X11 library function @XLoadQueryFont()@.
loadQueryFont :: Display -> String -> IO FontStruct
loadQueryFont display name =
	withCString name $ \ c_name -> do
	fs <- throwIfNull "loadQueryFont" $ xLoadQueryFont display c_name
	return (FontStruct fs)
foreign import ccall unsafe "HsXlib.h XLoadQueryFont"
	xLoadQueryFont :: Display -> CString -> IO (Ptr FontStruct)

-- | interface to the X11 library function @XFreeFont()@.
foreign import ccall unsafe "HsXlib.h XFreeFont"
	freeFont      :: Display -> FontStruct -> IO ()
-- %fun XSetFontPath  :: Display -> ListString  -> IO () using XSetFontPath(arg1,arg2,arg2_size)

fontFromFontStruct :: FontStruct -> Font
fontFromFontStruct (FontStruct fs) = unsafePerformIO $
	(\hsc_ptr -> peekByteOff hsc_ptr 8) fs
{-# LINE 106 "Graphics/X11/Xlib/Font.hsc" #-}

ascentFromFontStruct :: FontStruct -> Int32
ascentFromFontStruct (FontStruct fs) = unsafePerformIO $
	(\hsc_ptr -> peekByteOff hsc_ptr 88) fs
{-# LINE 110 "Graphics/X11/Xlib/Font.hsc" #-}

descentFromFontStruct :: FontStruct -> Int32
descentFromFontStruct (FontStruct fs) = unsafePerformIO $
	(\hsc_ptr -> peekByteOff hsc_ptr 92) fs
{-# LINE 114 "Graphics/X11/Xlib/Font.hsc" #-}

-- %prim XGetFontPath :: Display -> IO ListString
--Int r_size;
--String* r = XGetFontPath(arg1,&r_size);
-- %update(r);
--XFreeFontPath(r);
--return;

-- %prim XListFonts :: Display -> String -> Int -> IO ListString
--Int r_size;
--String *r = XListFonts(arg1,arg2,arg3,&r_size);
-- %update(r);
--XFreeFontNames(r);
--return;

-- XListFontsWithInfo omitted (no support for FontStruct yet)

-- XQueryTextExtents omitted (no support for CharStruct yet)
-- XQueryTextExtents16 omitted (no support for CharStruct yet)

-- We marshall this across right away because it's usually one-off info
type CharStruct =
	( Int            -- lbearing (origin to left edge of raster)
	, Int            -- rbearing (origin to right edge of raster)
	, Int            -- width    (advance to next char's origin)
	, Int            -- ascent   (baseline to top edge of raster)
	, Int            -- descent  (baseline to bottom edge of raster)
	-- attributes omitted
	)

peekCharStruct :: Ptr CharStruct -> IO CharStruct
peekCharStruct p = do
	lbearing <- (\hsc_ptr -> peekByteOff hsc_ptr 0) p
{-# LINE 147 "Graphics/X11/Xlib/Font.hsc" #-}
	rbearing <- (\hsc_ptr -> peekByteOff hsc_ptr 2) p
{-# LINE 148 "Graphics/X11/Xlib/Font.hsc" #-}
	width    <- (\hsc_ptr -> peekByteOff hsc_ptr 4) p
{-# LINE 149 "Graphics/X11/Xlib/Font.hsc" #-}
	ascent   <- (\hsc_ptr -> peekByteOff hsc_ptr 6) p
{-# LINE 150 "Graphics/X11/Xlib/Font.hsc" #-}
	descent  <- (\hsc_ptr -> peekByteOff hsc_ptr 8) p
{-# LINE 151 "Graphics/X11/Xlib/Font.hsc" #-}
	return (fromIntegral (lbearing::CShort),
		fromIntegral (rbearing::CShort),
		fromIntegral (width::CShort),
		fromIntegral (ascent::CShort),
		fromIntegral (descent::CShort))

-- No need to put this in the IO monad - this info is essentially constant

-- | interface to the X11 library function @XTextExtents()@.
textExtents :: FontStruct -> String -> (FontDirection, Int32, Int32, CharStruct)
textExtents font_struct string = unsafePerformIO $
	withCStringLen string $ \ (c_string, nchars) ->
	alloca $ \ direction_return ->
	alloca $ \ font_ascent_return ->
	alloca $ \ font_descent_return ->
	allocaBytes (12) $ \ overall_return -> do
{-# LINE 167 "Graphics/X11/Xlib/Font.hsc" #-}
	xTextExtents font_struct c_string nchars direction_return
		font_ascent_return font_descent_return overall_return
	direction <- peek direction_return
	ascent <- peek font_ascent_return
	descent <- peek font_descent_return
	cs <- peekCharStruct overall_return
	return (direction, ascent, descent, cs)
foreign import ccall unsafe "HsXlib.h XTextExtents"
	xTextExtents :: FontStruct -> CString -> Int ->
		Ptr FontDirection -> Ptr Int32 -> Ptr Int32 ->
		Ptr CharStruct -> IO Int

-- No need to put ths in the IO monad - this info is essentially constant

-- | interface to the X11 library function @XTextWidth()@.
textWidth :: FontStruct -> String -> Int32
textWidth font_struct string = unsafePerformIO $
	withCStringLen string $ \ (c_string, len) ->
	xTextWidth font_struct c_string len
foreign import ccall unsafe "HsXlib.h XTextWidth"
	xTextWidth :: FontStruct -> CString -> Int -> IO Int32

-- XTextExtents16 omitted
-- XTextWidth16 omitted

-- XGetFontProperty omitted
-- XFreeFontInfo omitted
-- XFreeFontNames omitted

-- XCreateFontSet omitted (no documentation available)
-- XFreeFontSet omitted (no documentation available)
-- XFontsOfFontSet omitted (no documentation available)
-- XBaseFontNameListOfFontSet omitted (no documentation available)
-- XLocaleOfFontSet omitted (no documentation available)
-- XExtentsOfFontSet omitted (no documentation available)

-- XContextDependentDrawing omitted
-- XDirectionalDependentDrawing omitted
-- XContextualDrawing omitted

-- XmbTextEscapement omitted
-- XwcTextEscapement omitted
-- XmbTextExtents omitted
-- XwcTextExtents omitted
-- XmbTextPerCharExtents omitted
-- XwcTextPerCharExtents omitted
-- XmbDrawText omitted
-- XwcDrawText omitted
-- XmbDrawString omitted
-- XwcDrawString omitted
-- XmbDrawImageString omitted
-- XwcDrawImageString omitted

-- XOpenIM omitted
-- XCloseIM omitted
-- XGetIMValues omitted
-- XSetIMValues omitted
-- DisplayOfIM omitted
-- XLocaleOfIM omitted

-- XCreateIC omitted
-- XDestroyIC omitted
-- XSetICFocus omitted
-- XUnsetICFocus omitted
-- XwcResetIC omitted
-- XmbResetIC omitted
-- XSetICValues omitted
-- XGetICValues omitted
-- XIMOfIC omitted

-- XRegisterIMInstantiateCallback omitted
-- XUnregisterIMInstantiateCallback omitted

-- XInternalConnectionNumbers omitted
-- XProcessInternalConnection omitted
-- XAddConnectionWatch omitted
-- XRemoveConnectionWatch omitted

-- XmbLookupString omitted
-- XwcLookupString omitted

----------------------------------------------------------------
-- End
----------------------------------------------------------------
