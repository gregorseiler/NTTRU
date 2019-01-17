#ifndef POLY_H
#define POLY_H

#include <stdint.h>
#include "params.h"

#define POLY_PACKED_UNIFORM_BYTES (LOGQ*N/8)
#define POLY_PACKED_SHORT_BYTES (LOGQ*N/8)

typedef struct {
  int16_t coeffs[N];
} poly __attribute__((aligned(32)));

void poly_reduce(poly *a);
void poly_freeze(poly *a);

void poly_add(poly *c, const poly *a, const poly *b);
void poly_triple(poly *b, const poly *a);

void poly_ntt(poly *b, const poly *a);
void poly_invntt(poly *b, const poly *a);
void poly_basemul(poly *c, const poly *a, const poly *b);
int poly_baseinv(poly *b, const poly *a);

void poly_uniform(poly *a, const unsigned char *buf);
void poly_short(poly *a, const unsigned char *buf);

void poly_crepmod3(poly *b, const poly *a);

void poly_pack_uniform(unsigned char *buf, const poly *a);
void poly_unpack_uniform(poly *a, const unsigned char *buf);
void poly_pack_short(unsigned char *buf, const poly *a);
void poly_unpack_short(poly *a, const unsigned char *buf);

#endif
