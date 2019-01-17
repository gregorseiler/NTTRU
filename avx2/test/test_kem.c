#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "cpucycles.h"
#include "speed.h"
#include "../randombytes.h"
#include "../params.h"
#include "../kem.h"

#define NTESTS 1024
#define HISTORY 1024

int main(void) {
  unsigned int i, j;
  unsigned char k1[SHAREDKEYBYTES], k2[SHAREDKEYBYTES], c[CIPHERTEXTBYTES];
  unsigned char pk[PUBLICKEYBYTES], sk[SECRETKEYBYTES];
  unsigned long long tkeygen[HISTORY], tenc[HISTORY], tdec[HISTORY];
  unsigned long long timing_overhead;

  timing_overhead = cpucycles_overhead();

  for(i = 0; i < NTESTS; ++i) {
    j = i % HISTORY;

    tkeygen[j] = cpucycles_start();
    crypto_kem_keypair(pk, sk);
    tkeygen[j] = cpucycles_stop() - tkeygen[j] - timing_overhead;

    tenc[j] = cpucycles_start();
    crypto_kem_enc(c, k1, pk);
    tenc[j] = cpucycles_stop() - tenc[j] - timing_overhead;

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

  return 0;
}
