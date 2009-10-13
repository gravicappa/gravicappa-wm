generated = Xlib-events\#.scm Xlib-accessors\#.scm Xlib-constants\#.scm
LDFLAGS = -lX11
GSCFLAGS= -ld-options "${LDFLAGS}"

.PHONY: all clean clean-obj events clean-generated

all: Xlib.o1

clean: clean-obj

clean-obj:
	-rm *.o* 2> /dev/null

clean-generated:
	-rm ${generated} Xlib\#.scm

events: Xlib-events\#.scm
accessors: Xlib-accessors\#.scm
constants: Xlib-constants\#.scm

Xlib-events\#.scm: /usr/include/X11/Xlib.h
	./make-xlib-events > 'Xlib-events#.scm'
	
Xlib-accessors\#.scm:	x-struct
	./make-accessors < $< > $@

Xlib-constants\#.scm:	
	./make-constants > $@

Xlib\#.scm: Xlib.scm
	cat Xlib.scm ${generated} | ./make-gambit-include 'Xlib#' > $@

Xlib.o1: Xlib.scm ${generated} Xlib\#.scm
	-rm Xlib.o* 2>/dev/null
	gambit-gsc -ld-options "-lX11" Xlib.scm
