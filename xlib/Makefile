name = xlib
namespace = x
namespace_def = xlib\#.scm

sources = xlib.scm
targets = ${sources:%.scm=%.o1}

generated = xlib-events%.scm xlib-accessors%.scm xlib-constants%.scm
LDFLAGS += -lX11

GSC = ${shell [ `which gambit-gsc 2>/dev/null` ] && echo gambit-gsc || echo gsc}

.PHONY: all clean clean-obj events clean-generated

all: build ${namespace_def}

%.o1: %.scm
	${GSC} ${GSCFLAGS} -cc-options "${CFLAGS}" -ld-options "${LDFLAGS}" $<

build: ${targets}

${namespace_def}: ${sources} ${generated}
	cat $^ | ./make-include ${namespace} > $@

clean:
	-rm *.o*

clean: clean-obj

clean-generated:
	-rm -f *%.scm

#events: xlib-events%.scm
#accessors: xlib-accessors%.scm
#constants: xlib-constants%.scm

xlib-events%.scm: /usr/include/X11/Xlib.h
	./make-xlib-events > $@
	
xlib-accessors%.scm:	x-struct
	./make-accessors < $< > $@

xlib-constants%.scm:	
	./make-constants > $@

xlib.o1: xlib.scm ${generated} xlib\#.scm
	-rm xlib.o* 2>/dev/null
	gambit-gsc -ld-options "-lX11" xlib.scm
