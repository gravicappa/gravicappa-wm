name = gravicappa-wm
exe = $(name)
version = HEAD

destdir = /usr
install = install
gsc = gsc

LDFLAGS += -lX11
GSC_FLAGS = -prelude '(declare (extended-bindings))' \
            -cc-options "-pipe $(CFLAGS)" -ld-options "$(LDFLAGS)"
CC = gcc

-include config.mk

src = xlib/xlib.scm gravicappa-wm.scm
deps = $(wildcard *.scm)

.PHONY: all clean clean-obj xlib install

all: $(exe)

clean: clean-obj
	-rm *.c *.o $(executable) 2>/dev/null

$(exe): $(src) $(deps)
	$(gsc) $(GSC_FLAGS) -exe -o $@ $(src)

clean-obj:
	-rm *.o* 2> /dev/null

install:
	$(install) -m 755 $(exe) $(destdir)/bin/

pack: 
	git archive --format=tar --prefix=$(name)-$(version)/ $(version)^{tree} \
	| gzip > $(name)-$(version).tar.gz
