name = gravicappa-wm
exe = $(name)
version = HEAD

destdir = /usr
install = install

LDFLAGS += -lX11
GSCFLAGS = -prelude '(declare (extended-bindings))' \
           -cc-options "-pipe $(CFLAGS)" -ld-options "$(LDFLAGS)"
GSC = gsc
CC = gcc

-include config.mk

src = xlib/xlib.scm gravicappa-wm.scm
deps = $(wildcard *.scm)

.PHONY: all clean install

all: $(exe) stdio

clean:
	-rm *.c *.o *.o* $(executable) 2>/dev/null

$(exe): $(src) $(deps)
	$(GSC) $(GSCFLAGS) -exe -o $@ $(src)

stdio: stdio.c
	$(CC) $< -o $@ -lutil

install:
	$(install) -m 755 $(exe) $(destdir)/bin/

pack: 
	git archive --format=tar --prefix=$(name)-$(version)/ $(version)^{tree} \
	| gzip > $(name)-$(version).tar.gz
