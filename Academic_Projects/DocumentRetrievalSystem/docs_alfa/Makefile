CC = gcc
CFLAGS = -Wall -g

all: dserver dclient

dserver: dserver.c servidor.c hashtable.c servidor.h hashtable.h
	$(CC) $(CFLAGS) dserver.c servidor.c hashtable.c -o dserver

dclient: dclient.c servidor.h
	$(CC) $(CFLAGS) dclient.c -o dclient

clean:
	rm -f dserver dclient *.o client_*_fifo server_fifo

