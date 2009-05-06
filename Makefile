BINARY = uwm
DEST = xlib uwm.o1
RUN_CODE = '(load "xlib/Xlib") (load "uwm") (main "-d" "${DISPLAY}")'

GSC = gambit-gsc
RUNFLAGS = -ld-options "-lX11"
CC = gcc
CPU = ${shell arch}
GAMBIT_LIBDIR = /usr/lib/
GAMBIT_LIB = /usr/lib/libgambc.a
GAMBIT_INCLUDEDIR = /usr/include/

CFLAGS = -I${GAMBIT_INCLUDEDIR} \
         -I. \
         -Wall -W -Wno-unused \
				 -O1 \
				 -fno-math-errno \
				 -fschedule-insns2 \
				 -fno-trapping-math \
				 -fno-strict-aliasing \
				 -fwrapv \
				 -fmodulo-sched \
				 -freschedule-modulo-scheduled-loops \
				 -fomit-frame-pointer \
				 -fPIC \
				 -fno-common \
				 -mieee-fp \
				 -D___GAMBCDIR="\"${GAMBIT_INCLUDEDIR}\"" \
				 -D___SYS_TYPE_CPU="\"${CPU}\"" \
				 -D___SYS_TYPE_VENDOR="\"unknown\"" \
				 -D___SYS_TYPE_OS="\"linux-gnu\""

LDFLAGS = -rdynamic
LIBS = -lutil -ldl -lm -lX11

%.o:%.c
	${CC} ${CFLAGS} -o $@ -c $<
.PHONY: all clean clean-obj run xlib

all: ${BINARY}

run:
	rlwrap -c -a'' -P ${RUN_CODE} -m gsi -

run-src: uwm.scm xlib
	-rm uwm.o* 2> /dev/null
	make run

clean: clean-obj
	-rm *.c *.o ${BINARY}

uwm-main.c: uwm-main.scm xlib/Xlib.c
	gambit-gsc -f -c -check -o $@ $<

xlib/Xlib.c: xlib/Xlib.scm
	gambit-gsc -f -c -check -o $@ $<

_uwm-main.c: xlib/Xlib.c uwm-main.c
	gambit-gsc -f -link -l ${GAMBIT_LIBDIR}/_gambc -o $@ $^

${BINARY}: _uwm-main.o xlib/Xlib.o uwm-main.o ${GAMBIT_LIB}
	 ${CC} ${LDFLAGS} $^ ${LIBS} -o $@

xlib:
	make -C xlib

clean-obj:
	-rm *.o* 2> /dev/null

%.o1 : %.scm xlib
	${GSC} ${RUNFLAGS} $<
