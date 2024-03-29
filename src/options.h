/* --------------------------------------------------------------------------
 * Configuration options
 *
 * The Hugs 98 system is Copyright (c) Mark P Jones, Alastair Reid, the
 * Yale Haskell Group, and the OGI School of Science & Engineering at OHSU,
 * 1994-2003, All rights reserved.  It is distributed as free software under
 * the license in the file "License", which is included in the distribution.
 *
 * $RCSfile: options.h.in,v $
 * $Revision: 1.19 $
 * $Date: 2005/03/08 14:36:19 $
 * ------------------------------------------------------------------------*/

/* --------------------------------------------------------------------------
 * Hugs paths and directories
 * ------------------------------------------------------------------------*/

/* Define this as the default setting of HUGSPATH.
 * Value may contain string "{Hugs}" (for which we will substitute the
 * value of HUGSDIR) and should be either colon-separated (Unix)
 * or semicolon-separated (Macintosh, Windows, DOS).  Escape
 * characters in the path string are interpreted according to normal
 * Haskell conventions.
 *
 * This value can be overridden from the command line by setting the
 * HUGSFLAGS environment variable or by storing an appropriate value
 * for HUGSFLAGS in the registry (Win32 only).  In all cases, use a
 * string of the form -P"...".
 */
#define HUGSPATH ".:{Hugs}/packages/*:{Hugs}/oldlib:{Hugs}/include"
#define HUGSPATH2 "{Hugs}/libraries:{Hugs}/oldlib"

/* The list of suffixes used by Haskell source files, separated either
 * by colons (Unix) or semicolons (Macintosh, Windows, DOS).
 *
 * This value can be overridden using the -S flag.
 */
#define HUGSSUFFIXES ".hs:.lhs"

/* The directory name which is substituted for the string "{Hugs}"
 * in a path variable.  This normally points to where the Hugs libraries
 * are installed - ie so that the file HUGSDIR/lib/Prelude.hs exists
 * Typical values are:
 *    "/usr/local/lib/hugs"
 *    "/usr/homes/JFHaskell/hugs"
 *    ".."
 *
 * On Windows and Macintosh Classic, the directory containing the
 * binary is used instead.
 *
 * This value can be overridden from the command line by setting the
 * HUGSDIR environment variable.
 */
#ifndef HUGSDIR
#define HUGSDIR ".."
#endif

/* --------------------------------------------------------------------------
 * User interface options
 * ------------------------------------------------------------------------*/

/* Define if you want to use the "Hugs for Windows" GUI.
 * (Windows 3.1 and compatibles only)
 */
#undef HUGS_FOR_WINDOWS

/* Define if you want filenames to be converted to normal form by:
 * o replacing relative pathnames with absolute pathnames and
 *   eliminating .. and . where possible.
 * o converting to lower case (only in case-insensitive filesystems)
 */
#define PATH_CANONICALIZATION 1

/* Define if a command line editor is available and should be used.
 * There are two choices of command line editor that can be used with Hugs:
 * GNU readline and editline (from comp.sources.misc, vol 31, issue 71)
 */
#undef USE_READLINE

/* Define if you want the small startup banner.
 */
#undef SMALL_BANNER

/* --------------------------------------------------------------------------
 * Making Hugs smaller
 * ------------------------------------------------------------------------*/

/* Define one of these to select overall size of Hugs
 *   SMALL_HUGS     for 16 bit operation on a limited memory PC.
 *   REGULAR_HUGS   for 32 bit operation using largish default table sizes.
 *   LARGE_HUGS     for 32 bit operation using larger default table sizes.
 */
#undef SMALL_HUGS
#undef REGULAR_HUGS
#define LARGE_HUGS 1

/* --------------------------------------------------------------------------
 * Fancy features
 * ------------------------------------------------------------------------*/

/* Define to omit Hugs extensions                                          */
#undef HASKELL_98_ONLY

/* Define if :xplain should be enabled					   */
#undef EXPLAIN_INSTANCE_RESOLUTION

/* Define if heap profiling should be used                                 */
#undef PROFILING

/* Define if you want to run Haskell code through a preprocessor
 *
 * Note that there's the import chasing mechanism will not spot any
 * #includes so you must :load (not :reload) if you change any
 * (non-Haskell) configurations files.
 */
#define USE_PREPROCESSOR 1

/* Define if you want to time every evaluation.
 *
 * Timing is included in the Hugs distribution for the purpose of benchmarking
 * the Hugs interpreter, comparing its performance across a variety of
 * different machines, and with other systems for similar languages.
 *
 * It would be somewhat foolish to try to use the timings produced in this
 * way for any other purpose.  In particular, using timings to compare the
 * performance of different versions of an algorithm is likely to give very
 * misleading results.  The current implementation of Hugs as an interpreter,
 * without any significant optimizations, means that there are much more
 * significant overheads than can be accounted for by small variations in
 * Hugs code.
 */
#undef WANT_TIMER

/*
 * By default, the Hugs Server API wraps up each value pushed on the stack
 * as a Dynamic, achieving some run-time type safety when applying these
 * arguments to a function. This Dynamic layer sometimes gets in the way
 * for low-level consumers of the Server API (e.g, HaskellScript, Lambada,
 * mod_haskell), so by setting NO_DYNAMIC_TYPES to 1 you turn off the
 * use of Dynamics (and assume all the responsibility of debugging any
 * bad crashes you might see as a result!)
 */
#undef NO_DYNAMIC_TYPES

/* --------------------------------------------------------------------------
 * Debugging options (intended for use by maintainers)
 * ------------------------------------------------------------------------*/

/* Define if debugging generated bytecodes or the bytecode interpreter     */
#undef DEBUG_CODE

/* Define if debugging generated supercombinator definitions or compiler   */
#undef DEBUG_SHOWSC

/* Define if you want to use a low-level printer from within a debugger    */
#undef DEBUG_PRINTER

/* Define if you want to perform runtime tag-checks as an internal
 * consistency check.  This makes Hugs run very slowly - but is very
 * effective at detecting and locating subtle bugs.
 */
#undef CHECK_TAGS


/* --------------------------------------------------------------------------
 * Experimental features
 * These are likely to disappear/change in future versions and should not
 * be used by most people..
 * ------------------------------------------------------------------------*/

/* Define if you want to use the primitives which let you examine Hugs
 * internals.
 */
#undef INTERNAL_PRIMS

/* Define if you want to use the primitives which let you examine Hugs
 * bytecodes (requires INTERNAL_PRIMS).
 */
#undef BYTECODE_PRIMS

/* In a plain Hugs system, most signals (SIGBUS, SIGTERM, etc) indicate
 * some kind of error in Hugs - or maybe a stack overflow.  Rather than
 * just crash, Hugs catches these errors and returns to the main loop.
 * It does this by calling a function "panic" which longjmp's back to the
 * main loop.
 * If you're developing a GreenCard library, this may not be the right
 * behaviour - it's better if Hugs leaves them for your debugger to
 * catch rather than trapping them and "panicing".
 */
#undef DONT_PANIC

/* If you get really desperate to understand why your Hugs programs keep
 * crashing or running out of stack, you might like to set this flag and
 * recompile Hugs.  When you hit a stack error, it will print out a list
 * of all the objects currently under evaluation.  The information isn't
 * perfect and can be pretty hard to understand but it's better than a
 * poke in the eye with a blunt stick.
 *
 * This is a very experimental feature!
 */
#undef GIMME_STACK_DUMPS

/* ----------------------------------------------------------------------- */
