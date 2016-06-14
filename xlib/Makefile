GSC = gambitc
-include config.mk

LDFLAGS += -lX11

.PHONY: all clean

all: xlib.o1

xlib.o1: xlib.scm ffi.scm xlib-constants.scm xlib-structs.scm
	rm -f xlib.o*
	$(GSC) -ld-options "-lX11" xlib.scm

clean:
	-rm *.o*
