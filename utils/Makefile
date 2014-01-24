name = xshownum
CC = gcc
CFLAGS = -O0 -g -Wall
LDFLAGS += -lxcb

all: $(name)

$(name): xshownum.c
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)
