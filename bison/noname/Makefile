
CLASSDIR=.
LIB= -lfl

SRC= noname.flex
# SRC= noname.flex noname.nn README 
#CSRC= lextest.cc utilities.cc stringtab.cc handle_flags.cc
CSRC= 
# TSRC= mycoolc
TSRC= 
HSRC= 
CGEN= noname-lex.cc
HGEN=
LIBS= parser semant cgen
CFIL= ${CSRC} ${CGEN}
LSRC= Makefile
OBJS= ${CFIL:.cc=.o}
OUTPUT= test.output

CPPINCLUDE= -I. -I${CLASSDIR}/include -I${CLASSDIR}/src

FFLAGS= -d -ononame-lex.cc

CC=g++
CFLAGS= -g -Wall -Wno-unused -Wno-write-strings ${CPPINCLUDE}
FLEX=flex ${FFLAGS}
DEPEND = ${CC} -MM ${CPPINCLUDE}

source : ${SRC} ${TSRC} ${LSRC} ${LIBS} lsource

lsource: ${LSRC}

${OUTPUT}:lexer noname.nn
	@rm -f test.output
	-./lexer noname.nn >test.output 2>&1 

lexer: ${OBJS}
	${CC} ${CFLAGS} ${OBJS} ${LIB} -o lexer

.cc.o:
	${CC} ${CFLAGS} -c $<

noname-lex.cc: noname.flex 
	${FLEX} noname.flex

dotest:	lexer noname.nn
	./lexer noname.nn

# ${LIBS}:
# 	${CLASSDIR}/etc/link-object ${ASSN} $@

# These dependencies allow you to get the starting files for
# the assignment.  They will not overwrite a file you already have.

# ${SRC} :								
# 	${CLASSDIR}/etc/copy-skel ${ASSN} ${SRC}

# ${LSRC} :
# 	${CLASSDIR}/etc/link-shared ${ASSN} ${LSRC}

# ${TSRC} ${CSRC}:
# 	-ln -s ${CLASSDIR}/src/PA${ASSN}/$@ $@

# ${HSRC}:
# 	-ln -s ${CLASSDIR}/include/PA${ASSN}/$@ $@

submit-clean: ${OUTPUT}
	-rm -f *.s core ${OBJS} lexer noname-lex.cc *~ parser cgen semant

clean :
	-rm -f ${OUTPUT} *.s core ${OBJS} lexer noname-lex.cc *~ parser cgen semant

clean-compile:
	@-rm -f core ${OBJS} noname-lex.cc ${LSRC}

%.d: %.cc ${SRC} ${LSRC}
	${SHELL} -ec '${DEPEND} $< | sed '\''s/\($*\.o\)[ :]*/\1 $@ : /g'\'' > $@'

-include ${CFIL:.cc=.d}


