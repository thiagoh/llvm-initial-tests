CLASSDIR=.
LIB= -ll
LDFLAGS:  -L/usr/local/opt/flex/lib
SRC= noname.flex
CSRC= 
CGEN= noname-lex.cc noname-parse.cc noname-main.cc
LIBS=
CFIL= ${CSRC} ${CGEN}
LSRC= Makefile
OBJS= ${CFIL:.cc=.o}
OUTPUT= test.output
CPPINCLUDE= -I. -I${CLASSDIR}/include -I${CLASSDIR}/src -I/usr/local/opt/flex/include
# FLEX_FLAGS= -d -X -P noname_yy -o noname-lex.cc
# BISON_FLAGS= -d -v -y -b noname --debug -p noname_yy
#TO ENAMBLE DEBUG => FLEX_FLAGS= -d -X -o noname-lex.cc
FLEX_FLAGS= -X -P noname_yy -o noname-lex.cc
BISON_FLAGS= -d -v -y -b noname --debug
CC=g++
# CFLAGS= -g -Wall -Wno-unused -Wno-write-strings ${CPPINCLUDE}
CFLAGS= -g -Wall -Wno-unused -Wno-deprecated -Wno-write-strings ${CPPINCLUDE}
FLEX= flex ${FLEX_FLAGS}
BISON= bison ${BISON_FLAGS}
DEPEND = ${CC} -MM ${CPPINCLUDE}

source : ${SRC} ${LSRC} ${LIBS} lsource

lsource: ${LSRC}

${OUTPUT}:lexer noname.nn
	@rm -f test.output
	-./lexer noname.nn >test.output 2>&1 

lexer: ${OBJS}
	${CC} ${CFLAGS} ${OBJS} ${LIB} -o lexer

parser: ${OBJS}
	${CC} ${CFLAGS} ${OBJS} ${LIB} -o parser

noname: ${OBJS} noname-lex.cc 
	${CC} ${CFLAGS} ${OBJS} ${LIB} ${LDFLAGS} -o noname -lm

%.o: %.cc 
	${CC} ${CFLAGS} -c -o $@ $<

flex: noname-lex.cc

noname-lex.cc: noname.flex noname.tab.h
	${FLEX} noname.flex

noname.tab.c noname.tab.h: noname.y
	${BISON} noname.y
	mv -f noname.tab.c noname-parse.cc

dotest:	lexer noname.nn
	./lexer noname.nn

clean:
	-rm -f ${OUTPUT} *.s core ${OBJS} noname-*.d lexer noname-lex.cc noname.tab.c noname-parse.cc noname.tab.h *~ parser cgen semant

clean-compile:
	@-rm -f core ${OBJS} noname-lex.cc

%.d: %.cc ${SRC} ${LSRC}
	${SHELL} -ec '${DEPEND} $< | sed '\''s/\($*\.o\)[ :]*/\1 $@ : /g'\'' > $@'

-include ${CFIL:.cc=.d}