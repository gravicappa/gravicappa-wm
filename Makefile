name = gravicappa-wm
executable = ${name}
version = HEAD

GSC = gambit-gsc
GSC_FLAGS = -ld-options "-lX11"
CC = gcc
SRC = main.scm xlib/Xlib.scm

.PHONY: all clean clean-obj xlib

all: ${executable}

clean: clean-obj
	-rm *.c *.o ${executable}

${executable}: ${SRC} ${GAMBIT_LIB}
	${GSC} ${GSC_FLAGS} -exe -o $@ ${SRC}

xlib:
	make -C xlib

clean-obj:
	-rm *.o* 2> /dev/null

pack: 
	git archive --format=tar --prefix=${name}-${version}/ ${version}^{tree} \
	| bzip2 > ${name}-${version}.tar.bz2
