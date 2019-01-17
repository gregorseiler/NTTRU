#include <stdint.h>
#include <stdio.h>
#include "../randombytes.h"
#include "../crypto_stream.h"
#include "../params.h"
#include "../poly.h"
#include "../ntt.h"

#define NTESTS 1000

int main(void) {
  unsigned int i, j;
  unsigned char coins[N/2], buf[LOGQ*N/8];
  poly a, b;

  init_ntt();

  for(i = 0; i < NTESTS; ++i) {
    randombytes(coins, sizeof(coins));
    poly_short(&a, coins);
    poly_pack_short(buf, &a);
    poly_unpack_short(&b, buf);
    for(j = 0; j < N; ++j)
      if(a.coeffs[j] != b.coeffs[j])
        printf("Polynomials don't match: b[%d] = %hd != %hd\n",
               j, b.coeffs[j], a.coeffs[j]);

    poly_ntt(&a, &a);
    poly_freeze(&a);
    poly_pack_uniform(buf, &a);
    poly_unpack_uniform(&b, buf);
    for(j = 0; j < N; ++j)
      if(a.coeffs[j] != b.coeffs[j])
        printf("Polynomials don't match: b[%d] = %hd != %hd\n",
               j, b.coeffs[j], a.coeffs[j]);

  }

  return 0;
}
