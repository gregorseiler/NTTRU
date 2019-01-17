.global poly_short
poly_short:

vmovdqa		_8xL(%rip),%ymm0
vmovdqa		_8x15(%rip),%ymm1
vmovdqa		_16x3(%rip),%ymm2
vpsrlw		$1,%ymm2,%ymm3

xor		%eax,%eax
.p2align 5
_looptop:
vpmovzxbd	(%rsi),%ymm4

vpsrld		$4,%ymm4,%ymm5
vpand		%ymm1,%ymm4,%ymm4
vpsrlvd		%ymm4,%ymm0,%ymm4
vpsrlvd		%ymm5,%ymm0,%ymm5
vpslld		$16,%ymm5,%ymm5
vpor		%ymm4,%ymm5,%ymm4
vpand		%ymm2,%ymm4,%ymm4
vpsubw		%ymm3,%ymm4,%ymm4

vmovdqa		%ymm4,(%rdi)

add		$8,%rsi
add		$32,%rdi
add		$16,%eax
cmp		$768,%eax
jb		_looptop

ret
