{-# OPTIONS_GHC -optc-D__HUGS__ #-}
{-# INCLUDE "HsXlib.h" #-}
{-# LINE 1 "Graphics/X11/Xlib/Types.hsc" #-}
{-# OPTIONS_GHC -fglasgow-exts #-}
{-# LINE 2 "Graphics/X11/Xlib/Types.hsc" #-}
-----------------------------------------------------------------------------
-- |
-- Module      :  Graphics.X11.Xlib.Types
-- Copyright   :  (c) Alastair Reid, 1999-2003
-- License     :  BSD-style (see the file libraries/base/LICENSE)
--
-- Maintainer  :  libraries@haskell.org
-- Stability   :  provisional
-- Portability :  portable
--
-- A collection of type declarations for interfacing with Xlib.
--
-----------------------------------------------------------------------------

-- #hide
module Graphics.X11.Xlib.Types(
	Display(..), Screen, Visual, GC, GCValues, SetWindowAttributes,
	Point(..), Rectangle(..), Arc(..), Segment(..), Color(..),
	Pixel, Position, Dimension, Angle, ScreenNumber, Buffer
        ) where

import Control.Monad( zipWithM_ )
import Data.Int
import Data.Word
import Foreign.C.Types
import Foreign.Marshal.Alloc( allocaBytes )
import Foreign.Ptr
import Foreign.Storable( Storable(..) )


{-# LINE 34 "Graphics/X11/Xlib/Types.hsc" #-}


{-# LINE 36 "Graphics/X11/Xlib/Types.hsc" #-}

----------------------------------------------------------------
-- Types
----------------------------------------------------------------

-- | pointer to an X11 @Display@ structure
newtype Display    = Display    (Ptr Display)

{-# LINE 46 "Graphics/X11/Xlib/Types.hsc" #-}
	deriving (Eq, Ord, Show)

{-# LINE 48 "Graphics/X11/Xlib/Types.hsc" #-}

-- | pointer to an X11 @Screen@ structure
newtype Screen     = Screen     (Ptr Screen)

{-# LINE 54 "Graphics/X11/Xlib/Types.hsc" #-}
	deriving (Eq, Ord, Show)

{-# LINE 56 "Graphics/X11/Xlib/Types.hsc" #-}

-- | pointer to an X11 @Visual@ structure
newtype Visual     = Visual     (Ptr Visual)

{-# LINE 62 "Graphics/X11/Xlib/Types.hsc" #-}
	deriving (Eq, Ord, Show)

{-# LINE 64 "Graphics/X11/Xlib/Types.hsc" #-}

-- | pointer to an X11 @GC@ structure
newtype GC         = GC         (Ptr GC)

{-# LINE 70 "Graphics/X11/Xlib/Types.hsc" #-}
	deriving (Eq, Ord, Show)

{-# LINE 72 "Graphics/X11/Xlib/Types.hsc" #-}

-- | pointer to an X11 @XGCValues@ structure
newtype GCValues   = GCValues  (Ptr GCValues)

{-# LINE 78 "Graphics/X11/Xlib/Types.hsc" #-}
	deriving (Eq, Ord, Show)

{-# LINE 80 "Graphics/X11/Xlib/Types.hsc" #-}

-- | pointer to an X11 @XSetWindowAttributes@ structure
newtype SetWindowAttributes = SetWindowAttributes (Ptr SetWindowAttributes)

{-# LINE 86 "Graphics/X11/Xlib/Types.hsc" #-}
	deriving (Eq, Ord, Show)

{-# LINE 88 "Graphics/X11/Xlib/Types.hsc" #-}

type Pixel         = Word64
{-# LINE 90 "Graphics/X11/Xlib/Types.hsc" #-}
type Position      = Int32
{-# LINE 91 "Graphics/X11/Xlib/Types.hsc" #-}
type Dimension     = Word32
{-# LINE 92 "Graphics/X11/Xlib/Types.hsc" #-}
type Angle         = Int
type ScreenNumber  = Word32
type Buffer        = Int

----------------------------------------------------------------
-- Short forms used in structs
----------------------------------------------------------------

type ShortPosition = CShort
type ShortDimension = CUShort
type ShortAngle    = CShort

peekPositionField :: Ptr a -> Int -> IO Position
peekPositionField ptr off = do
	v <- peekByteOff ptr off
	return (fromIntegral (v::ShortPosition))

peekDimensionField :: Ptr a -> Int -> IO Dimension
peekDimensionField ptr off = do
	v <- peekByteOff ptr off
	return (fromIntegral (v::ShortDimension))

peekAngleField :: Ptr a -> Int -> IO Angle
peekAngleField ptr off = do
	v <- peekByteOff ptr off
	return (fromIntegral (v::ShortAngle))

pokePositionField :: Ptr a -> Int -> Position -> IO ()
pokePositionField ptr off v =
	pokeByteOff ptr off (fromIntegral v::ShortPosition)

pokeDimensionField :: Ptr a -> Int -> Dimension -> IO ()
pokeDimensionField ptr off v =
	pokeByteOff ptr off (fromIntegral v::ShortDimension)

pokeAngleField :: Ptr a -> Int -> Angle -> IO ()
pokeAngleField ptr off v =
	pokeByteOff ptr off (fromIntegral v::ShortAngle)

----------------------------------------------------------------
-- Point
----------------------------------------------------------------

-- | counterpart of an X11 @XPoint@ structure
data Point = Point { pt_x :: Position, pt_y :: Position }

{-# LINE 140 "Graphics/X11/Xlib/Types.hsc" #-}
	deriving (Eq, Show)

{-# LINE 142 "Graphics/X11/Xlib/Types.hsc" #-}

instance Storable Point where
	sizeOf _ = (4)
{-# LINE 145 "Graphics/X11/Xlib/Types.hsc" #-}
	alignment _ = alignment (undefined::CInt)
	peek p = do
		x <- peekPositionField p (0)
{-# LINE 148 "Graphics/X11/Xlib/Types.hsc" #-}
		y <- peekPositionField p (2)
{-# LINE 149 "Graphics/X11/Xlib/Types.hsc" #-}
		return (Point x y)
	poke p (Point x y) = do
		pokePositionField p (0) x
{-# LINE 152 "Graphics/X11/Xlib/Types.hsc" #-}
		pokePositionField p (2) y
{-# LINE 153 "Graphics/X11/Xlib/Types.hsc" #-}

----------------------------------------------------------------
-- Rectangle
----------------------------------------------------------------

-- | counterpart of an X11 @XRectangle@ structure
data Rectangle = Rectangle {
	rect_x :: Position,
	rect_y :: Position,
	rect_width :: Dimension,
	rect_height :: Dimension
	}

{-# LINE 168 "Graphics/X11/Xlib/Types.hsc" #-}
	deriving (Eq, Show)

{-# LINE 170 "Graphics/X11/Xlib/Types.hsc" #-}

instance Storable Rectangle where
	sizeOf _ = (8)
{-# LINE 173 "Graphics/X11/Xlib/Types.hsc" #-}
	alignment _ = alignment (undefined::CInt)
	peek p = do
		x	<- peekPositionField p (0)
{-# LINE 176 "Graphics/X11/Xlib/Types.hsc" #-}
		y	<- peekPositionField p (2)
{-# LINE 177 "Graphics/X11/Xlib/Types.hsc" #-}
		width	<- peekDimensionField p (4)
{-# LINE 178 "Graphics/X11/Xlib/Types.hsc" #-}
		height	<- peekDimensionField p (6)
{-# LINE 179 "Graphics/X11/Xlib/Types.hsc" #-}
		return (Rectangle x y width height)
	poke p (Rectangle x y width height) = do
		pokePositionField p (0) x
{-# LINE 182 "Graphics/X11/Xlib/Types.hsc" #-}
		pokePositionField p (2) y
{-# LINE 183 "Graphics/X11/Xlib/Types.hsc" #-}
		pokeDimensionField p (4) width
{-# LINE 184 "Graphics/X11/Xlib/Types.hsc" #-}
		pokeDimensionField p (6) height
{-# LINE 185 "Graphics/X11/Xlib/Types.hsc" #-}

----------------------------------------------------------------
-- Arc
----------------------------------------------------------------

-- | counterpart of an X11 @XArc@ structure
data Arc = Arc {
	arc_x :: Position,
	arc_y :: Position,
	arc_width :: Dimension,
	arc_height :: Dimension,
	arc_angle1 :: Angle,
	arc_angle2 :: Angle
	}

{-# LINE 202 "Graphics/X11/Xlib/Types.hsc" #-}
	deriving (Eq, Show)

{-# LINE 204 "Graphics/X11/Xlib/Types.hsc" #-}

instance Storable Arc where
	sizeOf _ = (12)
{-# LINE 207 "Graphics/X11/Xlib/Types.hsc" #-}
	alignment _ = alignment (undefined::CInt)
	peek p = do
		x	<- peekPositionField p (0)
{-# LINE 210 "Graphics/X11/Xlib/Types.hsc" #-}
		y	<- peekPositionField p (2)
{-# LINE 211 "Graphics/X11/Xlib/Types.hsc" #-}
		width	<- peekDimensionField p (4)
{-# LINE 212 "Graphics/X11/Xlib/Types.hsc" #-}
		height	<- peekDimensionField p (6)
{-# LINE 213 "Graphics/X11/Xlib/Types.hsc" #-}
		angle1	<- peekAngleField p (8)
{-# LINE 214 "Graphics/X11/Xlib/Types.hsc" #-}
		angle2	<- peekAngleField p (10)
{-# LINE 215 "Graphics/X11/Xlib/Types.hsc" #-}
		return (Arc x y width height angle1 angle2)
	poke p (Arc x y width height angle1 angle2) = do
		pokePositionField p (0) x
{-# LINE 218 "Graphics/X11/Xlib/Types.hsc" #-}
		pokePositionField p (2) y
{-# LINE 219 "Graphics/X11/Xlib/Types.hsc" #-}
		pokeDimensionField p (4) width
{-# LINE 220 "Graphics/X11/Xlib/Types.hsc" #-}
		pokeDimensionField p (6) height
{-# LINE 221 "Graphics/X11/Xlib/Types.hsc" #-}
		pokeAngleField p (8) angle1
{-# LINE 222 "Graphics/X11/Xlib/Types.hsc" #-}
		pokeAngleField p (10) angle2
{-# LINE 223 "Graphics/X11/Xlib/Types.hsc" #-}

----------------------------------------------------------------
-- Segment
----------------------------------------------------------------

-- | counterpart of an X11 @XSegment@ structure
data Segment = Segment {
	seg_x1 :: Position,
	seg_y1 :: Position,
	seg_x2 :: Position,
	seg_y2 :: Position
	}

{-# LINE 238 "Graphics/X11/Xlib/Types.hsc" #-}
	deriving (Eq, Show)

{-# LINE 240 "Graphics/X11/Xlib/Types.hsc" #-}

instance Storable Segment where
	sizeOf _ = (8)
{-# LINE 243 "Graphics/X11/Xlib/Types.hsc" #-}
	alignment _ = alignment (undefined::CInt)
	peek p = do
		x1 <- peekPositionField p (0)
{-# LINE 246 "Graphics/X11/Xlib/Types.hsc" #-}
		y1 <- peekPositionField p (2)
{-# LINE 247 "Graphics/X11/Xlib/Types.hsc" #-}
		x2 <- peekPositionField p (4)
{-# LINE 248 "Graphics/X11/Xlib/Types.hsc" #-}
		y2 <- peekPositionField p (6)
{-# LINE 249 "Graphics/X11/Xlib/Types.hsc" #-}
		return (Segment x1 y1 x2 y2)
	poke p (Segment x1 y1 x2 y2) = do
		pokePositionField p (0) x1
{-# LINE 252 "Graphics/X11/Xlib/Types.hsc" #-}
		pokePositionField p (2) y1
{-# LINE 253 "Graphics/X11/Xlib/Types.hsc" #-}
		pokePositionField p (4) x2
{-# LINE 254 "Graphics/X11/Xlib/Types.hsc" #-}
		pokePositionField p (6) y2
{-# LINE 255 "Graphics/X11/Xlib/Types.hsc" #-}

----------------------------------------------------------------
-- Color
----------------------------------------------------------------

-- | counterpart of an X11 @XColor@ structure
data Color = Color {
	color_pixel :: Pixel,
	color_red :: Word16,
	color_green :: Word16,
	color_blue :: Word16,
	color_flags :: Word8
	}

{-# LINE 271 "Graphics/X11/Xlib/Types.hsc" #-}
	deriving (Eq, Show)

{-# LINE 273 "Graphics/X11/Xlib/Types.hsc" #-}

instance Storable Color where
	sizeOf _ = (16)
{-# LINE 276 "Graphics/X11/Xlib/Types.hsc" #-}
	alignment _ = alignment (undefined::CInt)
	peek p = do
		pixel	<- (\hsc_ptr -> peekByteOff hsc_ptr 0)	p
{-# LINE 279 "Graphics/X11/Xlib/Types.hsc" #-}
		red	<- (\hsc_ptr -> peekByteOff hsc_ptr 8)	p
{-# LINE 280 "Graphics/X11/Xlib/Types.hsc" #-}
		green	<- (\hsc_ptr -> peekByteOff hsc_ptr 10)	p
{-# LINE 281 "Graphics/X11/Xlib/Types.hsc" #-}
		blue	<- (\hsc_ptr -> peekByteOff hsc_ptr 12)	p
{-# LINE 282 "Graphics/X11/Xlib/Types.hsc" #-}
		flags	<- (\hsc_ptr -> peekByteOff hsc_ptr 14)	p
{-# LINE 283 "Graphics/X11/Xlib/Types.hsc" #-}
		return (Color pixel red green blue flags)
	poke p (Color pixel red green blue flags) = do
		(\hsc_ptr -> pokeByteOff hsc_ptr 0)	p pixel
{-# LINE 286 "Graphics/X11/Xlib/Types.hsc" #-}
		(\hsc_ptr -> pokeByteOff hsc_ptr 8)	p red
{-# LINE 287 "Graphics/X11/Xlib/Types.hsc" #-}
		(\hsc_ptr -> pokeByteOff hsc_ptr 10)	p green
{-# LINE 288 "Graphics/X11/Xlib/Types.hsc" #-}
		(\hsc_ptr -> pokeByteOff hsc_ptr 12)	p blue
{-# LINE 289 "Graphics/X11/Xlib/Types.hsc" #-}
		(\hsc_ptr -> pokeByteOff hsc_ptr 14)	p flags
{-# LINE 290 "Graphics/X11/Xlib/Types.hsc" #-}

----------------------------------------------------------------
-- End
----------------------------------------------------------------
