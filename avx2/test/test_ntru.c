#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "cpucycles.h"
#include "speed.h"
#include "../randombytes.h"
#include "../params.h"
#include "../ntru.h"
#include "../poly.h"

#define NTESTS 512
#define HISTORY 512

int main(void) {
  unsigned int i, j;
  unsigned char coins[2*N];
  poly hhat, fhat, chat, m, m2;
  unsigned long long tkeygen[HISTORY], tenc[HISTORY], tdec[HISTORY];
  unsigned long long timing_overhead;

  timing_overhead = cpucycles_overhead();

  for(i = 0; i < NTESTS; ++i) {
    j = i % HISTORY;
    randombytes(coins, sizeof(coins));
    poly_short(&m, coins);

    tkeygen[j] = cpucycles_start();
    ntru_keygen(&hhat, &fhat, coins + N/2);
    tkeygen[j] = cpucycles_stop() - tkeygen[j] - timing_overhead;

    tenc[j] = cpucycles_start();
    ntru_encrypt(&chat, &hhat, &m, coins + 3*N/2);
    tenc[j] = cpucycles_stop() - tenc[j] - timing_overhead;

    tdec[j] = cpucycles_start();
    ntru_decrypt(&m2, &chat, &fhat);
    tdec[j] = cpucycles_stop() - tdec[j] - timing_overhead;

    for(j = 0; j < N; ++j)
      if(m.coeffs[j] != m2.coeffs[j])
        printf("Messages don't match: m[%u] = %hd != %hd\n",
               j, m.coeffs[j], m2.coeffs[j]);
  }

  print_results("keygen: ", tkeygen, HISTORY);
  print_results("enc: ", tenc, HISTORY);
  print_results("dec: ", tdec, HISTORY);
  return 0;
}
