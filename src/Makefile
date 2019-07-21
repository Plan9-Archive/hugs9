# --------------------------------------------------------------------------
# Makefile for Hugs (adapted for use with Plan 9)
#
# The Hugs 98 system is Copyright (c) Mark P Jones, Alastair Reid, the
# Yale Haskell Group, and the OGI School of Science & Engineering at OHSU,
# 1994-2002, All rights reserved.  It is distributed as
# free software under the license in the file "License", which is
# included in the distribution.
# --------------------------------------------------------------------------

# Targets:
#
# <default>:   	 make hugs
# hugs:    	 make minimal working system
# runhugs:   make standalone evaluator
# clean:       	 delete files not required in running system
# distclean:     delete files that can be regenerated using C compiler
# veryclean:     delete all machine generated files 
#                  (you need perl, bison/yacc, etc to rebuild these files)
# check:	 run regression tests
# TAGS:          build emacs TAGS table

# This rule goes first to make it the default choice
default		:: hugs runhugs

HUGLIB=${home}/lib/hugs

DEFINES = -DHUGSDIR=\"$(HUGLIB)\" -D_C99_SNPRINTF_EXTENSION
CC		= cc
CFLAGS		= -g -O ${DEFINES}

LD		= cc
LDFLAGS    	= 
LIBS		= 

RM		= rm -f
CP		= cp

.SUFFIXES	:
.SUFFIXES	: .c .h .o
HFILES		= HsFFI.h builtin.h char.h command.h config.h connect.h \
		  errors.h evaluator.h goal.h machdep.h module.h observe.h \
		  options.h opts.h output.h prelude.h script.h server.h \
		  storage.h strutil.h subst.h
CFILES		= hugs.c runhugs.c server.c edit.c observe.c \
		  builtin.c char.c compiler.c errors.c evaluator.c ffi.c \
		  goal.c input.c machdep.c machine.c module.c opts.c \
		  output.c plugin.c script.c static.c storage.c strutil.c \
		  subst.c type.c version.c
INCFILES	= array.c bignums.c dirprim.c interns.c iomonad.c \
		  preds.c printer.c scc.c timeprim.c timer.c
YFILES		= parser.y
SOURCES		= $(HFILES) $(CFILES) $(INCFILES) $(YFILES) 
OBJECTS		= builtin.o char.o compiler.o \
		  errors.o evaluator.o ffi.o \
		  goal.o input.o machdep.o \
		  machine.o module.o opts.o \
		  output.o plugin.o script.o \
		  static.o storage.o strutil.o \
		  subst.o type.o version.o
IOBJECTS	= hugs.o edit.o observe.o $(OBJECTS)
PRELUDE		= config.h options.h prelude.h

install:	hugs runhugs
	test -d ${HUGLIB} || mkdir ${HUGLIB}
	test -d ${HUGLIB}/lib || mkdir ${HUGLIB}/lib
	test -d ${HUGLIB}/demos || mkdir ${HUGLIB}/demos
	test -d ${HUGLIB}/demos/prolog || mkdir ${HUGLIB}/demos/prolog
	test -d ${HUGLIB}/lib/hugs || mkdir ${HUGLIB}/lib/hugs
	test -d ${HUGLIB}/lib/exts || mkdir ${HUGLIB}/lib/exts
	cp ../lib/[A-Z]* ${HUGLIB}/lib
	cp ../lib/hugs/* ${HUGLIB}/lib/hugs/
	cp ../lib/exts/* ${HUGLIB}/lib/exts/
	cp ../demos/prolog/* ${HUGLIB}/demos/prolog/
	cp ../demos/[A-Z]* ${HUGLIB}/demos/
	cp hugs ${home}/bin/${objtype}/
	cp runhugs ${home}/bin/${objtype}/


################################################################
# Hugs interpreter and standalone evaluator
################################################################

hugs	: $(IOBJECTS)  
		  $(LD) $(LDFLAGS) -o hugs $(IOBJECTS) $(LIBS)

SERVER_OBJECTS	= server.o $(OBJECTS) 

runhugs.o	: config.h options.h server.h runhugs.c
runhugs	: runhugs.o $(SERVER_OBJECTS)
		  $(LD) $(LDFLAGS) -o runhugs runhugs.o $(SERVER_OBJECTS) $(LIBS) 

################################################################
# Clean, distclean, veryclean, TAGS
################################################################

clean		::
		  $(RM) *.o
		  $(RM) *.aux
		  $(RM) *.hp
		  $(RM) *.def
		  $(RM) *.exp
		  $(RM) *.ilk
		  $(RM) *.lib
		  $(RM) *.pdb
		  $(RM) *.td2
		  $(RM) *.map
		  $(RM) *.csm
		  $(RM) *.MAP
		  $(RM) *.TR2
		  $(RM) *.RES
		  $(RM) *.DSW
		  $(RM) *.OBJ
distclean	:: clean
distclean	::
		  $(RM) hugs
		  $(RM) runhugs 
		  $(RM) *.lib
		  $(RM) *.pdf
		  $(RM) TAGS
		  $(RM) *~
veryclean	:: distclean

TAGS		::
		  etags *.[ych]

################################################################
# Dependencies
################################################################

.c.o		:
		  $(CC) -c $(CFLAGS) $(OPTFLAGS) $<

# These are compiled with less optimisation to avoid optimisation bugs in
# certain compilers.  This may be overly conservative on some compilers.
compiler.o	: compiler.c
		  $(CC) -c $(CFLAGS) compiler.c
static.o	: static.c
		  $(CC) -c $(CFLAGS) static.c


server.o	: $(PRELUDE) storage.h connect.h errors.h \
		  command.h machdep.c timer.c server.c server.h
hugs.o		: $(PRELUDE) storage.h connect.h errors.h \
		  command.h machdep.c timer.c
ffi.o		: $(PRELUDE) storage.h connect.h errors.h
storage.o	: $(PRELUDE) storage.h connect.h errors.h
input.o		: $(PRELUDE) storage.h connect.h errors.h \
		  parser.c command.h
subst.o		: $(PRELUDE) storage.h connect.h errors.h subst.h
static.o	: $(PRELUDE) storage.h connect.h errors.h subst.h \
		  scc.c
type.o		: $(PRELUDE) storage.h connect.h errors.h subst.h \
		  scc.c preds.c
output.o	: $(PRELUDE) storage.h connect.h errors.h
compiler.o	: $(PRELUDE) storage.h connect.h errors.h \
		  compiler.c
machine.o	: $(PRELUDE) storage.h connect.h errors.h
plugin.o	: $(PRELUDE) storage.h connect.h errors.h
builtin.o	: $(PRELUDE) storage.h connect.h errors.h \
		  bignums.c printer.c iomonad.c interns.c array.c

################################################################
# Regression tests (none supplied)
################################################################

check		:


################################################################
# End of Makefile
################################################################
