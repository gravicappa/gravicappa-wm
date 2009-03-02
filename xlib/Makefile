LDFLAGS = -lX11
GSCFLAGS= -ld-options "${LDFLAGS}"

.PHONY: all clean clean-obj events

all: Xlib.o1

clean: clean-obj
	-rm 'Xlib#.scm'

clean-obj:
	-rm *.o* 2> /dev/null

events:
	./make-xlib-events > 'Xlib-events#.scm'

Xlib\#.scm: Xlib.scm Xlib-events\#.scm
	./make-gambit-include 'Xlib#' < $< > $@

Xlib.o1: Xlib.scm Xlib-events\#.scm Xlib\#.scm
	-rm Xlib.o* 2>/dev/null
	gambit-gsc -ld-options "-lX11" Xlib.scm
