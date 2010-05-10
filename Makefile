name = gravicappa-wm
exe = ${name}
version = HEAD

destdir = /usr
install = install
gsc = gsc

LDFLAGS += -lX11
#CFLAGS = -O0 -g
GSC_FLAGS = -cc-options "${CFLAGS}" -ld-options "${LDFLAGS}"
CC = gcc
src = xlib/xlib.scm main.scm
deps = ${wildcard *.scm}

.PHONY: all clean clean-obj xlib install

all: ${exe}

clean: clean-obj
	-rm *.c *.o ${executable} 2>/dev/null

${exe}: ${src} ${deps}
	${gsc} ${GSC_FLAGS} -exe -o $@ ${src}

clean-obj:
	-rm *.o* 2> /dev/null

install:
	${install} -m 755 ${exe} ${destdir}/bin/

pack: 
	git archive --format=tar --prefix=${name}-${version}/ ${version}^{tree} \
	| bzip2 > ${name}-${version}.tar.bz2
