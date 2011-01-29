GSC = gsc
-include config.mk

LDFLAGS += -lX11

.PHONY: all clean

all: xlib.o1

xlib.o1: xlib.scm ffi.scm xlib-constants.scm xlib-structs.scm
	-rm xlib.o* 2>/dev/null
	$(GSC) -ld-options "-lX11" xlib.scm

clean:
	-rm *.o*
