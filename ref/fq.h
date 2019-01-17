#ifndef REDUCE_H
#define REDUCE_H

#include <stdint.h>

#define MONT 4088 // 2^16 % Q
#define QINV 57857 // q^(-1) mod 2^16

int16_t fqmontred(int32_t a);
int16_t fqred16(int16_t a);
int16_t fqcsubq(int16_t a);
int16_t fqmul(int16_t a, int16_t b);
int16_t fqinv(int16_t a);
int16_t fquniform(void);

#endif
