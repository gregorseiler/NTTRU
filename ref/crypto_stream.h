#ifndef CRYPTO_STREAM_H
#define CRYPTO_STREAM_H

int crypto_stream(unsigned char *out,
                  unsigned long long len,
                  const unsigned char nonce[16],
                  const unsigned char key[32]);

#endif
