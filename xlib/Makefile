LDFLAGS = -lX11
GSCFLAGS= -ld-options "${LDFLAGS}"

.PHONY: all clean clean-obj events clean-generated

all: Xlib.o1

clean: clean-obj
	-rm 'Xlib#.scm'

clean-obj:
	-rm *.o* 2> /dev/null

clean-generated:
	-rm 'Xlib-events#.scm' 'Xlib-accessors#.scm'

events: Xlib-events\#.scm
accessors: Xlib-accessors\#.scm

Xlib-events\#.scm: /usr/include/X11/Xlib.h
	./make-xlib-events > 'Xlib-events#.scm'
	
Xlib-accessors\#.scm:	x-struct
	./make-accessors < $< > $@

Xlib\#.scm: Xlib.scm Xlib-events\#.scm Xlib-accessors\#.scm
	cat Xlib.scm Xlib-events\#.scm Xlib-accessors\#.scm \
		| ./make-gambit-include 'Xlib#' > $@

Xlib.o1: Xlib.scm Xlib-events\#.scm Xlib-accessors\#.scm Xlib\#.scm
	-rm Xlib.o* 2>/dev/null
	gambit-gsc -ld-options "-lX11" Xlib.scm
