#ifndef KEM_H
#define KEM_H

#include "params.h"

int crypto_kem_keypair(unsigned char *pk, unsigned char *sk);
int crypto_kem_enc(unsigned char *c,
                   unsigned char *k,
                   const unsigned char *pk);
int crypto_kem_dec(unsigned char *k,
                   const unsigned char *c,
                   const unsigned char *sk);

#endif
