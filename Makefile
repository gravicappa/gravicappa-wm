DEST = uwm.o1

LDFLAGS = -lX11
GSCFLAGS= -ld-options "${LDFLAGS}"

.PHONY: all clean clean-obj run xlib

all: clean-obj Xlib.o1 ${DEST} 

run: all
	gsi Xlib -e '(load "uwm") (main)'

run-src: uwm.scm Xlib.o1
	-rm uwm.o* 2> /dev/null
	gsi Xlib -e '(load "uwm.scm") (main "-d" "localhost:2")'

clean: clean-obj
	-rm 'Xlib#.scm'

xlib: Xlib.o1

clean-obj:
	-rm *.o* 2> /dev/null

%.o1 : %.scm
	gambit-gsc ${GSCFLAGS} $<

Xlib\#.scm: Xlib.scm
	./make-gambit-include 'Xlib#' < Xlib.scm > Xlib\#.scm

Xlib.o1: Xlib.scm Xlib\#.scm
	-rm Xlib.o* 2>/dev/null
	gambit-gsc -ld-options "-lX11" Xlib.scm

