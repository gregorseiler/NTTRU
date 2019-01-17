#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "cpucycles.h"
#include "speed.h"
#include "../randombytes.h"
#include "../params.h"
#include "../crypto_stream.h"
#include "../ntru.h"
#include "../poly.h"
#include "../ntt.h"

#define NTESTS 512
#define HISTORY 512

unsigned long long timing_overhead;
#ifdef DBENCH
unsigned long long *tred, *tadd, *tmul, *tinv, *tsample, *tpack, *tshake;
#endif

int main(void) {
  unsigned int i, j;
  unsigned char coins[2*N];
  poly hhat, fhat, chat, m, m2;
  unsigned long long tkeygen[HISTORY], tenc[HISTORY], tdec[HISTORY];
#ifdef DBENCH
  unsigned long long t[7][HISTORY], dummy;

  tred = tadd = tmul = tinv = tsample = tpack = &dummy;
#endif

  init_ntt();
  timing_overhead = cpucycles_overhead();

  for(i = 0; i < NTESTS; ++i) {
    j = i % HISTORY;
    randombytes(coins, sizeof(coins));
    poly_short(&m, coins);
    
#ifdef DBENCH
    if(!j) memset(t, 0, sizeof(t));
#endif

#ifdef DBENCH
    tred = t[0] + j;
    tadd = t[1] + j;
    tmul = t[2] + j;
    tinv = t[3] + j;
    tsample = t[4] + j;
    tpack = t[5] + j;
#endif

    tkeygen[j] = cpucycles_start();
    ntru_keygen(&hhat, &fhat, coins + N/2);
    tkeygen[j] = cpucycles_stop() - tkeygen[j] - timing_overhead;

#ifdef DBENCH
    tred = tadd = tmul = tinv = tsample = tpack = tshake = &dummy;
#endif

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

#ifdef DBENCH
  print_results("modular reduction:", t[0], HISTORY);
  print_results("addition:", t[1], HISTORY);
  print_results("multiplication:", t[2], HISTORY);
  print_results("inversion:", t[3], HISTORY);
  print_results("sampling:", t[4], HISTORY);
  print_results("packing:", t[5], HISTORY);
#endif

  return 0;
}
