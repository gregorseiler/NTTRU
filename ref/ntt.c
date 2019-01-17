#include <stdint.h>
#include "params.h"
#include "fq.h"
#include "ntt.h"

static const unsigned int tree[256] = {1, 128, 64, 320, 32, 224, 160, 352, 16, 208, 112, 304, 80, 272, 176, 368, 8, 200, 104, 296, 56, 248, 152, 344, 40, 232, 136, 328, 88, 280, 184, 376, 4, 196, 100, 292, 52, 244, 148, 340, 28, 220, 124, 316, 76, 268, 172, 364, 20, 212, 116, 308, 68, 260, 164, 356, 44, 236, 140, 332, 92, 284, 188, 380, 2, 194, 98, 290, 50, 242, 146, 338, 26, 218, 122, 314, 74, 266, 170, 362, 14, 206, 110, 302, 62, 254, 158, 350, 38, 230, 134, 326, 86, 278, 182, 374, 10, 202, 106, 298, 58, 250, 154, 346, 34, 226, 130, 322, 82, 274, 178, 370, 22, 214, 118, 310, 70, 262, 166, 358, 46, 238, 142, 334, 94, 286, 190, 382, 1, 193, 97, 289, 49, 241, 145, 337, 25, 217, 121, 313, 73, 265, 169, 361, 13, 205, 109, 301, 61, 253, 157, 349, 37, 229, 133, 325, 85, 277, 181, 373, 7, 199, 103, 295, 55, 247, 151, 343, 31, 223, 127, 319, 79, 271, 175, 367, 19, 211, 115, 307, 67, 259, 163, 355, 43, 235, 139, 331, 91, 283, 187, 379, 5, 197, 101, 293, 53, 245, 149, 341, 29, 221, 125, 317, 77, 269, 173, 365, 17, 209, 113, 305, 65, 257, 161, 353, 41, 233, 137, 329, 89, 281, 185, 377, 11, 203, 107, 299, 59, 251, 155, 347, 35, 227, 131, 323, 83, 275, 179, 371, 23, 215, 119, 311, 71, 263, 167, 359, 47, 239, 143, 335, 95, 287, 191, 383};

int16_t zetas[256];
int16_t zetas_inv[256];

void init_ntt() {
  unsigned int i, j, k;
  int16_t tmp[384];

  tmp[0] = MONT;
  for(i = 1; i < 384; ++i)
    tmp[i] = fqmul(tmp[i-1], ROOT_OF_UNITY*MONT % Q);

  for(i = 0; i < 256; ++i)
    zetas[i] = tmp[tree[i]];

  k = 0;
  for(i = 128; i >= 2; i >>= 1)
    for(j = i; j < 2*i; ++j)
      zetas_inv[k++] = -tmp[384 - tree[j]];

  zetas_inv[254] = 2*zetas[1] - tmp[0];
  zetas_inv[254] = fqinv(zetas_inv[254]);
}

void ntt(int16_t b[768], const int16_t a[768]) {
  unsigned int len, start, j, k;
  int16_t t, zeta;

  for(j = 0; j < 384; ++j) {
    t = fqmul(zetas[1], a[j + 384]);
    b[j + 384] = a[j] + a[j + 384] - t;
    b[j] = a[j] + t;
  }

  k = 2;
  for(len = 192; len >= 3; len >>= 1) {
    for(start = 0; start < 768; start = j + len) {
      zeta = zetas[k++];
      for(j = start; j < start + len; ++j) {
        t = fqmul(zeta, b[j + len]);
        b[j + len] = fqred16(b[j] - t);
        b[j] = fqred16(b[j] + t);
      }
    }
  }
}

void invntt(int16_t b[768], const int16_t a[768]) {
  unsigned int start, len, j, k;
  int16_t t, zeta;

  for(j = 0; j < 768; ++j)
    b[j] = a[j];

  k = 0;
  for(len = 3; len <= 192; len <<= 1) {
    for(start = 0; start < 768; start = j + len) {
      zeta = zetas_inv[k++];
      for(j = start; j < start + len; ++j) {
        t = b[j];
        b[j] = fqred16(t + b[j + len]);
        b[j + len] = t - b[j + len];
        b[j + len] = fqmul(zeta, b[j + len]);
      }
    }
  }

  for(j = 0; j < 384; ++j) {
    t = b[j] - b[j + 384];
    t = fqmul(zetas_inv[254], t);
    b[j] = b[j] + b[j + 384];
    b[j] = b[j] - t;
    b[j] = fqmul((1U << 24) % Q, b[j]);
    b[j + 384] = fqmul((1U << 25) % Q, t);
  }
}

void ntt_pack(int16_t b[768], const int16_t a[768]) {
  unsigned i, j, k;
  int16_t buf[96];

  for(i = 0; i < 768/96; ++i) {
    for(j = 0; j < 96; ++j)
      buf[j] = a[96*i + j];

    for(j = 0; j < 6; ++j)
      for(k = 0; k < 16; ++k)
        b[96*i + 16*j + k] = buf[6*k + j];
  }
}

void ntt_unpack(int16_t b[768], const int16_t a[768]) {
  unsigned j, k, l;
  int16_t buf[96];

  for(j = 0; j < 768/96; ++j) {
    for(k = 0; k < 6; ++k)
      for(l = 0; l < 16; ++l)
        buf[6*l + k] = a[96*j + 16*k + l];

    for(k = 0; k < 96; ++k)
      b[96*j + k] = buf[k];
  }
}

void basemul(int16_t c[3],
             const int16_t a[3],
             const int16_t b[3],
             int16_t zeta)
{
  c[0]  = fqmul(a[2], b[1]);
  c[0] += fqmul(a[1], b[2]);
  c[0]  = fqmul(c[0], zeta);
  c[0] += fqmul(a[0], b[0]);

  c[1]  = fqmul(a[2], b[2]);
  c[1]  = fqmul(c[1], zeta);
  c[1] += fqmul(a[0], b[1]);
  c[1] += fqmul(a[1], b[0]);
  //c[1]  = fqred16(c[1]);

  c[2]  = fqmul(a[2], b[0]);
  c[2] += fqmul(a[1], b[1]);
  c[2] += fqmul(a[0], b[2]);
  //c[2]  = fqred16(c[2]);
}

int baseinv(int16_t b[3], const int16_t a[3], int16_t zeta) {
  int16_t det, t;
  int r;

  b[0]  = fqmul(a[0], a[0]);
  t     = fqmul(a[1], a[2]);
  t     = fqmul(t, zeta);
  b[0] -= t;

  b[1]  = fqmul(a[2], a[2]);
  b[1]  = fqmul(b[1], zeta);
  t     = fqmul(a[0], a[1]);
  b[1] -= t;

  b[2]  = fqmul(a[1], a[1]);
  t     = fqmul(a[0], a[2]);
  b[2] -= t;

  det   = fqmul(b[2], a[1]);
  t     = fqmul(b[1], a[2]);
  det  += t;
  det   = fqmul(det, zeta);
  t     = fqmul(b[0], a[0]);
  det  += t;

  det   = fqinv(det);
  b[0]  = fqmul(b[0], det);
  b[1]  = fqmul(b[1], det);
  b[2]  = fqmul(b[2], det);

  r = (uint16_t)det;
  r = (uint32_t)(-r) >> 31;
  return r - 1;
}
