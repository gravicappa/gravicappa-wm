name = xshowid
CC = gcc
CFLAGS = -O0 -g -Wall
LDFLAGS += -lxcb

all: $(name)

$(name): xshowid.c
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)
