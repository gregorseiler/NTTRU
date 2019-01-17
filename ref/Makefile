CC ?= /usr/bin/cc
CFLAGS += -Wall -march=native -mtune=native -O3 -fomit-frame-pointer
#CFLAGS += -DUSE_RDPMC
#CFLAGS += -DDBENCH
LDFLAGS += -lcrypto -ldl
SOURCES = kem.c ntru.c poly.c ntt.c fq.c randombytes.c aes256ctr.c \
  test/cpucycles.c test/speed.c
HEADERS = params.h kem.h ntru.h poly.h fq.h ntt.h \
  crypto_stream.h randombytes.h test/cpucycles.h test/speed.h

all: test/test_fq test/test_ntt test/test_poly test/test_packing \
  test/test_ntru test/test_kem

test/test_fq: test/test_fq.c $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS) -UDBENCH $< $(SOURCES) -o $@ $(LDFLAGS)

test/test_ntt: test/test_ntt.c $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS) -UDBENCH $< $(SOURCES) -o $@ $(LDFLAGS)

test/test_poly: test/test_poly.c $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS) -UDBENCH $< $(SOURCES) -o $@ $(LDFLAGS)

test/test_packing: test/test_packing.c $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS) -UDBENCH $< $(SOURCES) -o $@ $(LDFLAGS)

test/test_ntru: test/test_ntru.c $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS) $< $(SOURCES) -o $@ $(LDFLAGS)

test/test_kem: test/test_kem.c $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS) $< $(SOURCES) -o $@ $(LDFLAGS)

.PHONY: clean

clean:
	rm -f *~ test/*~
	rm -f test/test_fq
	rm -f test/test_ntt
	rm -f test/test_poly
	rm -f test/test_packing
	rm -f test/test_ntru
	rm -f test/test_kem
