#include "randombytes.h"
#include "params.h"
#include "poly.h"

int ntru_keygen(poly *hhat, poly *fhat, const unsigned char coins[N]) {
  int r;
  poly f, g;

  poly_short(&f, coins);
  poly_short(&g, coins + N/2);
  poly_triple(&g, &g);
  poly_triple(&f, &f);
  f.coeffs[0] += 1;
  poly_ntt(fhat, &f);
  poly_ntt(&g, &g);
  poly_freeze(fhat);
  r = poly_baseinv(&f, fhat);
  poly_basemul(hhat, &f, &g);
  poly_freeze(hhat);
  return r;
}

void ntru_encrypt(poly *chat,
                  const poly *hhat,
                  const poly *m,
                  const unsigned char coins[N/2])
{
  poly r, mhat;

  poly_short(&r, coins);
  poly_ntt(&r, &r);
  poly_ntt(&mhat, m);
  poly_basemul(chat, &r, hhat);
  poly_reduce(chat);
  poly_add(chat, chat, &mhat);
  poly_freeze(chat);
}

void ntru_decrypt(poly *m,
                  const poly *chat,
                  const poly *fhat)
{
  poly_basemul(m, chat, fhat);
  poly_reduce(m);
  poly_invntt(m, m);
  poly_crepmod3(m, m);
}
