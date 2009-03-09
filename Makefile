DEST = xlib uwm.o1
RUN_CODE = '(load "xlib/Xlib") (load "uwm") (main "-d" "localhost:2")'

LDFLAGS = -lX11
GSCFLAGS= -ld-options "${LDFLAGS}"

.PHONY: all clean clean-obj run xlib

all: clean-obj ${DEST} 

run: 
	rlwrap -c -a'' -P ${RUN_CODE} -m gsi

run-src: uwm.scm xlib
	-rm uwm.o* 2> /dev/null
	make run

clean: clean-obj

xlib:
	make -C xlib

clean-obj:
	-rm *.o* 2> /dev/null

%.o1 : %.scm xlib
	gambit-gsc ${GSCFLAGS} $<

