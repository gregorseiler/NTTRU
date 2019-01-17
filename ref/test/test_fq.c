#include <stdint.h>
#include <stdio.h>
#include "../params.h"
#include "../fq.h"

#define NTESTS 10000

int main(void) {
  unsigned int i;
  int16_t a, b;

  for(i = 0; i < NTESTS; ++i) {
    a = fquniform();
    b = fqinv(a);
    b = fqmul(a,b);
    b = fqmul(b,1);
    if(((b - 1) % Q || !a) && (b % Q || a))
      printf("Failure in fqinv for a = %hd\n\n", a);
  }
}
