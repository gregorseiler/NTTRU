#include <stdint.h>
#include <stdio.h>
#include "cpucycles.h"
#include "speed.h"
#include "../randombytes.h"
#include "../params.h"
#include "../poly.h"

#define NTESTS 512
#define HISTORY 512

static void poly_naivemul(poly *c, const poly *a, const poly *b) {
  unsigned int i,j;
  int32_t r[2*N];

  for(i = 0; i < 2*N; i++)
    r[i] = 0;

  for(i = 0; i < N; i++)
    for(j = 0; j < N; j++) {
      r[i+j] += ((int32_t)a->coeffs[i] * b->coeffs[j]) % Q;
      r[i+j] %= Q;
    }

  for(i = 3*N/2; i < 2*N-1; i++) {
    r[i-N/2] = (r[i-N/2] + r[i]) % Q;
    r[i-N] = (r[i-N] - r[i]) % Q;
  }
  for(i = N; i < 3*N/2; i++) {
    r[i-N/2] = (r[i-N/2] + r[i]) % Q;
    r[i-N] = (r[i-N] - r[i]) % Q;
  }

  for(i = 0; i < N; i++)
    c->coeffs[i] = r[i];
}

int main(void) {
  unsigned int i, j;
  unsigned long long t[HISTORY], overhead;
  unsigned char coins[N];
  poly a, b, c1, c2;

  overhead = cpucycles_overhead();

  for(i = 0; i < NTESTS; ++i) {
    randombytes(coins, sizeof(coins));
    poly_short(&a, coins);
    poly_short(&b, coins + N/2);

    poly_naivemul(&c1, &a, &b);

    poly_ntt(&a, &a);
    t[i % HISTORY] = cpucycles_start();
    poly_ntt(&b, &b);
    t[i % HISTORY] = cpucycles_stop() - t[i % HISTORY] - overhead;
    poly_reduce(&a);
    poly_basemul(&c2, &a, &b);
    poly_freeze(&c2);
    poly_invntt(&c2, &c2);

    for(j = 0; j < N; ++j)
      if((c2.coeffs[j] - c1.coeffs[j]) % Q)
        printf("Failure in multiplication: c2[%d] = %hd != %hd\n",
               j, c1.coeffs[j], c2.coeffs[j]);

    poly_baseinv(&b, &a);
    poly_basemul(&c2, &a, &b);
    poly_reduce(&c2);
    poly_invntt(&c2, &c2);

    for(j = 1; j < N; ++j)
      if(c2.coeffs[j] % Q)
        printf("Failure in inverse: c2[%u] = %hd\n", j, c2.coeffs[j]);
  }

  print_results("ntt:", t, HISTORY);
  return 0;
}
