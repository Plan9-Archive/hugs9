{-# OPTIONS_GHC -optc-D__HUGS__ #-}
{-# INCLUDE "HsXlib.h" #-}
{-# LINE 1 "Graphics/X11/Types.hsc" #-}
-----------------------------------------------------------------------------
{-# LINE 2 "Graphics/X11/Types.hsc" #-}
-- |
-- Module      :  Graphics.X11.Types
-- Copyright   :  (c) Alastair Reid, 1999-2003
-- License     :  BSD-style (see the file libraries/base/LICENSE)
--
-- Maintainer  :  libraries@haskell.org
-- Stability   :  provisional
-- Portability :  portable
--
-- A collection of type declarations for interfacing with X11.
--
-----------------------------------------------------------------------------

module Graphics.X11.Types
	(

	XID,
	Mask,
	Atom,
	VisualID,
	Time,
	Window,
	Drawable,
	Font,
	Pixmap,
	Cursor,
	Colormap,
	GContext,
	KeyCode,

	-- * Enumeration types
	-- | These types were introduced to make function types clearer.
	-- Note that the types are synonyms for 'Int', so no extra
	-- typesafety was obtained.

	-- ** Key symbols
	KeySym,

	xK_VoidSymbol,
	xK_BackSpace,
	xK_Tab,
	xK_Linefeed,
	xK_Clear,
	xK_Return,
	xK_Pause,
	xK_Scroll_Lock,
	xK_Sys_Req,
	xK_Escape,
	xK_Delete,
	xK_Multi_key,
	xK_Home,
	xK_Left,
	xK_Up,
	xK_Right,
	xK_Down,
	xK_Prior,
	xK_Page_Up,
	xK_Next,
	xK_Page_Down,
	xK_End,
	xK_Begin,
	xK_Select,
	xK_Print,
	xK_Execute,
	xK_Insert,
	xK_Undo,
	xK_Redo,
	xK_Menu,
	xK_Find,
	xK_Cancel,
	xK_Help,
	xK_Break,
	xK_Mode_switch,
	xK_script_switch,
	xK_Num_Lock,
	xK_KP_Space,
	xK_KP_Tab,
	xK_KP_Enter,
	xK_KP_F1,
	xK_KP_F2,
	xK_KP_F3,
	xK_KP_F4,
	xK_KP_Home,
	xK_KP_Left,
	xK_KP_Up,
	xK_KP_Right,
	xK_KP_Down,
	xK_KP_Prior,
	xK_KP_Page_Up,
	xK_KP_Next,
	xK_KP_Page_Down,
	xK_KP_End,
	xK_KP_Begin,
	xK_KP_Insert,
	xK_KP_Delete,
	xK_KP_Equal,
	xK_KP_Multiply,
	xK_KP_Add,
	xK_KP_Separator,
	xK_KP_Subtract,
	xK_KP_Decimal,
	xK_KP_Divide,
	xK_KP_0,
	xK_KP_1,
	xK_KP_2,
	xK_KP_3,
	xK_KP_4,
	xK_KP_5,
	xK_KP_6,
	xK_KP_7,
	xK_KP_8,
	xK_KP_9,
	xK_F1,
	xK_F2,
	xK_F3,
	xK_F4,
	xK_F5,
	xK_F6,
	xK_F7,
	xK_F8,
	xK_F9,
	xK_F10,
	xK_F11,
	xK_L1,
	xK_F12,
	xK_L2,
	xK_F13,
	xK_L3,
	xK_F14,
	xK_L4,
	xK_F15,
	xK_L5,
	xK_F16,
	xK_L6,
	xK_F17,
	xK_L7,
	xK_F18,
	xK_L8,
	xK_F19,
	xK_L9,
	xK_F20,
	xK_L10,
	xK_F21,
	xK_R1,
	xK_F22,
	xK_R2,
	xK_F23,
	xK_R3,
	xK_F24,
	xK_R4,
	xK_F25,
	xK_R5,
	xK_F26,
	xK_R6,
	xK_F27,
	xK_R7,
	xK_F28,
	xK_R8,
	xK_F29,
	xK_R9,
	xK_F30,
	xK_R10,
	xK_F31,
	xK_R11,
	xK_F32,
	xK_R12,
	xK_F33,
	xK_R13,
	xK_F34,
	xK_R14,
	xK_F35,
	xK_R15,
	xK_Shift_L,
	xK_Shift_R,
	xK_Control_L,
	xK_Control_R,
	xK_Caps_Lock,
	xK_Shift_Lock,
	xK_Meta_L,
	xK_Meta_R,
	xK_Alt_L,
	xK_Alt_R,
	xK_Super_L,
	xK_Super_R,
	xK_Hyper_L,
	xK_Hyper_R,
	xK_space,
	xK_exclam,
	xK_quotedbl,
	xK_numbersign,
	xK_dollar,
	xK_percent,
	xK_ampersand,
	xK_apostrophe,
	xK_quoteright,
	xK_parenleft,
	xK_parenright,
	xK_asterisk,
	xK_plus,
	xK_comma,
	xK_minus,
	xK_period,
	xK_slash,
	xK_0,
	xK_1,
	xK_2,
	xK_3,
	xK_4,
	xK_5,
	xK_6,
	xK_7,
	xK_8,
	xK_9,
	xK_colon,
	xK_semicolon,
	xK_less,
	xK_equal,
	xK_greater,
	xK_question,
	xK_at,
	xK_A,
	xK_B,
	xK_C,
	xK_D,
	xK_E,
	xK_F,
	xK_G,
	xK_H,
	xK_I,
	xK_J,
	xK_K,
	xK_L,
	xK_M,
	xK_N,
	xK_O,
	xK_P,
	xK_Q,
	xK_R,
	xK_S,
	xK_T,
	xK_U,
	xK_V,
	xK_W,
	xK_X,
	xK_Y,
	xK_Z,
	xK_bracketleft,
	xK_backslash,
	xK_bracketright,
	xK_asciicircum,
	xK_underscore,
	xK_grave,
	xK_quoteleft,
	xK_a,
	xK_b,
	xK_c,
	xK_d,
	xK_e,
	xK_f,
	xK_g,
	xK_h,
	xK_i,
	xK_j,
	xK_k,
	xK_l,
	xK_m,
	xK_n,
	xK_o,
	xK_p,
	xK_q,
	xK_r,
	xK_s,
	xK_t,
	xK_u,
	xK_v,
	xK_w,
	xK_x,
	xK_y,
	xK_z,
	xK_braceleft,
	xK_bar,
	xK_braceright,
	xK_asciitilde,
	xK_nobreakspace,
	xK_exclamdown,
	xK_cent,
	xK_sterling,
	xK_currency,
	xK_yen,
	xK_brokenbar,
	xK_section,
	xK_diaeresis,
	xK_copyright,
	xK_ordfeminine,
	xK_guillemotleft,
	xK_notsign,
	xK_hyphen,
	xK_registered,
	xK_macron,
	xK_degree,
	xK_plusminus,
	xK_twosuperior,
	xK_threesuperior,
	xK_acute,
	xK_mu,
	xK_paragraph,
	xK_periodcentered,
	xK_cedilla,
	xK_onesuperior,
	xK_masculine,
	xK_guillemotright,
	xK_onequarter,
	xK_onehalf,
	xK_threequarters,
	xK_questiondown,
	xK_Agrave,
	xK_Aacute,
	xK_Acircumflex,
	xK_Atilde,
	xK_Adiaeresis,
	xK_Aring,
	xK_AE,
	xK_Ccedilla,
	xK_Egrave,
	xK_Eacute,
	xK_Ecircumflex,
	xK_Ediaeresis,
	xK_Igrave,
	xK_Iacute,
	xK_Icircumflex,
	xK_Idiaeresis,
	xK_ETH,
	xK_Eth,
	xK_Ntilde,
	xK_Ograve,
	xK_Oacute,
	xK_Ocircumflex,
	xK_Otilde,
	xK_Odiaeresis,
	xK_multiply,
	xK_Ooblique,
	xK_Ugrave,
	xK_Uacute,
	xK_Ucircumflex,
	xK_Udiaeresis,
	xK_Yacute,
	xK_THORN,
	xK_Thorn,
	xK_ssharp,
	xK_agrave,
	xK_aacute,
	xK_acircumflex,
	xK_atilde,
	xK_adiaeresis,
	xK_aring,
	xK_ae,
	xK_ccedilla,
	xK_egrave,
	xK_eacute,
	xK_ecircumflex,
	xK_ediaeresis,
	xK_igrave,
	xK_iacute,
	xK_icircumflex,
	xK_idiaeresis,
	xK_eth,
	xK_ntilde,
	xK_ograve,
	xK_oacute,
	xK_ocircumflex,
	xK_otilde,
	xK_odiaeresis,
	xK_division,
	xK_oslash,
	xK_ugrave,
	xK_uacute,
	xK_ucircumflex,
	xK_udiaeresis,
	xK_yacute,
	xK_thorn,
	xK_ydiaeresis,

	-- ** Event masks
	EventMask,
	noEventMask,
	keyPressMask,
	keyReleaseMask,
	buttonPressMask,
	buttonReleaseMask,
	enterWindowMask,
	leaveWindowMask,
	pointerMotionMask,
	pointerMotionHintMask,
	button1MotionMask,
	button2MotionMask,
	button3MotionMask,
	button4MotionMask,
	button5MotionMask,
	buttonMotionMask,
	keymapStateMask,
	exposureMask,
	visibilityChangeMask,
	structureNotifyMask,
	resizeRedirectMask,
	substructureNotifyMask,
	substructureRedirectMask,
	focusChangeMask,
	propertyChangeMask,
	colormapChangeMask,
	ownerGrabButtonMask,

	-- ** Event types
	EventType,
	keyPress,
	keyRelease,
	buttonPress,
	buttonRelease,
	motionNotify,
	enterNotify,
	leaveNotify,
	focusIn,
	focusOut,
	keymapNotify,
	expose,
	graphicsExpose,
	noExpose,
	visibilityNotify,
	createNotify,
	destroyNotify,
	unmapNotify,
	mapNotify,
	mapRequest,
	reparentNotify,
	configureNotify,
	configureRequest,
	gravityNotify,
	resizeRequest,
	circulateNotify,
	circulateRequest,
	propertyNotify,
	selectionClear,
	selectionRequest,
	selectionNotify,
	colormapNotify,
	clientMessage,
	mappingNotify,
	lASTEvent,

	-- ** Modifiers
	Modifier,
	shiftMapIndex,
	lockMapIndex,
	controlMapIndex,
	mod1MapIndex,
	mod2MapIndex,
	mod3MapIndex,
	mod4MapIndex,
	mod5MapIndex,
	anyModifier,

	-- ** Key masks
	KeyMask,
	shiftMask,
	lockMask,
	controlMask,
	mod1Mask,
	mod2Mask,
	mod3Mask,
	mod4Mask,
	mod5Mask,

	-- ** Button masks
	ButtonMask,
	button1Mask,
	button2Mask,
	button3Mask,
	button4Mask,
	button5Mask,

	-- ** Buttons
	Button,
	button1,
	button2,
	button3,
	button4,
	button5,

	-- ** Notify modes
	NotifyMode,
	notifyNormal,
	notifyGrab,
	notifyUngrab,
	notifyWhileGrabbed,
	notifyHint,

	-- ** Notify details
	NotifyDetail,
	notifyAncestor,
	notifyVirtual,
	notifyInferior,
	notifyNonlinear,
	notifyNonlinearVirtual,
	notifyPointer,
	notifyPointerRoot,
	notifyDetailNone,

	-- ** Visibility
	Visibility,
	visibilityUnobscured,
	visibilityPartiallyObscured,
	visibilityFullyObscured,

	-- ** Place of window
	Place,
	placeOnTop,
	placeOnBottom,

	-- ** Protocols
	Protocol,
	familyInternet,
	familyDECnet,
	familyChaos,

	-- ** Property notification
	PropertyNotification,
	propertyNewValue,
	propertyDelete,

	-- ** Colormap notification
	ColormapNotification,
	colormapUninstalled,
	colormapInstalled,

	-- ** Grab modes
	GrabMode,
	grabModeSync,
	grabModeAsync,

	-- ** Grab status
	GrabStatus,
	grabSuccess,
	alreadyGrabbed,
	grabInvalidTime,
	grabNotViewable,
	grabFrozen,

	-- ** Allow events
	AllowEvents,
	asyncPointer,
	syncPointer,
	replayPointer,
	asyncKeyboard,
	syncKeyboard,
	replayKeyboard,
	asyncBoth,
	syncBoth,

	-- ** Focus modes
	FocusMode,
	revertToNone,
	revertToPointerRoot,
	revertToParent,

	-- ** Error codes
	ErrorCode,
	success,
	badRequest,
	badValue,
	badWindow,
	badPixmap,
	badAtom,
	badCursor,
	badFont,
	badMatch,
	badDrawable,
	badAccess,
	badAlloc,
	badColor,
	badGC,
	badIDChoice,
	badName,
	badLength,
	badImplementation,
	firstExtensionError,
	lastExtensionError,

	-- ** Return status
	Status,
	throwIfZero,

	-- ** WindowClass
	WindowClass,
	copyFromParent,
	inputOutput,
	inputOnly,

	-- ** Attribute masks
	AttributeMask,
	cWBackPixmap,
	cWBackPixel,
	cWBorderPixmap,
	cWBorderPixel,
	cWBitGravity,
	cWWinGravity,
	cWBackingStore,
	cWBackingPlanes,
	cWBackingPixel,
	cWOverrideRedirect,
	cWSaveUnder,
	cWEventMask,
	cWDontPropagate,
	cWColormap,
	cWCursor,

	-- ** Close down modes
	CloseDownMode,
	destroyAll,
	retainPermanent,
	retainTemporary,

	-- ** QueryBestSize classes
	QueryBestSizeClass,
	cursorShape,
	tileShape,
	stippleShape,

	-- ** Graphics functions
	GXFunction,
	gXclear,
	gXand,
	gXandReverse,
	gXcopy,
	gXandInverted,
	gXnoop,
	gXxor,
	gXor,
	gXnor,
	gXequiv,
	gXinvert,
	gXorReverse,
	gXcopyInverted,
	gXorInverted,
	gXnand,
	gXset,

	-- ** Line styles
	LineStyle,
	lineSolid,
	lineOnOffDash,
	lineDoubleDash,

	-- ** Cap styles
	CapStyle,
	capNotLast,
	capButt,
	capRound,
	capProjecting,

	-- ** Join styles
	JoinStyle,
	joinMiter,
	joinRound,
	joinBevel,

	-- ** Fill styles
	FillStyle,
	fillSolid,
	fillTiled,
	fillStippled,
	fillOpaqueStippled,

	-- ** Fill rules
	FillRule,
	evenOddRule,
	windingRule,

	-- ** Subwindow modes
	SubWindowMode,
	clipByChildren,
	includeInferiors,

	-- ** Coordinate modes
	CoordinateMode,
	coordModeOrigin,
	coordModePrevious,

	-- ** Polygon shapes
	PolygonShape,
	complex,
	nonconvex,
	convex,

	-- ** Arc modes
	ArcMode,
	arcChord,
	arcPieSlice,

	-- ** GC masks
	GCMask,
	gCFunction,
	gCPlaneMask,
	gCForeground,
	gCBackground,
	gCLineWidth,
	gCLineStyle,
	gCCapStyle,
	gCJoinStyle,
	gCFillStyle,
	gCFillRule,
	gCTile,
	gCStipple,
	gCTileStipXOrigin,
	gCTileStipYOrigin,
	gCFont,
	gCSubwindowMode,
	gCGraphicsExposures,
	gCClipXOrigin,
	gCClipYOrigin,
	gCClipMask,
	gCDashOffset,
	gCDashList,
	gCArcMode,
	gCLastBit,

	-- ** Circulation direction
	CirculationDirection,
	raiseLowest,
	lowerHighest,

	-- ** Byte order
	ByteOrder,
	lSBFirst,
	mSBFirst,

	-- ** ColormapAlloc
	ColormapAlloc,
	allocNone,
	allocAll,

	-- ** Mapping requests
	MappingRequest,
	mappingModifier,
	mappingKeyboard,
	mappingPointer,

	-- ** ChangeSaveSetMode
	ChangeSaveSetMode,
	setModeInsert,
	setModeDelete,

	-- ** Bit gravity
	BitGravity,
	forgetGravity,
	northWestGravity,
	northGravity,
	northEastGravity,
	westGravity,
	centerGravity,
	eastGravity,
	southWestGravity,
	southGravity,
	southEastGravity,
	staticGravity,

	-- ** Window gravity
	WindowGravity,
	unmapGravity,

	-- ** Backing store
	BackingStore,
	notUseful,
	whenMapped,
	always,
	doRed,
	doGreen,
	doBlue,

	-- ** Font direction
	FontDirection,
	fontLeftToRight,
	fontRightToLeft,

	) where

import Data.Int
import Data.Word
import Foreign.Marshal.Error


{-# LINE 791 "Graphics/X11/Types.hsc" #-}

-- ToDo: use newtype
type XID      = Word64
{-# LINE 794 "Graphics/X11/Types.hsc" #-}
type Mask     = Word64
{-# LINE 795 "Graphics/X11/Types.hsc" #-}
type Atom     = Word64
{-# LINE 796 "Graphics/X11/Types.hsc" #-}
type VisualID = Word64
{-# LINE 797 "Graphics/X11/Types.hsc" #-}
type Time     = Word64
{-# LINE 798 "Graphics/X11/Types.hsc" #-}

-- end platform dependency

type Window   = XID
type Drawable = XID
type Font     = XID
type Pixmap   = XID
type Cursor   = XID
type Colormap = XID
type GContext = XID

type KeyCode  = Char

type KeySym   = XID

xK_VoidSymbol	 :: KeySym
xK_VoidSymbol	 =  16777215

{-# LINE 816 "Graphics/X11/Types.hsc" #-}

-- TTY Functions, cleverly chosen to map to ascii, for convenience of
-- programming, but could have been arbitrary (at the cost of lookup
-- tables in client code.

xK_BackSpace		 :: KeySym
xK_BackSpace		 =  65288
xK_Tab		 :: KeySym
xK_Tab		 =  65289
xK_Linefeed		 :: KeySym
xK_Linefeed		 =  65290
xK_Clear		 :: KeySym
xK_Clear		 =  65291
xK_Return		 :: KeySym
xK_Return		 =  65293
xK_Pause		 :: KeySym
xK_Pause		 =  65299
xK_Scroll_Lock	 :: KeySym
xK_Scroll_Lock	 =  65300
xK_Sys_Req		 :: KeySym
xK_Sys_Req		 =  65301
xK_Escape		 :: KeySym
xK_Escape		 =  65307
xK_Delete		 :: KeySym
xK_Delete		 =  65535

{-# LINE 833 "Graphics/X11/Types.hsc" #-}

-- International & multi-key character composition
xK_Multi_key		 :: KeySym
xK_Multi_key		 =  65312

{-# LINE 838 "Graphics/X11/Types.hsc" #-}
-- xK_Codeinput		= XK_Codeinput		-- Not defined for SunOS.
-- xK_SingleCandidate	= XK_SingleCandidate	-- Not defined for SunOS.
-- xK_MultipleCandidate	= XK_MultipleCandidate	-- Not defined for SunOS.
-- xK_PreviousCandidate	= XK_PreviousCandidate	-- Not defined for SunOS.

-- Cursor control & motion
xK_Home		 :: KeySym
xK_Home		 =  65360
xK_Left		 :: KeySym
xK_Left		 =  65361
xK_Up		 :: KeySym
xK_Up		 =  65362
xK_Right		 :: KeySym
xK_Right		 =  65363
xK_Down		 :: KeySym
xK_Down		 =  65364
xK_Prior		 :: KeySym
xK_Prior		 =  65365
xK_Page_Up		 :: KeySym
xK_Page_Up		 =  65365
xK_Next		 :: KeySym
xK_Next		 =  65366
xK_Page_Down		 :: KeySym
xK_Page_Down		 =  65366
xK_End		 :: KeySym
xK_End		 =  65367
xK_Begin		 :: KeySym
xK_Begin		 =  65368
xK_Select		 :: KeySym
xK_Select		 =  65376
xK_Print		 :: KeySym
xK_Print		 =  65377
xK_Execute		 :: KeySym
xK_Execute		 =  65378
xK_Insert		 :: KeySym
xK_Insert		 =  65379
xK_Undo		 :: KeySym
xK_Undo		 =  65381
xK_Redo		 :: KeySym
xK_Redo		 =  65382
xK_Menu		 :: KeySym
xK_Menu		 =  65383
xK_Find		 :: KeySym
xK_Find		 =  65384
xK_Cancel		 :: KeySym
xK_Cancel		 =  65385
xK_Help		 :: KeySym
xK_Help		 =  65386
xK_Break		 :: KeySym
xK_Break		 =  65387
xK_Mode_switch	 :: KeySym
xK_Mode_switch	 =  65406
xK_script_switch	 :: KeySym
xK_script_switch	 =  65406
xK_Num_Lock		 :: KeySym
xK_Num_Lock		 =  65407

{-# LINE 872 "Graphics/X11/Types.hsc" #-}

-- Keypad Functions, keypad numbers cleverly chosen to map to ascii
xK_KP_Space		 :: KeySym
xK_KP_Space		 =  65408
xK_KP_Tab		 :: KeySym
xK_KP_Tab		 =  65417
xK_KP_Enter		 :: KeySym
xK_KP_Enter		 =  65421
xK_KP_F1		 :: KeySym
xK_KP_F1		 =  65425
xK_KP_F2		 :: KeySym
xK_KP_F2		 =  65426
xK_KP_F3		 :: KeySym
xK_KP_F3		 =  65427
xK_KP_F4		 :: KeySym
xK_KP_F4		 =  65428
xK_KP_Home		 :: KeySym
xK_KP_Home		 =  65429
xK_KP_Left		 :: KeySym
xK_KP_Left		 =  65430
xK_KP_Up		 :: KeySym
xK_KP_Up		 =  65431
xK_KP_Right		 :: KeySym
xK_KP_Right		 =  65432
xK_KP_Down		 :: KeySym
xK_KP_Down		 =  65433
xK_KP_Prior		 :: KeySym
xK_KP_Prior		 =  65434
xK_KP_Page_Up	 :: KeySym
xK_KP_Page_Up	 =  65434
xK_KP_Next		 :: KeySym
xK_KP_Next		 =  65435
xK_KP_Page_Down	 :: KeySym
xK_KP_Page_Down	 =  65435
xK_KP_End		 :: KeySym
xK_KP_End		 =  65436
xK_KP_Begin		 :: KeySym
xK_KP_Begin		 =  65437
xK_KP_Insert		 :: KeySym
xK_KP_Insert		 =  65438
xK_KP_Delete		 :: KeySym
xK_KP_Delete		 =  65439
xK_KP_Equal		 :: KeySym
xK_KP_Equal		 =  65469
xK_KP_Multiply	 :: KeySym
xK_KP_Multiply	 =  65450
xK_KP_Add		 :: KeySym
xK_KP_Add		 =  65451
xK_KP_Separator	 :: KeySym
xK_KP_Separator	 =  65452
xK_KP_Subtract	 :: KeySym
xK_KP_Subtract	 =  65453
xK_KP_Decimal	 :: KeySym
xK_KP_Decimal	 =  65454
xK_KP_Divide		 :: KeySym
xK_KP_Divide		 =  65455
xK_KP_0		 :: KeySym
xK_KP_0		 =  65456
xK_KP_1		 :: KeySym
xK_KP_1		 =  65457
xK_KP_2		 :: KeySym
xK_KP_2		 =  65458
xK_KP_3		 :: KeySym
xK_KP_3		 =  65459
xK_KP_4		 :: KeySym
xK_KP_4		 =  65460
xK_KP_5		 :: KeySym
xK_KP_5		 =  65461
xK_KP_6		 :: KeySym
xK_KP_6		 =  65462
xK_KP_7		 :: KeySym
xK_KP_7		 =  65463
xK_KP_8		 :: KeySym
xK_KP_8		 =  65464
xK_KP_9		 :: KeySym
xK_KP_9		 =  65465
xK_F1		 :: KeySym
xK_F1		 =  65470
xK_F2		 :: KeySym
xK_F2		 =  65471
xK_F3		 :: KeySym
xK_F3		 =  65472
xK_F4		 :: KeySym
xK_F4		 =  65473
xK_F5		 :: KeySym
xK_F5		 =  65474
xK_F6		 :: KeySym
xK_F6		 =  65475
xK_F7		 :: KeySym
xK_F7		 =  65476
xK_F8		 :: KeySym
xK_F8		 =  65477
xK_F9		 :: KeySym
xK_F9		 =  65478
xK_F10		 :: KeySym
xK_F10		 =  65479
xK_F11		 :: KeySym
xK_F11		 =  65480
xK_L1		 :: KeySym
xK_L1		 =  65480
xK_F12		 :: KeySym
xK_F12		 =  65481
xK_L2		 :: KeySym
xK_L2		 =  65481
xK_F13		 :: KeySym
xK_F13		 =  65482
xK_L3		 :: KeySym
xK_L3		 =  65482
xK_F14		 :: KeySym
xK_F14		 =  65483
xK_L4		 :: KeySym
xK_L4		 =  65483
xK_F15		 :: KeySym
xK_F15		 =  65484
xK_L5		 :: KeySym
xK_L5		 =  65484
xK_F16		 :: KeySym
xK_F16		 =  65485
xK_L6		 :: KeySym
xK_L6		 =  65485
xK_F17		 :: KeySym
xK_F17		 =  65486
xK_L7		 :: KeySym
xK_L7		 =  65486
xK_F18		 :: KeySym
xK_F18		 =  65487
xK_L8		 :: KeySym
xK_L8		 =  65487
xK_F19		 :: KeySym
xK_F19		 =  65488
xK_L9		 :: KeySym
xK_L9		 =  65488
xK_F20		 :: KeySym
xK_F20		 =  65489
xK_L10		 :: KeySym
xK_L10		 =  65489
xK_F21		 :: KeySym
xK_F21		 =  65490
xK_R1		 :: KeySym
xK_R1		 =  65490
xK_F22		 :: KeySym
xK_F22		 =  65491
xK_R2		 :: KeySym
xK_R2		 =  65491
xK_F23		 :: KeySym
xK_F23		 =  65492
xK_R3		 :: KeySym
xK_R3		 =  65492
xK_F24		 :: KeySym
xK_F24		 =  65493
xK_R4		 :: KeySym
xK_R4		 =  65493
xK_F25		 :: KeySym
xK_F25		 =  65494
xK_R5		 :: KeySym
xK_R5		 =  65494
xK_F26		 :: KeySym
xK_F26		 =  65495
xK_R6		 :: KeySym
xK_R6		 =  65495
xK_F27		 :: KeySym
xK_F27		 =  65496
xK_R7		 :: KeySym
xK_R7		 =  65496
xK_F28		 :: KeySym
xK_F28		 =  65497
xK_R8		 :: KeySym
xK_R8		 =  65497
xK_F29		 :: KeySym
xK_F29		 =  65498
xK_R9		 :: KeySym
xK_R9		 =  65498
xK_F30		 :: KeySym
xK_F30		 =  65499
xK_R10		 :: KeySym
xK_R10		 =  65499
xK_F31		 :: KeySym
xK_F31		 =  65500
xK_R11		 :: KeySym
xK_R11		 =  65500
xK_F32		 :: KeySym
xK_F32		 =  65501
xK_R12		 :: KeySym
xK_R12		 =  65501
xK_F33		 :: KeySym
xK_F33		 =  65502
xK_R13		 :: KeySym
xK_R13		 =  65502
xK_F34		 :: KeySym
xK_F34		 =  65503
xK_R14		 :: KeySym
xK_R14		 =  65503
xK_F35		 :: KeySym
xK_F35		 =  65504
xK_R15		 :: KeySym
xK_R15		 =  65504

{-# LINE 975 "Graphics/X11/Types.hsc" #-}

xK_Shift_L		 :: KeySym
xK_Shift_L		 =  65505
xK_Shift_R		 :: KeySym
xK_Shift_R		 =  65506
xK_Control_L		 :: KeySym
xK_Control_L		 =  65507
xK_Control_R		 :: KeySym
xK_Control_R		 =  65508
xK_Caps_Lock		 :: KeySym
xK_Caps_Lock		 =  65509
xK_Shift_Lock	 :: KeySym
xK_Shift_Lock	 =  65510
xK_Meta_L		 :: KeySym
xK_Meta_L		 =  65511
xK_Meta_R		 :: KeySym
xK_Meta_R		 =  65512
xK_Alt_L		 :: KeySym
xK_Alt_L		 =  65513
xK_Alt_R		 :: KeySym
xK_Alt_R		 =  65514
xK_Super_L		 :: KeySym
xK_Super_L		 =  65515
xK_Super_R		 :: KeySym
xK_Super_R		 =  65516
xK_Hyper_L		 :: KeySym
xK_Hyper_L		 =  65517
xK_Hyper_R		 :: KeySym
xK_Hyper_R		 =  65518

{-# LINE 993 "Graphics/X11/Types.hsc" #-}

xK_space		 :: KeySym
xK_space		 =  32
xK_exclam		 :: KeySym
xK_exclam		 =  33
xK_quotedbl		 :: KeySym
xK_quotedbl		 =  34
xK_numbersign	 :: KeySym
xK_numbersign	 =  35
xK_dollar		 :: KeySym
xK_dollar		 =  36
xK_percent		 :: KeySym
xK_percent		 =  37
xK_ampersand		 :: KeySym
xK_ampersand		 =  38
xK_apostrophe	 :: KeySym
xK_apostrophe	 =  39
xK_quoteright	 :: KeySym
xK_quoteright	 =  39
xK_parenleft		 :: KeySym
xK_parenleft		 =  40
xK_parenright	 :: KeySym
xK_parenright	 =  41
xK_asterisk		 :: KeySym
xK_asterisk		 =  42
xK_plus		 :: KeySym
xK_plus		 =  43
xK_comma		 :: KeySym
xK_comma		 =  44
xK_minus		 :: KeySym
xK_minus		 =  45
xK_period		 :: KeySym
xK_period		 =  46
xK_slash		 :: KeySym
xK_slash		 =  47
xK_0			 :: KeySym
xK_0			 =  48
xK_1			 :: KeySym
xK_1			 =  49
xK_2			 :: KeySym
xK_2			 =  50
xK_3			 :: KeySym
xK_3			 =  51
xK_4			 :: KeySym
xK_4			 =  52
xK_5			 :: KeySym
xK_5			 =  53
xK_6			 :: KeySym
xK_6			 =  54
xK_7			 :: KeySym
xK_7			 =  55
xK_8			 :: KeySym
xK_8			 =  56
xK_9			 :: KeySym
xK_9			 =  57
xK_colon		 :: KeySym
xK_colon		 =  58
xK_semicolon		 :: KeySym
xK_semicolon		 =  59
xK_less		 :: KeySym
xK_less		 =  60
xK_equal		 :: KeySym
xK_equal		 =  61
xK_greater		 :: KeySym
xK_greater		 =  62
xK_question		 :: KeySym
xK_question		 =  63
xK_at		 :: KeySym
xK_at		 =  64
xK_A			 :: KeySym
xK_A			 =  65
xK_B			 :: KeySym
xK_B			 =  66
xK_C			 :: KeySym
xK_C			 =  67
xK_D			 :: KeySym
xK_D			 =  68
xK_E			 :: KeySym
xK_E			 =  69
xK_F			 :: KeySym
xK_F			 =  70
xK_G			 :: KeySym
xK_G			 =  71
xK_H			 :: KeySym
xK_H			 =  72
xK_I			 :: KeySym
xK_I			 =  73
xK_J			 :: KeySym
xK_J			 =  74
xK_K			 :: KeySym
xK_K			 =  75
xK_L			 :: KeySym
xK_L			 =  76
xK_M			 :: KeySym
xK_M			 =  77
xK_N			 :: KeySym
xK_N			 =  78
xK_O			 :: KeySym
xK_O			 =  79
xK_P			 :: KeySym
xK_P			 =  80
xK_Q			 :: KeySym
xK_Q			 =  81
xK_R			 :: KeySym
xK_R			 =  82
xK_S			 :: KeySym
xK_S			 =  83
xK_T			 :: KeySym
xK_T			 =  84
xK_U			 :: KeySym
xK_U			 =  85
xK_V			 :: KeySym
xK_V			 =  86
xK_W			 :: KeySym
xK_W			 =  87
xK_X			 :: KeySym
xK_X			 =  88
xK_Y			 :: KeySym
xK_Y			 =  89
xK_Z			 :: KeySym
xK_Z			 =  90
xK_bracketleft	 :: KeySym
xK_bracketleft	 =  91
xK_backslash		 :: KeySym
xK_backslash		 =  92
xK_bracketright	 :: KeySym
xK_bracketright	 =  93
xK_asciicircum	 :: KeySym
xK_asciicircum	 =  94
xK_underscore	 :: KeySym
xK_underscore	 =  95
xK_grave		 :: KeySym
xK_grave		 =  96
xK_quoteleft		 :: KeySym
xK_quoteleft		 =  96
xK_a			 :: KeySym
xK_a			 =  97
xK_b			 :: KeySym
xK_b			 =  98
xK_c			 :: KeySym
xK_c			 =  99
xK_d			 :: KeySym
xK_d			 =  100
xK_e			 :: KeySym
xK_e			 =  101
xK_f			 :: KeySym
xK_f			 =  102
xK_g			 :: KeySym
xK_g			 =  103
xK_h			 :: KeySym
xK_h			 =  104
xK_i			 :: KeySym
xK_i			 =  105
xK_j			 :: KeySym
xK_j			 =  106
xK_k			 :: KeySym
xK_k			 =  107
xK_l			 :: KeySym
xK_l			 =  108
xK_m			 :: KeySym
xK_m			 =  109
xK_n			 :: KeySym
xK_n			 =  110
xK_o			 :: KeySym
xK_o			 =  111
xK_p			 :: KeySym
xK_p			 =  112
xK_q			 :: KeySym
xK_q			 =  113
xK_r			 :: KeySym
xK_r			 =  114
xK_s			 :: KeySym
xK_s			 =  115
xK_t			 :: KeySym
xK_t			 =  116
xK_u			 :: KeySym
xK_u			 =  117
xK_v			 :: KeySym
xK_v			 =  118
xK_w			 :: KeySym
xK_w			 =  119
xK_x			 :: KeySym
xK_x			 =  120
xK_y			 :: KeySym
xK_y			 =  121
xK_z			 :: KeySym
xK_z			 =  122
xK_braceleft		 :: KeySym
xK_braceleft		 =  123
xK_bar		 :: KeySym
xK_bar		 =  124
xK_braceright	 :: KeySym
xK_braceright	 =  125
xK_asciitilde	 :: KeySym
xK_asciitilde	 =  126

{-# LINE 1093 "Graphics/X11/Types.hsc" #-}

xK_nobreakspace	 :: KeySym
xK_nobreakspace	 =  160
xK_exclamdown	 :: KeySym
xK_exclamdown	 =  161
xK_cent		 :: KeySym
xK_cent		 =  162
xK_sterling		 :: KeySym
xK_sterling		 =  163
xK_currency		 :: KeySym
xK_currency		 =  164
xK_yen		 :: KeySym
xK_yen		 =  165
xK_brokenbar		 :: KeySym
xK_brokenbar		 =  166
xK_section		 :: KeySym
xK_section		 =  167
xK_diaeresis		 :: KeySym
xK_diaeresis		 =  168
xK_copyright		 :: KeySym
xK_copyright		 =  169
xK_ordfeminine	 :: KeySym
xK_ordfeminine	 =  170
xK_guillemotleft	 :: KeySym
xK_guillemotleft	 =  171
xK_notsign		 :: KeySym
xK_notsign		 =  172
xK_hyphen		 :: KeySym
xK_hyphen		 =  173
xK_registered	 :: KeySym
xK_registered	 =  174
xK_macron		 :: KeySym
xK_macron		 =  175
xK_degree		 :: KeySym
xK_degree		 =  176
xK_plusminus		 :: KeySym
xK_plusminus		 =  177
xK_twosuperior	 :: KeySym
xK_twosuperior	 =  178
xK_threesuperior	 :: KeySym
xK_threesuperior	 =  179
xK_acute		 :: KeySym
xK_acute		 =  180
xK_mu		 :: KeySym
xK_mu		 =  181
xK_paragraph		 :: KeySym
xK_paragraph		 =  182
xK_periodcentered	 :: KeySym
xK_periodcentered	 =  183
xK_cedilla		 :: KeySym
xK_cedilla		 =  184
xK_onesuperior	 :: KeySym
xK_onesuperior	 =  185
xK_masculine		 :: KeySym
xK_masculine		 =  186
xK_guillemotright	 :: KeySym
xK_guillemotright	 =  187
xK_onequarter	 :: KeySym
xK_onequarter	 =  188
xK_onehalf		 :: KeySym
xK_onehalf		 =  189
xK_threequarters	 :: KeySym
xK_threequarters	 =  190
xK_questiondown	 :: KeySym
xK_questiondown	 =  191
xK_Agrave		 :: KeySym
xK_Agrave		 =  192
xK_Aacute		 :: KeySym
xK_Aacute		 =  193
xK_Acircumflex	 :: KeySym
xK_Acircumflex	 =  194
xK_Atilde		 :: KeySym
xK_Atilde		 =  195
xK_Adiaeresis	 :: KeySym
xK_Adiaeresis	 =  196
xK_Aring		 :: KeySym
xK_Aring		 =  197
xK_AE		 :: KeySym
xK_AE		 =  198
xK_Ccedilla		 :: KeySym
xK_Ccedilla		 =  199
xK_Egrave		 :: KeySym
xK_Egrave		 =  200
xK_Eacute		 :: KeySym
xK_Eacute		 =  201
xK_Ecircumflex	 :: KeySym
xK_Ecircumflex	 =  202
xK_Ediaeresis	 :: KeySym
xK_Ediaeresis	 =  203
xK_Igrave		 :: KeySym
xK_Igrave		 =  204
xK_Iacute		 :: KeySym
xK_Iacute		 =  205
xK_Icircumflex	 :: KeySym
xK_Icircumflex	 =  206
xK_Idiaeresis	 :: KeySym
xK_Idiaeresis	 =  207
xK_ETH		 :: KeySym
xK_ETH		 =  208
xK_Eth		 :: KeySym
xK_Eth		 =  208
xK_Ntilde		 :: KeySym
xK_Ntilde		 =  209
xK_Ograve		 :: KeySym
xK_Ograve		 =  210
xK_Oacute		 :: KeySym
xK_Oacute		 =  211
xK_Ocircumflex	 :: KeySym
xK_Ocircumflex	 =  212
xK_Otilde		 :: KeySym
xK_Otilde		 =  213
xK_Odiaeresis	 :: KeySym
xK_Odiaeresis	 =  214
xK_multiply		 :: KeySym
xK_multiply		 =  215
xK_Ooblique		 :: KeySym
xK_Ooblique		 =  216
xK_Ugrave		 :: KeySym
xK_Ugrave		 =  217
xK_Uacute		 :: KeySym
xK_Uacute		 =  218
xK_Ucircumflex	 :: KeySym
xK_Ucircumflex	 =  219
xK_Udiaeresis	 :: KeySym
xK_Udiaeresis	 =  220
xK_Yacute		 :: KeySym
xK_Yacute		 =  221
xK_THORN		 :: KeySym
xK_THORN		 =  222
xK_Thorn		 :: KeySym
xK_Thorn		 =  222
xK_ssharp		 :: KeySym
xK_ssharp		 =  223
xK_agrave		 :: KeySym
xK_agrave		 =  224
xK_aacute		 :: KeySym
xK_aacute		 =  225
xK_acircumflex	 :: KeySym
xK_acircumflex	 =  226
xK_atilde		 :: KeySym
xK_atilde		 =  227
xK_adiaeresis	 :: KeySym
xK_adiaeresis	 =  228
xK_aring		 :: KeySym
xK_aring		 =  229
xK_ae		 :: KeySym
xK_ae		 =  230
xK_ccedilla		 :: KeySym
xK_ccedilla		 =  231
xK_egrave		 :: KeySym
xK_egrave		 =  232
xK_eacute		 :: KeySym
xK_eacute		 =  233
xK_ecircumflex	 :: KeySym
xK_ecircumflex	 =  234
xK_ediaeresis	 :: KeySym
xK_ediaeresis	 =  235
xK_igrave		 :: KeySym
xK_igrave		 =  236
xK_iacute		 :: KeySym
xK_iacute		 =  237
xK_icircumflex	 :: KeySym
xK_icircumflex	 =  238
xK_idiaeresis	 :: KeySym
xK_idiaeresis	 =  239
xK_eth		 :: KeySym
xK_eth		 =  240
xK_ntilde		 :: KeySym
xK_ntilde		 =  241
xK_ograve		 :: KeySym
xK_ograve		 =  242
xK_oacute		 :: KeySym
xK_oacute		 =  243
xK_ocircumflex	 :: KeySym
xK_ocircumflex	 =  244
xK_otilde		 :: KeySym
xK_otilde		 =  245
xK_odiaeresis	 :: KeySym
xK_odiaeresis	 =  246
xK_division		 :: KeySym
xK_division		 =  247
xK_oslash		 :: KeySym
xK_oslash		 =  248
xK_ugrave		 :: KeySym
xK_ugrave		 =  249
xK_uacute		 :: KeySym
xK_uacute		 =  250
xK_ucircumflex	 :: KeySym
xK_ucircumflex	 =  251
xK_udiaeresis	 :: KeySym
xK_udiaeresis	 =  252
xK_yacute		 :: KeySym
xK_yacute		 =  253
xK_thorn		 :: KeySym
xK_thorn		 =  254
xK_ydiaeresis	 :: KeySym
xK_ydiaeresis	 =  255

{-# LINE 1194 "Graphics/X11/Types.hsc" #-}

type EventMask			= Mask
noEventMask			 :: EventMask
noEventMask			 =  0
keyPressMask			 :: EventMask
keyPressMask			 =  1
keyReleaseMask		 :: EventMask
keyReleaseMask		 =  2
buttonPressMask		 :: EventMask
buttonPressMask		 =  4
buttonReleaseMask		 :: EventMask
buttonReleaseMask		 =  8
enterWindowMask		 :: EventMask
enterWindowMask		 =  16
leaveWindowMask		 :: EventMask
leaveWindowMask		 =  32
pointerMotionMask		 :: EventMask
pointerMotionMask		 =  64
pointerMotionHintMask	 :: EventMask
pointerMotionHintMask	 =  128
button1MotionMask		 :: EventMask
button1MotionMask		 =  256
button2MotionMask		 :: EventMask
button2MotionMask		 =  512
button3MotionMask		 :: EventMask
button3MotionMask		 =  1024
button4MotionMask		 :: EventMask
button4MotionMask		 =  2048
button5MotionMask		 :: EventMask
button5MotionMask		 =  4096
buttonMotionMask		 :: EventMask
buttonMotionMask		 =  8192
keymapStateMask		 :: EventMask
keymapStateMask		 =  16384
exposureMask			 :: EventMask
exposureMask			 =  32768
visibilityChangeMask		 :: EventMask
visibilityChangeMask		 =  65536
structureNotifyMask		 :: EventMask
structureNotifyMask		 =  131072
resizeRedirectMask		 :: EventMask
resizeRedirectMask		 =  262144
substructureNotifyMask	 :: EventMask
substructureNotifyMask	 =  524288
substructureRedirectMask	 :: EventMask
substructureRedirectMask	 =  1048576
focusChangeMask		 :: EventMask
focusChangeMask		 =  2097152
propertyChangeMask		 :: EventMask
propertyChangeMask		 =  4194304
colormapChangeMask		 :: EventMask
colormapChangeMask		 =  8388608
ownerGrabButtonMask		 :: EventMask
ownerGrabButtonMask		 =  16777216

{-# LINE 1224 "Graphics/X11/Types.hsc" #-}

type EventType		= Word32
keyPress		 :: EventType
keyPress		 =  2
keyRelease		 :: EventType
keyRelease		 =  3
buttonPress		 :: EventType
buttonPress		 =  4
buttonRelease	 :: EventType
buttonRelease	 =  5
motionNotify		 :: EventType
motionNotify		 =  6
enterNotify		 :: EventType
enterNotify		 =  7
leaveNotify		 :: EventType
leaveNotify		 =  8
focusIn		 :: EventType
focusIn		 =  9
focusOut		 :: EventType
focusOut		 =  10
keymapNotify		 :: EventType
keymapNotify		 =  11
expose		 :: EventType
expose		 =  12
graphicsExpose	 :: EventType
graphicsExpose	 =  13
noExpose		 :: EventType
noExpose		 =  14
visibilityNotify	 :: EventType
visibilityNotify	 =  15
createNotify		 :: EventType
createNotify		 =  16
destroyNotify	 :: EventType
destroyNotify	 =  17
unmapNotify		 :: EventType
unmapNotify		 =  18
mapNotify		 :: EventType
mapNotify		 =  19
mapRequest		 :: EventType
mapRequest		 =  20
reparentNotify	 :: EventType
reparentNotify	 =  21
configureNotify	 :: EventType
configureNotify	 =  22
configureRequest	 :: EventType
configureRequest	 =  23
gravityNotify	 :: EventType
gravityNotify	 =  24
resizeRequest	 :: EventType
resizeRequest	 =  25
circulateNotify	 :: EventType
circulateNotify	 =  26
circulateRequest	 :: EventType
circulateRequest	 =  27
propertyNotify	 :: EventType
propertyNotify	 =  28
selectionClear	 :: EventType
selectionClear	 =  29
selectionRequest	 :: EventType
selectionRequest	 =  30
selectionNotify	 :: EventType
selectionNotify	 =  31
colormapNotify	 :: EventType
colormapNotify	 =  32
clientMessage	 :: EventType
clientMessage	 =  33
mappingNotify	 :: EventType
mappingNotify	 =  34
lASTEvent		 :: EventType
lASTEvent		 =  36

{-# LINE 1262 "Graphics/X11/Types.hsc" #-}

type Modifier		= Mask
shiftMapIndex	 :: Modifier
shiftMapIndex	 =  0
lockMapIndex		 :: Modifier
lockMapIndex		 =  1
controlMapIndex	 :: Modifier
controlMapIndex	 =  2
mod1MapIndex		 :: Modifier
mod1MapIndex		 =  3
mod2MapIndex		 :: Modifier
mod2MapIndex		 =  4
mod3MapIndex		 :: Modifier
mod3MapIndex		 =  5
mod4MapIndex		 :: Modifier
mod4MapIndex		 =  6
mod5MapIndex		 :: Modifier
mod5MapIndex		 =  7
anyModifier		 :: Modifier
anyModifier		 =  32768

{-# LINE 1275 "Graphics/X11/Types.hsc" #-}

type KeyMask		= Modifier
shiftMask		 :: KeyMask
shiftMask		 =  1
lockMask		 :: KeyMask
lockMask		 =  2
controlMask		 :: KeyMask
controlMask		 =  4
mod1Mask		 :: KeyMask
mod1Mask		 =  8
mod2Mask		 :: KeyMask
mod2Mask		 =  16
mod3Mask		 :: KeyMask
mod3Mask		 =  32
mod4Mask		 :: KeyMask
mod4Mask		 =  64
mod5Mask		 :: KeyMask
mod5Mask		 =  128

{-# LINE 1287 "Graphics/X11/Types.hsc" #-}

type ButtonMask		= Modifier
button1Mask		 :: ButtonMask
button1Mask		 =  256
button2Mask		 :: ButtonMask
button2Mask		 =  512
button3Mask		 :: ButtonMask
button3Mask		 =  1024
button4Mask		 :: ButtonMask
button4Mask		 =  2048
button5Mask		 :: ButtonMask
button5Mask		 =  4096

{-# LINE 1296 "Graphics/X11/Types.hsc" #-}

type Button		= Word32
button1		 :: Button
button1		 =  1
button2		 :: Button
button2		 =  2
button3		 :: Button
button3		 =  3
button4		 :: Button
button4		 =  4
button5		 :: Button
button5		 =  5

{-# LINE 1305 "Graphics/X11/Types.hsc" #-}

type NotifyMode		= Int
-- NotifyNormal and NotifyHint are used as detail in XMotionEvents
notifyNormal		 :: NotifyMode
notifyNormal		 =  0
notifyGrab		 :: NotifyMode
notifyGrab		 =  1
notifyUngrab		 :: NotifyMode
notifyUngrab		 =  2
notifyWhileGrabbed	 :: NotifyMode
notifyWhileGrabbed	 =  3
notifyHint		 :: NotifyMode
notifyHint		 =  1

{-# LINE 1315 "Graphics/X11/Types.hsc" #-}

type NotifyDetail	= Int
notifyAncestor	 :: NotifyDetail
notifyAncestor	 =  0
notifyVirtual	 :: NotifyDetail
notifyVirtual	 =  1
notifyInferior	 :: NotifyDetail
notifyInferior	 =  2
notifyNonlinear	 :: NotifyDetail
notifyNonlinear	 =  3
notifyNonlinearVirtual  :: NotifyDetail
notifyNonlinearVirtual  =  4
notifyPointer	 :: NotifyDetail
notifyPointer	 =  5
notifyPointerRoot	 :: NotifyDetail
notifyPointerRoot	 =  6
notifyDetailNone	 :: NotifyDetail
notifyDetailNone	 =  7

{-# LINE 1327 "Graphics/X11/Types.hsc" #-}

type Visibility = Int
visibilityUnobscured		 :: Visibility
visibilityUnobscured		 =  0
visibilityPartiallyObscured	 :: Visibility
visibilityPartiallyObscured	 =  1
visibilityFullyObscured	 :: Visibility
visibilityFullyObscured	 =  2

{-# LINE 1334 "Graphics/X11/Types.hsc" #-}

-- | Place of window relative to siblings
-- (used in Circulation requests or events)
type Place = Int
placeOnTop		 :: Place
placeOnTop		 =  0
placeOnBottom	 :: Place
placeOnBottom	 =  1

{-# LINE 1342 "Graphics/X11/Types.hsc" #-}

type Protocol		= Int
familyInternet	 :: Protocol
familyInternet	 =  0
familyDECnet		 :: Protocol
familyDECnet		 =  1
familyChaos		 :: Protocol
familyChaos		 =  2

{-# LINE 1349 "Graphics/X11/Types.hsc" #-}

type PropertyNotification = Int
propertyNewValue	 :: PropertyNotification
propertyNewValue	 =  0
propertyDelete	 :: PropertyNotification
propertyDelete	 =  1

{-# LINE 1355 "Graphics/X11/Types.hsc" #-}

type ColormapNotification = Int
colormapUninstalled	 :: ColormapNotification
colormapUninstalled	 =  0
colormapInstalled	 :: ColormapNotification
colormapInstalled	 =  1

{-# LINE 1361 "Graphics/X11/Types.hsc" #-}

-- Grab{Pointer,Button,Keyboard,Key} Modes
type GrabMode		= Int
grabModeSync		 :: GrabMode
grabModeSync		 =  0
grabModeAsync	 :: GrabMode
grabModeAsync	 =  1

{-# LINE 1368 "Graphics/X11/Types.hsc" #-}

-- Grab{Pointer,Keyboard} reply status

type GrabStatus		= Int
grabSuccess		 :: GrabStatus
grabSuccess		 =  0
alreadyGrabbed	 :: GrabStatus
alreadyGrabbed	 =  1
grabInvalidTime	 :: GrabStatus
grabInvalidTime	 =  2
grabNotViewable	 :: GrabStatus
grabNotViewable	 =  3
grabFrozen		 :: GrabStatus
grabFrozen		 =  4

{-# LINE 1379 "Graphics/X11/Types.hsc" #-}

-- AllowEvents modes
type AllowEvents	= Int
asyncPointer		 :: AllowEvents
asyncPointer		 =  0
syncPointer		 :: AllowEvents
syncPointer		 =  1
replayPointer	 :: AllowEvents
replayPointer	 =  2
asyncKeyboard	 :: AllowEvents
asyncKeyboard	 =  3
syncKeyboard		 :: AllowEvents
syncKeyboard		 =  4
replayKeyboard	 :: AllowEvents
replayKeyboard	 =  5
asyncBoth		 :: AllowEvents
asyncBoth		 =  6
syncBoth		 :: AllowEvents
syncBoth		 =  7

{-# LINE 1392 "Graphics/X11/Types.hsc" #-}

-- {Set,Get}InputFocus Modes
type FocusMode		= Int
revertToNone		 :: FocusMode
revertToNone		 =  0
revertToPointerRoot	 :: FocusMode
revertToPointerRoot	 =  1
revertToParent	 :: FocusMode
revertToParent	 =  2

{-# LINE 1400 "Graphics/X11/Types.hsc" #-}

-- Error codes
type ErrorCode		= Int
success		 :: ErrorCode
success		 =  0
badRequest		 :: ErrorCode
badRequest		 =  1
badValue		 :: ErrorCode
badValue		 =  2
badWindow		 :: ErrorCode
badWindow		 =  3
badPixmap		 :: ErrorCode
badPixmap		 =  4
badAtom		 :: ErrorCode
badAtom		 =  5
badCursor		 :: ErrorCode
badCursor		 =  6
badFont		 :: ErrorCode
badFont		 =  7
badMatch		 :: ErrorCode
badMatch		 =  8
badDrawable		 :: ErrorCode
badDrawable		 =  9
badAccess		 :: ErrorCode
badAccess		 =  10
badAlloc		 :: ErrorCode
badAlloc		 =  11
badColor		 :: ErrorCode
badColor		 =  12
badGC		 :: ErrorCode
badGC		 =  13
badIDChoice		 :: ErrorCode
badIDChoice		 =  14
badName		 :: ErrorCode
badName		 =  15
badLength		 :: ErrorCode
badLength		 =  16
badImplementation	 :: ErrorCode
badImplementation	 =  17
firstExtensionError	 :: ErrorCode
firstExtensionError	 =  128
lastExtensionError	 :: ErrorCode
lastExtensionError	 =  255

{-# LINE 1425 "Graphics/X11/Types.hsc" #-}

type Status		= Int

-- |Xlib functions with return values of type @Status@ return zero on
-- failure and nonzero on success.
throwIfZero :: String -> IO Status -> IO ()
throwIfZero fn_name = throwIf_ (== 0) (const ("Error in function " ++ fn_name))

type WindowClass	= Int
copyFromParent	 :: WindowClass
copyFromParent	 =  0
inputOutput		 :: WindowClass
inputOutput		 =  1
inputOnly		 :: WindowClass
inputOnly		 =  2

{-# LINE 1439 "Graphics/X11/Types.hsc" #-}

-- Window attributes mask
type AttributeMask	= Mask
cWBackPixmap		 :: AttributeMask
cWBackPixmap		 =  1
cWBackPixel		 :: AttributeMask
cWBackPixel		 =  2
cWBorderPixmap	 :: AttributeMask
cWBorderPixmap	 =  4
cWBorderPixel	 :: AttributeMask
cWBorderPixel	 =  8
cWBitGravity		 :: AttributeMask
cWBitGravity		 =  16
cWWinGravity		 :: AttributeMask
cWWinGravity		 =  32
cWBackingStore	 :: AttributeMask
cWBackingStore	 =  64
cWBackingPlanes	 :: AttributeMask
cWBackingPlanes	 =  128
cWBackingPixel	 :: AttributeMask
cWBackingPixel	 =  256
cWOverrideRedirect	 :: AttributeMask
cWOverrideRedirect	 =  512
cWSaveUnder		 :: AttributeMask
cWSaveUnder		 =  1024
cWEventMask		 :: AttributeMask
cWEventMask		 =  2048
cWDontPropagate	 :: AttributeMask
cWDontPropagate	 =  4096
cWColormap		 :: AttributeMask
cWColormap		 =  8192
cWCursor		 :: AttributeMask
cWCursor		 =  16384

{-# LINE 1459 "Graphics/X11/Types.hsc" #-}

-- Used in ChangeCloseDownMode
type CloseDownMode	= Int
destroyAll		 :: CloseDownMode
destroyAll		 =  0
retainPermanent	 :: CloseDownMode
retainPermanent	 =  1
retainTemporary	 :: CloseDownMode
retainTemporary	 =  2

{-# LINE 1467 "Graphics/X11/Types.hsc" #-}

----------------------------------------------------------------
-- CURSOR STUFF
----------------------------------------------------------------

type QueryBestSizeClass = Int
cursorShape		 :: QueryBestSizeClass
cursorShape		 =  0
tileShape		 :: QueryBestSizeClass
tileShape		 =  1
stippleShape		 :: QueryBestSizeClass
stippleShape		 =  2

{-# LINE 1478 "Graphics/X11/Types.hsc" #-}

----------------------------------------------------------------
-- GRAPHICS DEFINITIONS
----------------------------------------------------------------

-- graphics functions, as in GC.alu

type   GXFunction	= Int
gXclear		 :: GXFunction
gXclear		 =  0
gXand		 :: GXFunction
gXand		 =  1
gXandReverse		 :: GXFunction
gXandReverse		 =  2
gXcopy		 :: GXFunction
gXcopy		 =  3
gXandInverted	 :: GXFunction
gXandInverted	 =  4
gXnoop		 :: GXFunction
gXnoop		 =  5
gXxor		 :: GXFunction
gXxor		 =  6
gXor			 :: GXFunction
gXor			 =  7
gXnor		 :: GXFunction
gXnor		 =  8
gXequiv		 :: GXFunction
gXequiv		 =  9
gXinvert		 :: GXFunction
gXinvert		 =  10
gXorReverse		 :: GXFunction
gXorReverse		 =  11
gXcopyInverted	 :: GXFunction
gXcopyInverted	 =  12
gXorInverted		 :: GXFunction
gXorInverted		 =  13
gXnand		 :: GXFunction
gXnand		 =  14
gXset		 :: GXFunction
gXset		 =  15

{-# LINE 1504 "Graphics/X11/Types.hsc" #-}

type   LineStyle	= Int
lineSolid		 :: LineStyle
lineSolid		 =  0
lineOnOffDash	 :: LineStyle
lineOnOffDash	 =  1
lineDoubleDash	 :: LineStyle
lineDoubleDash	 =  2

{-# LINE 1511 "Graphics/X11/Types.hsc" #-}

type   CapStyle		= Int
capNotLast		 :: CapStyle
capNotLast		 =  0
capButt		 :: CapStyle
capButt		 =  1
capRound		 :: CapStyle
capRound		 =  2
capProjecting	 :: CapStyle
capProjecting	 =  3

{-# LINE 1519 "Graphics/X11/Types.hsc" #-}

type   JoinStyle	= Int
joinMiter		 :: JoinStyle
joinMiter		 =  0
joinRound		 :: JoinStyle
joinRound		 =  1
joinBevel		 :: JoinStyle
joinBevel		 =  2

{-# LINE 1526 "Graphics/X11/Types.hsc" #-}

type   FillStyle	= Int
fillSolid		 :: FillStyle
fillSolid		 =  0
fillTiled		 :: FillStyle
fillTiled		 =  1
fillStippled		 :: FillStyle
fillStippled		 =  2
fillOpaqueStippled	 :: FillStyle
fillOpaqueStippled	 =  3

{-# LINE 1534 "Graphics/X11/Types.hsc" #-}

type   FillRule		= Int
evenOddRule		 :: FillRule
evenOddRule		 =  0
windingRule		 :: FillRule
windingRule		 =  1

{-# LINE 1540 "Graphics/X11/Types.hsc" #-}

type   SubWindowMode	= Int
clipByChildren	 :: SubWindowMode
clipByChildren	 =  0
includeInferiors	 :: SubWindowMode
includeInferiors	 =  1

{-# LINE 1546 "Graphics/X11/Types.hsc" #-}

-- -- SetClipRectangles ordering
-- type   Ordering        = Int
-- {enum Ordering,
-- , unsorted		= Unsorted
-- , ySorted		= YSorted
-- , yXSorted		= YXSorted
-- , yXBanded		= YXBanded
-- }

-- CoordinateMode for drawing routines
type   CoordinateMode	= Int
coordModeOrigin	 :: CoordinateMode
coordModeOrigin	 =  0
coordModePrevious	 :: CoordinateMode
coordModePrevious	 =  1

{-# LINE 1562 "Graphics/X11/Types.hsc" #-}

type   PolygonShape	= Int
complex		 :: PolygonShape
complex		 =  0
nonconvex		 :: PolygonShape
nonconvex		 =  1
convex		 :: PolygonShape
convex		 =  2

{-# LINE 1569 "Graphics/X11/Types.hsc" #-}

-- Arc modes for PolyFillArc
type   ArcMode		= Int
arcChord		 :: ArcMode
arcChord		 =  0
arcPieSlice		 :: ArcMode
arcPieSlice		 =  1

{-# LINE 1576 "Graphics/X11/Types.hsc" #-}

-- GC components: masks used in CreateGC, CopyGC, ChangeGC, OR'ed into
-- GC.stateChanges

type   GCMask		= Int
gCFunction		 :: GCMask
gCFunction		 =  1
gCPlaneMask		 :: GCMask
gCPlaneMask		 =  2
gCForeground		 :: GCMask
gCForeground		 =  4
gCBackground		 :: GCMask
gCBackground		 =  8
gCLineWidth		 :: GCMask
gCLineWidth		 =  16
gCLineStyle		 :: GCMask
gCLineStyle		 =  32
gCCapStyle		 :: GCMask
gCCapStyle		 =  64
gCJoinStyle		 :: GCMask
gCJoinStyle		 =  128
gCFillStyle		 :: GCMask
gCFillStyle		 =  256
gCFillRule		 :: GCMask
gCFillRule		 =  512
gCTile		 :: GCMask
gCTile		 =  1024
gCStipple		 :: GCMask
gCStipple		 =  2048
gCTileStipXOrigin	 :: GCMask
gCTileStipXOrigin	 =  4096
gCTileStipYOrigin	 :: GCMask
gCTileStipYOrigin	 =  8192
gCFont		 :: GCMask
gCFont		 =  16384
gCSubwindowMode	 :: GCMask
gCSubwindowMode	 =  32768
gCGraphicsExposures	 :: GCMask
gCGraphicsExposures	 =  65536
gCClipXOrigin	 :: GCMask
gCClipXOrigin	 =  131072
gCClipYOrigin	 :: GCMask
gCClipYOrigin	 =  262144
gCClipMask		 :: GCMask
gCClipMask		 =  524288
gCDashOffset		 :: GCMask
gCDashOffset		 =  1048576
gCDashList		 :: GCMask
gCDashList		 =  2097152
gCArcMode		 :: GCMask
gCArcMode		 =  4194304
gCLastBit		 :: GCMask
gCLastBit		 =  22

{-# LINE 1607 "Graphics/X11/Types.hsc" #-}

type   CirculationDirection = Int
raiseLowest		 :: CirculationDirection
raiseLowest		 =  0
lowerHighest		 :: CirculationDirection
lowerHighest		 =  1

{-# LINE 1613 "Graphics/X11/Types.hsc" #-}

-- used in imageByteOrder and bitmapBitOrder
type   ByteOrder	= Int
lSBFirst		 :: ByteOrder
lSBFirst		 =  0
mSBFirst		 :: ByteOrder
mSBFirst		 =  1

{-# LINE 1620 "Graphics/X11/Types.hsc" #-}

type   ColormapAlloc	= Int
allocNone		 :: ColormapAlloc
allocNone		 =  0
allocAll		 :: ColormapAlloc
allocAll		 =  1

{-# LINE 1626 "Graphics/X11/Types.hsc" #-}

type   MappingRequest   = Int
mappingModifier	 :: MappingRequest
mappingModifier	 =  0
mappingKeyboard	 :: MappingRequest
mappingKeyboard	 =  1
mappingPointer	 :: MappingRequest
mappingPointer	 =  2

{-# LINE 1633 "Graphics/X11/Types.hsc" #-}

type   ChangeSaveSetMode = Int
setModeInsert	 :: ChangeSaveSetMode
setModeInsert	 =  0
setModeDelete	 :: ChangeSaveSetMode
setModeDelete	 =  1

{-# LINE 1639 "Graphics/X11/Types.hsc" #-}

type   BitGravity	= Int
forgetGravity	 :: BitGravity
forgetGravity	 =  0
northWestGravity	 :: BitGravity
northWestGravity	 =  1
northGravity		 :: BitGravity
northGravity		 =  2
northEastGravity	 :: BitGravity
northEastGravity	 =  3
westGravity		 :: BitGravity
westGravity		 =  4
centerGravity	 :: BitGravity
centerGravity	 =  5
eastGravity		 :: BitGravity
eastGravity		 =  6
southWestGravity	 :: BitGravity
southWestGravity	 =  7
southGravity		 :: BitGravity
southGravity		 =  8
southEastGravity	 :: BitGravity
southEastGravity	 =  9
staticGravity	 :: BitGravity
staticGravity	 =  10

{-# LINE 1654 "Graphics/X11/Types.hsc" #-}

-- All the BitGravity's plus ...
type   WindowGravity   = Int
unmapGravity		 :: WindowGravity
unmapGravity		 =  0

{-# LINE 1660 "Graphics/X11/Types.hsc" #-}

-- Used in CreateWindow for backing-store hint
type   BackingStore	= Int
notUseful		 :: BackingStore
notUseful		 =  0
whenMapped		 :: BackingStore
whenMapped		 =  1
always		 :: BackingStore
always		 =  2

{-# LINE 1668 "Graphics/X11/Types.hsc" #-}

doRed		 :: Word8
doRed		 =  1
doGreen		 :: Word8
doGreen		 =  2
doBlue		 :: Word8
doBlue		 =  4

{-# LINE 1674 "Graphics/X11/Types.hsc" #-}

type   FontDirection    = Int
fontLeftToRight	 :: FontDirection
fontLeftToRight	 =  0
fontRightToLeft	 :: FontDirection
fontRightToLeft	 =  1

{-# LINE 1680 "Graphics/X11/Types.hsc" #-}
