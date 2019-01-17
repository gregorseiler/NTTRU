#ifndef NTT_H
#define NTT_H

#include <stdint.h>

extern int16_t zetas[256];
extern int16_t zetas_inv[256];
extern int16_t zetas_exp[1084];
extern int16_t zetas_inv_exp[1084];

void init_ntt();
void ntt(int16_t b[768], const int16_t a[768]);
void invntt(int16_t b[768], const int16_t a[768]);
void ntt_pack(int16_t b[768], const int16_t a[768]);
void ntt_unpack(int16_t b[768], const int16_t a[768]);
void basemul(int16_t c[3],
             const int16_t a[3],
             const int16_t b[3],
             int16_t zeta);
int baseinv(int16_t b[3], const int16_t a[3], int16_t zeta);

#endif
