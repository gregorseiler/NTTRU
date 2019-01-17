#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "cpucycles.h"
#include "speed.h"
#include "../randombytes.h"
#include "../params.h"
#include "../kem.h"
#include "../ntt.h"

#define NTESTS 512
#define HISTORY 512

unsigned long long timing_overhead;
#ifdef DBENCH
unsigned long long *tred, *tadd, *tmul, *tinv, *tsample, *tpack;
#endif

int main(void) {
  unsigned int i, j;
  unsigned char k1[SHAREDKEYBYTES], k2[SHAREDKEYBYTES], c[CIPHERTEXTBYTES];
  unsigned char pk[PUBLICKEYBYTES], sk[SECRETKEYBYTES];
  unsigned long long tkeygen[HISTORY], tenc[HISTORY], tdec[HISTORY];
#ifdef DBENCH
  unsigned long long t[6][HISTORY], dummy;

  tred = tadd = tmul = tinv = tsample = tpack = &dummy;
#endif

  init_ntt();
  timing_overhead = cpucycles_overhead();

  for(i = 0; i < NTESTS; ++i) {
    j = i % HISTORY;

#ifdef DBENCH
    if(!j) memset(t, 0, sizeof(t));
#endif

    tkeygen[j] = cpucycles_start();
    crypto_kem_keypair(pk, sk);
    tkeygen[j] = cpucycles_stop() - tkeygen[j] - timing_overhead;

#ifdef DBENCH
    tred = t[0] + j;
    tadd = t[1] + j;
    tmul = t[2] + j;
    tinv = t[3] + j;
    tsample = t[4] + j;
    tpack = t[5] + j;
#endif

    tenc[j] = cpucycles_start();
    crypto_kem_enc(c, k1, pk);
    tenc[j] = cpucycles_stop() - tenc[j] - timing_overhead;

#ifdef DBENCH
    tred = tadd = tmul = tinv = tsample = tpack = &dummy;
#endif

    tdec[j] = cpucycles_start();
    crypto_kem_dec(k2, c, sk);
    tdec[j] = cpucycles_stop() - tdec[j] - timing_overhead;

    for(j = 0; j < SHAREDKEYBYTES; ++j)
      if(k1[j] != k2[j])
        printf("Failure: Keys dont match: %hhx != %hhx!\n", k1[j], k2[j]);
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
